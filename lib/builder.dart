import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';

class TxtFileGenerator implements Builder {
  @override
  final buildExtensions = const {
    r'$package$': [filePath],
  };

  static const String filePath = 'lib/gen/app_version.dart';

  @override
  Future<void> build(BuildStep buildStep) async {
    File file = File(filePath);

    if (file.existsSync()) {
      List<String> contents = file.readAsLinesSync();
    }

    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, filePath),
      '',
    );
  }

  static String contentString = '''

  ''';
}

/// Factory function for build.yaml
Builder txtFileBuilder(BuilderOptions options) => TxtFileGenerator();
