import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';

class AppVersionGenerator implements Builder {
  final bool isEnabled;

  AppVersionGenerator(this.isEnabled);

  @override
  final buildExtensions = const {
    r'$package$': [filePath],
  };

  static const String filePath = 'lib/gen/app_version.dart';

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!isEnabled) return;

    File file = File(filePath);
    bool isEmpty = true;

    if (file.existsSync()) {
      isEmpty = false;
      List<String> contents = file.readAsLinesSync();
      contents = contents.where((e) => e.trim().isNotEmpty).toList();
      if (contents.isEmpty) isEmpty = true;
    }

    if (isEmpty) await buildStep.writeAsString(AssetId(buildStep.inputId.package, filePath), contentString);
  }

  static String contentString = '''
// This file is auto-generated. DO NOT MODIFY BY HAND

import 'package:dart_helpers/dart_helpers.dart';

class AppVersionUtils {
  static CVersion _version = CVersion(maj: 0, min: 0, patch: 0, build: 0);
  static CVersion _pubVersion = CVersion(maj: 0, min: 0, patch: 0, build: 0);

  static void setPubspecVersion(CVersion version) async {
    _pubVersion = _pubVersion.copyWith(
      maj: version.maj,
      min: version.min,
      patch: version.patch,
      build: version.build,
    );
  }

  static void setCVersion(CVersion version) async {
    _version = _version.copyWith(
      maj: version.maj,
      min: version.min,
      patch: version.patch,
      build: version.build,
    );
  }

  static CVersion getCVersion() => _version;
  static CVersion getPubVersion() => _pubVersion;
}
  ''';
}

/// Factory function for build.yaml
Builder appVersionBuilder(BuilderOptions options) {
  final isEnabled = options.config['enabled'] as bool? ?? false;
  return AppVersionGenerator(isEnabled);
}
