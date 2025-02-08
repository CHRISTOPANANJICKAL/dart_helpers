// Created by: Christo Pananjickal, Created at: 07-02-2025 06:57 pm

import 'dart:io';

import 'package:dart_helpers/dart_helpers.dart';

class ZipperTasks {
  static Future<String?> zipFolder({
    required String fromDir,
    required String outFolder,
    required String outFileName,
  }) async {
    final outDirectory = Directory(outFolder);
    if (!outDirectory.existsSync()) outDirectory.createSync(recursive: true);

    File file = File(outFolder + outFileName);
    if (file.existsSync()) file.deleteSync(recursive: true);

    Directory fromDirectory = Directory(fromDir);

    ProcessOutput op = await ProcessRunner()
        .runProcess('tar -a -c -f "${file.path}" -C "${fromDirectory.path}" .', commandName: 'Zipping $outFileName');

    return op.error;
  }

  static Future<String?> unZipFile({required String zipFile, required String outFolder}) async {
    final outDirectory = Directory(outFolder);
    if (!outDirectory.existsSync()) outDirectory.createSync(recursive: true);

    final file = File(zipFile);
    ProcessOutput op = await ProcessRunner().runProcess(
      'tar -xf "${file.path}" -C "${outDirectory.path}"',
      commandName: 'Unzipping ${file.uri.pathSegments.last}',
    );

    return op.error;
  }
}
