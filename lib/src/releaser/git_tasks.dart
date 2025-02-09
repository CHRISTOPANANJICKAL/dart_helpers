// Created by: Christo Pananjickal, Created at: 06-02-2025 10:10 pm

import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dart_helpers/dart_helpers.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import 'github_release_asset_model.dart';

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
    String? ownerSlashRepo,
  }) async {
    String versionSummary = '${version.versionString()}.${version.build}';

    late ProcessOutput op;
    if (ownerSlashRepo != null) {
      op = await ProcessRunner().runProcess(
        'gh release create $versionSummary --repo "$ownerSlashRepo" "${boxedFile.absolute.path}" --title "${version.versionTotal()}" --notes "This is version ${version.versionTotal()}" --target "$branch"',
        commandName: 'Pushing release $versionSummary',
      );
    } else {
      op = await ProcessRunner().runProcess(
        'gh release create $versionSummary "${boxedFile.absolute.path}" --title "${version.versionTotal()}" --notes "This is version ${version.versionTotal()}" --target "$branch"',
        commandName: 'Pushing release $versionSummary',
      );
    }

    return op.error;
  }

  static Future<String?> download({
    required Directory destination,
    required String repoName,
    required String version,
    required String fileName,
    required String token,
  }) async {
    if (!destination.existsSync()) destination.createSync(recursive: true);

    File file = File(join(destination.path, fileName));

    if (file.existsSync()) file.deleteSync(recursive: true);

    try {
      Commander.doing('Downloading $fileName');
      String releasesUrl = 'https://api.github.com/repos/Caddayn/$repoName/releases/tags/$version';
      Dio dio = Dio();
      final releaseAssetResponse =
          await dio.get(releasesUrl, options: Options(headers: {'Authorization': 'Bearer $token'}));
      GithubReleaseModel releaseModel = GithubReleaseModel.fromJson(releaseAssetResponse.data);
      String? assetUrl = releaseModel.assets
          .firstWhereOrNull((e) => e.name.trim().toLowerCase() == fileName.trim().toLowerCase())
          ?.url;

      if (assetUrl == null) return '$fileName is not found the the releases';

      final downloadResponse = await dio.get<Uint8List>(
        assetUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/octet-stream'},
          responseType: ResponseType.bytes,
        ),
      );
      if (downloadResponse.statusCode != 200 || downloadResponse.data == null) {
        return 'Failed to download $fileName. Status code: ${downloadResponse.statusCode}';
      }
      file.writeAsBytesSync(downloadResponse.data!);
    } catch (e) {
      return 'Failed to download $fileName. ${e.toString()}';
    }

    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      if (bytes.length > 1045504) return null;
      file.deleteSync(recursive: true);
      return 'Downloaded file was less than 1 MB';
    }

    return 'Failed to download $fileName';
  }

  static Future<ProcessOutput> getToken() async {
    final op = await ProcessRunner().runProcess('gh auth token');
    if (op.output != null) op.output = op.output!.trim();
    return op;
  }
}
