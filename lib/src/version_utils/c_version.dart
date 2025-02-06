class CVersion {
  final int maj;
  final int min;
  final int patch;
  final int build;

  CVersion({required this.maj, required this.min, required this.patch, required this.build});

  CVersion copyWith({int? maj, int? min, int? patch, int? build}) {
    return CVersion(
      maj: maj ?? this.maj,
      min: min ?? this.min,
      patch: patch ?? this.patch,
      build: build ?? this.build,
    );
  }

  String versionString() => '$maj.$min.$patch';
  String buildNumberString() => '$build';
  String versionTotal() => '${versionString()}+${buildNumberString()}';

  CVersion nextVersion() {
    int newMaj = maj;
    int newMin = min;
    int newPatch = patch + 1;
    int newBuild = build + 1;

    if (newPatch > 9) {
      newPatch = 0;
      newMin += 1;
    }

    if (newMin > 9) {
      newMin = 0;
      newMaj += 1;
    }

    return CVersion(maj: newMaj, min: newMin, patch: newPatch, build: newBuild);
  }

  static CVersion? fromString(String a) {
    try {
      List<String> parts = a.trim().split('+');
      List<String> versionParts = parts[0].split('.');

      int maj = int.parse(versionParts[0]);
      int min = int.parse(versionParts[1]);
      int patch = int.parse(versionParts[2]);
      int build = int.parse(parts[1]);

      return CVersion(maj: maj, min: min, patch: patch, build: build);
    } catch (_) {
      return null;
    }
  }
}
