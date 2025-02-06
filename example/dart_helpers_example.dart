import 'package:dart_helpers/src/version_utils/c_version.dart';

void main() {
  CVersion version = CVersion.fromString('1.0.0+0')!;
  for (int i = 0; i < 10000; i++) {
    version = version.nextVersion();
    print(version.versionTotal());
  }
}
