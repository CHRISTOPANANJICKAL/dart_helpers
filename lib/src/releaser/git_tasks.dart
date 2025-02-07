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

  static Future<String?> getCurrentBranch() async {
    final result = await ProcessRunner().runProcess('git branch --show-current');
    if (result.success) return result.output;
    Commander.command('Failed to get git branch: ${result.error?.toString()}');
    return null;
  }

  static Future<bool> askCurrentBranchName() async {
    String currentBranch = Commander.ask('  Type in current branch name to continue', color: VClr.subQuestion);
    String? actualBranch = await getCurrentBranch();
    if (actualBranch == null) return false;

    if (currentBranch.toString().trim() == actualBranch) return true;

    return false;
  }
}
