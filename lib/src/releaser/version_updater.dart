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
  }) {
    filePath = filePath ?? 'lib/gen/app_version.dart';

    File versionFile = File(filePath);
    if (!versionFile.existsSync()) return 'Version file does not exist';

    List<String> lines = versionFile.readAsLinesSync();
    String? versionLine = lines.firstWhereOrNull((e) => e.contains('static CVersion _version = CVersion('));
    if (versionLine == null) return 'Version line not found';
    int versionLineIndex = lines.indexOf(versionLine);
    String newVersionLine =
        '  static CVersion _version = CVersion(maj: ${toVersion.maj}, min: ${toVersion.min}, patch: ${toVersion.patch}, build: ${toVersion.build});';

    lines[versionLineIndex] = newVersionLine;

    versionFile.writeAsStringSync(lines.join('\r\n'));

    Commander.doing('App version updated from ${fromVersion.versionTotal()} to ${toVersion.versionTotal()}');

    return null;
  }
}
