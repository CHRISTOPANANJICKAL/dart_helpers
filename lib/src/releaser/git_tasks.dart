// Created by: Christo Pananjickal, Created at: 06-02-2025 10:10 pm

import 'dart:io';

import 'package:dart_helpers/dart_helpers.dart';

class GitTasks {
  static Future<String?> commitFile({required String filepath, String? message}) async {
    File file = File(filepath);
    if (!file.existsSync()) return 'File does not exist';
    message = message ?? 'Commit by dart_helper';
    final op = await ProcessRunner().runProcess('git commit -m "$message" "$filepath"');
    if (op.success) return null;
    String error = op.error ?? 'Failed to commit file';
    Commander.command(error);
    return error;
  }
}
