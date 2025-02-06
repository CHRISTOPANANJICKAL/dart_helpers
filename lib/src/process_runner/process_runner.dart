// Created by: Christo Pananjickal, Created at: 06-02-2025 02:12 am

import 'dart:io';

import 'package:dart_helpers/dart_helpers.dart';

class ProcessRunner {
  Vlogger logger = Vlogger();
  bool logOutput = false;

  Future<ProcessOutput> runProcess(String text, {String? commandName, bool ignoreStdError = false}) async {
    List<String> args = [];
    RegExp regex = RegExp(r'"([^"]*)"|\S+');
    for (final match in regex.allMatches(text)) {
      if (match.group(1) != null) {
        args.add(match.group(1)!);
      } else {
        args.add(match.group(0)!);
      }
    }

    String majorCommand = args.first.replaceAll('/', '\\');
    if (args.length > 1) args = args.sublist(1, args.length);

    try {
      if (logOutput) logger.log(commandName ?? 'Running $text', color: VlogColors.grey);

      ProcessResult processResult = await Process.run(majorCommand, args, runInShell: true);

      if (processResult.stderr.toString().trim().isNotEmpty && !ignoreStdError) {
        if (logOutput) logger.log('$text Failed', color: VlogColors.red);
        return ProcessOutput(success: false, error: '$text Failed. ${processResult.stderr.toString()}');
      }
      return ProcessOutput(success: true, output: processResult.stdout.toString());
    } catch (a) {
      if (logOutput) logger.log('$text Failed. ${a.toString()}', color: VlogColors.red);
      return ProcessOutput(success: false, error: '$text Failed');
    }
  }
}

class ProcessOutput {
  String? error;
  String? output;
  bool success;

  ProcessOutput({required this.success, this.error, this.output});
}
