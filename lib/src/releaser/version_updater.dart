// Created by: Christo Pananjickal, Created at: 06-02-2025 09:42 pm

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_helpers/src/releaser/commander.dart';
import 'package:dart_helpers/src/version_utils/c_version.dart';

class AppVersionUpdater {
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
          CVersion(maj: fromVersion.maj, min: fromVersion.maj, patch: fromVersion.patch, build: toVersion.patch);
      Commander.doing('App build number updated. ${fromVersion.versionTotal()} to ${v.versionTotal()}');
    } else {
      Commander.doing('App version updated from ${fromVersion.versionTotal()} to ${toVersion.versionTotal()}');
    }

    return null;
  }
}
