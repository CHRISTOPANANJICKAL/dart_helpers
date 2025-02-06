// Created by: Christo Pananjickal, Created at: 06-02-2025 02:02 am

class Vlogger {
  static const String _resetCode = '\u001b[0m';
  final bool enable;
  final LogColors defaultColor;
  Vlogger({this.enable = true, this.defaultColor = LogColors.white});

  /// ============================================== STRING CONSTANTS ==========================
  static const String _pattern = '―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――';
  final String _openPattern = '⬐$_pattern⬎\n';
  final String _closePattern = '\n⬑$_pattern⬏';

  void log(String message, {LogColors? color, bool logLocation = false, bool logPattern = false}) {
    if (!enable) return;

    String output = '';
    if (logPattern) output = output + _openPattern;
    output = output + (color?.color ?? defaultColor.color) + message + _resetCode;
    if (logLocation) output = '$output  🌳${LogColors.red.color}${_logCallingLocation()}🌳$_resetCode';
    if (logPattern) output = output + _closePattern;

    // ignore: avoid_print
    print(output);
  }
}

String _logCallingLocation() {
  final trace = StackTrace.current;
  final frames = trace.toString().split('\n');

  if (frames.length > 2) {
    final callingFrame = frames[2];
    final callingLocation = callingFrame.replaceAllMapped(RegExp(r'#\d+\s+([^<]+>)?\s+'), (match) => '');

    return callingLocation;
  } else {
    return 'logged from unknown location';
  }
}

enum LogColors {
  black(color: '\u001b[30m'),
  red(color: '\u001b[31m'),
  green(color: '\u001b[32m'),
  yellow(color: '\u001b[33m'),
  blue(color: '\u001b[34m'),
  magenta(color: '\u001b[35m'),
  cyan(color: '\u001b[36m'),
  white(color: '\u001b[89m'),
  whiteBright(color: '\u001b[97m'),
  grey(color: '\u001b[90m'),
  ;

  const LogColors({required this.color});

  final String color;
}
