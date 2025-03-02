import 'dart:ffi' as ffi;

typedef IsDebuggerPresentC = ffi.Int32 Function();
typedef IsDebuggerPresentDart = int Function();

class DebugBlocker {
  static bool isDebuggerAttached() {
    try {
      final kernel32 = ffi.DynamicLibrary.open('kernel32.dll');
      final isDebuggerPresent = kernel32.lookupFunction<IsDebuggerPresentC, IsDebuggerPresentDart>('IsDebuggerPresent');

      return isDebuggerPresent() != 0;
    } catch (_) {}

    return false;
  }
}
