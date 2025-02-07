// Created by: Christo Pananjickal, Created at: 07-02-2025 12:38 am

import 'dart:io';

import 'package:dart_helpers/dart_helpers.dart';

class BuildTask {
  static Future<bool> checkFlutterVersion({required String flutterVersion}) async {
    final result = await ProcessRunner().runProcess('flutter --version', commandName: 'Checking flutter version');

    if (!result.success) {
      Commander.command('Failed to get flutter version');
      return false;
    }

    if (result.output == null) return false;

    return result.output!.contains(flutterVersion);
  }

  static Future<String?> buildExeFile({
    required String outputName,
    required String? flutterVersion,
    bool branchCheck = true,
  }) async {
    if (branchCheck) {
      bool correctBranch = await GitTasks.askCurrentBranchName();
      if (!correctBranch) return 'Wrong branch name';
    }

    if (flutterVersion != null) {
      bool correctVersion = await checkFlutterVersion(flutterVersion: flutterVersion);
      if (!correctVersion) return 'Flutter version is not $flutterVersion';
    }

    ProcessOutput op = await ProcessRunner().runProcess('flutter clean');
    if (!op.success) return op.error;

    op = await ProcessRunner().runProcess('flutter pub get');
    if (!op.success) return op.error;

    op = await ProcessRunner().runProcess('dart run build_runner build --delete-conflicting-outputs');
    if (!op.success) return op.error;

    op = await ProcessRunner().runProcess('flutter build windows --release --obfuscate --split-debug-info=debug-info');
    if (!op.success) return op.error;

    Directory directory = Directory('debug-info');
    if (directory.existsSync()) {
      Commander.doing('Deleting debug info');
      directory.deleteSync(recursive: true);
    }

    final outputFile = File('build/windows/x64/runner/Release/$outputName');
    if (!outputFile.existsSync()) return 'Build failed. Output file was not generated';

    return null;
  }
}
