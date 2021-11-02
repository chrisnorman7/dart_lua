/// Provides various LUA errors.

class LuaError implements Exception {
  /// Create an instance.
  LuaError(this.code, this.message);

  /// The code of the error.
  final int code;

  /// The message of the error.
  final String message;

  @override
  String toString() => '$runtimeType ($code): $message';
}
