// Created by: Christo Pananjickal, Created at: 07-02-2025 12:38 am

import 'package:dart_helpers/dart_helpers.dart';

class BuildTask {
  static Future<bool> checkFlutterVersion({required String flutterVersion}) async {
    final result = await ProcessRunner().runProcess('flutter --version', commandName: 'Checking flutter version');

    if (!result.success) {
      Commander.command('Failed to get flutter version');
      return false;
    }

    if (result.output != null) return result.output!.contains(flutterVersion);

    return false;
  }

  static Future<String?> buildExeFile() async {
    await ProcessRunner().runProcess('flutter build ');
  }
}
