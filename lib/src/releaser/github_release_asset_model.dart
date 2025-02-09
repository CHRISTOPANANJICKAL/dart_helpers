// Created by: Christo Pananjickal, Created at: 06-02-2025 04:15 pm

class GithubReleaseModel {
  final List<GithubAsset> assets;

  GithubReleaseModel({required this.assets});

  factory GithubReleaseModel.fromJson(Map<String, dynamic> json) =>
      GithubReleaseModel(assets: List<GithubAsset>.from((json['assets'] ?? []).map((x) => GithubAsset.fromJson(x))));
}

class GithubAsset {
  final String url;
  final String name;

  GithubAsset({required this.url, required this.name});

  factory GithubAsset.fromJson(Map<String, dynamic> json) =>
      GithubAsset(url: json['url'] ?? '', name: json['name'] ?? '');
}
