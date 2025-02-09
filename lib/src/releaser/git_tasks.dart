// Created by: Christo Pananjickal, Created at: 06-02-2025 10:10 pm

import 'dart:io';

import 'package:dart_helpers/dart_helpers.dart';

class GitTasks {
  static Future<String?> commitFile({required String filepath, String? message}) async {
    File file = File(filepath);
    if (!file.existsSync()) return 'File does not exist';
    message = message ?? 'Commit by dart_helper';
    final op = await ProcessRunner().runProcess('git commit -m "$message" "$filepath"', commandName: 'Committing file');
    if (op.success) return null;
    String error = op.error ?? 'Failed to commit file';
    Commander.command(error);
    return error;
  }

  static Future<String?> pushCommits() async {
    Commander.doing('Running git push');
    final op = await ProcessRunner(logOutput: false).runProcess('git push');
    String? error = op.error;
    if (error != null) {
      error = error.trim();
      if (error.contains('Everything up-to-date')) return null;
      if (error.contains('->')) return null;
    }

    if (error != null && error.trim().isEmpty) return null;
    return error;
  }

  static Future<String?> getCurrentBranch({bool logCommand = true}) async {
    final result = await ProcessRunner(logOutput: logCommand).runProcess('git branch --show-current');
    if (result.success) return result.output;
    Commander.command('Failed to get git branch: ${result.error?.toString()}');
    return null;
  }

  static Future<bool> askCurrentBranchName({bool logBranchCommand = false}) async {
    String currentBranch = Commander.ask('  Type in current branch name to continue', color: VClr.subQuestion);
    String? actualBranch = await getCurrentBranch(logCommand: logBranchCommand);
    if (actualBranch == null) return false;

    if (currentBranch.toString().trim() == actualBranch.trim()) return true;

    return false;
  }

  static Future<String?> createTag({required CVersion version, required String message}) async {
    String versionSummary = '${version.versionString()}.${version.build}';

    final op = await ProcessRunner()
        .runProcess('git tag -a $versionSummary -m "$message"', commandName: 'Creating tag $versionSummary');
    return op.error;
  }

  static Future<String?> pushRelease({
    required CVersion version,
    required File boxedFile,
    required String branch,
  }) async {
    String versionSummary = '${version.versionString()}.${version.build}';

    final op = await ProcessRunner().runProcess(
      'gh release create $versionSummary "${boxedFile.absolute.path}" --title "${version.versionTotal()}" --notes "This is version ${version.versionTotal()}" --target "$branch"',
      commandName: 'Pushing release $versionSummary',
    );
    return op.error;
  }
}
