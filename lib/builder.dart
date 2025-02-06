// Created by: Christo Pananjickal, Created at: 06-02-2025 02:30 am

import 'package:build/build.dart';

Builder appVersionBuilder(BuilderOptions options) {
  return AppVersionBuilder();
}

class AppVersionBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.generated.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Your function logic here
    log.info('Build runner executed');
  }
}
