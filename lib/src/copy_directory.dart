// Created by: Christo Pananjickal, Created at: 31-01-2025 01:44 am

import 'dart:io';

import 'package:path/path.dart' as p;

class CopyTasks {
  static Future<String?> copyFolder({required String from, required String to, bool deepCopyLinks = true}) async {
    if (_doNothing(from, to)) return null;
    try {
      await Directory(to).create(recursive: true);
      await for (final file in Directory(from).list(recursive: true, followLinks: deepCopyLinks)) {
        final copyTo = p.join(to, p.relative(file.path, from: from));
        if (file is Directory) {
          await Directory(copyTo).create(recursive: true);
        } else if (file is File) {
          await File(file.path).copy(copyTo);
        } else if (file is Link) {
          await Link(copyTo).create(await file.target(), recursive: true);
        }
      }
      return null;
    } catch (e) {
      return 'Failed to copy. ${e.toString()}';
    }
  }

  static bool _doNothing(String from, String to) {
    if (p.canonicalize(from) == p.canonicalize(to)) {
      return true;
    }
    if (p.isWithin(from, to)) {
      throw ArgumentError('Cannot copy from $from to $to');
    }
    return false;
  }
}
