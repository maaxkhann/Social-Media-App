import 'package:flutter/foundation.dart';

String getCurrentMethodName() {
  final frames = StackTrace.current.toString().split('\n');
  final frame = frames.elementAtOrNull(1);
  if (frame != null) {
    final tokens = frame
        .replaceAll("<anonymous closure>", "<anonymous_closure>")
        .split(' ');
    final methodName = tokens.elementAtOrNull(tokens.length - 2);
    if (methodName != null) {
      final methodTokens = methodName.split('.');
      return methodTokens.length >= 2 &&
              methodTokens.first != "<anonymous_closure>"
          ? (methodTokens.elementAtOrNull(1) ?? "")
          : methodName;
    }
  }
  return '';
}

void console(var value, {LogColors color = LogColors.green}) {
  if (kDebugMode) {
    print(value);
    // log('${colors[color]}$value\x1B[0m', name: "Log");
  }
}

enum LogColors { black, red, green, yellow, blue, magenta, cyan, white }

const Map<LogColors, String> colors = {
  LogColors.black: "\x1B[30m",
  LogColors.red: "\x1B[31m",
  LogColors.green: "\x1B[32m",
  LogColors.yellow: "\x1B[33m",
  LogColors.blue: "\x1B[34m",
  LogColors.magenta: "\x1B[35m",
  LogColors.cyan: "\x1B[36m",
  LogColors.white: "\x1B[37m",
};
