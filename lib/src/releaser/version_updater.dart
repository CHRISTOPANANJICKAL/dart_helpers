// Created by: Christo Pananjickal, Created at: 06-02-2025 09:42 pm

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_helpers/src/releaser/commander.dart';
import 'package:dart_helpers/src/version_utils/c_version.dart';

class AppVersionUpdater {
  static Future<void> generateAppVersionFile() async {
    File file = File('lib/gen/app_version.dart');
    bool isEmpty = true;
    if (file.existsSync()) {
      isEmpty = false;
      List<String> contents = file.readAsLinesSync();
      contents = contents.where((e) => e.trim().isNotEmpty).toList();
      if (contents.isEmpty) isEmpty = true;
    }

    if (!isEmpty) return;

    String contentString = '''
// This file is auto-generated. DO NOT MODIFY BY HAND

import 'package:dart_helpers/dart_helpers.dart';

class AppVersionUtils {
  static CVersion _version = CVersion(maj: 0, min: 0, patch: 0, build: 0);
  static CVersion _pubVersion = CVersion(maj: 0, min: 0, patch: 0, build: 0);

  static void setPubspecVersion(CVersion version) async {
    _pubVersion = _pubVersion.copyWith(
      maj: version.maj,
      min: version.min,
      patch: version.patch,
      build: version.build,
    );
  }

  static void setCVersion(CVersion version) async {
    _version = _version.copyWith(
      maj: version.maj,
      min: version.min,
      patch: version.patch,
      build: version.build,
    );
  }

  static CVersion getCVersion() => _version;
  static CVersion getPubVersion() => _pubVersion;
}
  ''';

    file.writeAsStringSync(contentString);
  }

  static String? updateAppVersionInFile({
    required CVersion fromVersion,
    required CVersion toVersion,
    String? filePath,
    bool updateBuildNumberAlone = false,
  }) {
    filePath = filePath ?? 'lib/gen/app_version.dart';

    File versionFile = File(filePath);
    if (!versionFile.existsSync()) return 'Version file does not exist';

    List<String> lines = versionFile.readAsLinesSync();
    String? versionLine = lines.firstWhereOrNull((e) => e.contains('static CVersion _version = CVersion('));
    if (versionLine == null) return 'Version line not found';
    int versionLineIndex = lines.indexOf(versionLine);
    String newVersionLine = updateBuildNumberAlone
        ? '  static CVersion _version = CVersion(maj: ${fromVersion.maj}, min: ${fromVersion.min}, patch: ${fromVersion.patch}, build: ${toVersion.build});'
        : '  static CVersion _version = CVersion(maj: ${toVersion.maj}, min: ${toVersion.min}, patch: ${toVersion.patch}, build: ${toVersion.build});';

    lines[versionLineIndex] = newVersionLine;

    versionFile.writeAsStringSync(lines.join('\r\n'));

    if (updateBuildNumberAlone) {
      CVersion v =
          CVersion(maj: fromVersion.maj, min: fromVersion.maj, patch: fromVersion.patch, build: toVersion.build);
      Commander.doing('App build number updated. ${fromVersion.versionTotal()} to ${v.versionTotal()}');
    } else {
      Commander.doing('App version updated from ${fromVersion.versionTotal()} to ${toVersion.versionTotal()}');
    }

    return null;
  }
}
