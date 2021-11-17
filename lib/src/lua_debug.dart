/// Provides the [LuaDebug] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'error.dart';
import 'lua_bindings.dart';

/// The various types of [LuaDebug.name].
enum LuaDebugNameWhatType {
  /// "global"
  global,

  /// "local"
  local,

  /// "method"
  method,

  /// "field"
  field,

  /// "upvalue"
  upValue,

  /// ""
  none,
}

/// The type of the function.
enum LuaDebugWhatType {
  /// "Lua"
  lua,

  /// "C"
  c,

  /// "main"
  main,
}

/// A structure used to carry different pieces of information about a function
/// or an activation record.
///
/// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_Debug).
class LuaDebug {
  /// Create an instance.
  LuaDebug(this.pointer);

  /// The pointer to use.
  final Pointer<lua_Debug> pointer;

  /// Event.
  int get event => pointer.ref.event;

  /// a reasonable name for the given function.
  String? get name => pointer.ref.name == nullptr
      ? null
      : pointer.ref.name.cast<Utf8>().toDartString();

  /// explains the [name] field.
  LuaDebugNameWhatType get nameWhat {
    final value = pointer.ref.namewhat.cast<Utf8>().toDartString();
    switch (value) {
      case '':
        return LuaDebugNameWhatType.none;
      case 'global':
        return LuaDebugNameWhatType.global;
      case 'local':
        return LuaDebugNameWhatType.local;
      case 'method':
        return LuaDebugNameWhatType.method;
      case 'field':
        return LuaDebugNameWhatType.field;
      case 'upvalue':
        return LuaDebugNameWhatType.upValue;
      default:
        throw LuaError(-1, 'Unknown what type: $value.');
    }
  }

  /// The type of the function.
  LuaDebugWhatType get what {
    final value = pointer.ref.what.cast<Utf8>().toDartString();
    switch (value) {
      case 'Lua':
        return LuaDebugWhatType.lua;
      case 'C':
        return LuaDebugWhatType.c;
      case 'main':
        return LuaDebugWhatType.main;
      default:
        throw LuaError(-1, 'Unknown what type: $value.');
    }
  }

  /// The source of the chunk that created the function.
  String get source => pointer.ref.source.cast<Utf8>().toDartString();

  /// The length of the string [source].
  int get srcLen => pointer.ref.srclen;

  /// The current line where the given function is executing.
  int get currentLine => pointer.ref.currentline;

  /// The line number where the definition of the function starts.
  int get lineDefined => pointer.ref.linedefined;

  /// The line number where the definition of the function ends.
  int get lastLineDefined => pointer.ref.lastlinedefined;

  /// The number of upvalues of the function.
  int get nUps => pointer.ref.nups;

  /// The number of parameters of the function (always 0 for C functions).
  int get nParams => pointer.ref.nparams;

  /// Returns `true` if the function is a vararg function (always `true` for C
  /// functions).
  bool get isVarg => pointer.ref.isvararg == 1;

  /// Returns `true` if this function invocation was called by a tail call.
  bool get isTailCall => pointer.ref.istailcall == 1;

  /// The index in the stack of the first value being "transferred", that is,
  /// parameters in a call or return values in a return.
  int get fTransfer => pointer.ref.ftransfer;

  /// The number of values being transferred (see [fTransfer]).
  int get nTransfer => pointer.ref.ntransfer;

  /// A "printable" version of [source], to be used in error messages.
  String get shortSrc {
    final stringBuffer = StringBuffer();
    for (var i = 0; i < srcLen; i++) {
      stringBuffer.writeCharCode(pointer.ref.short_src[i]);
    }
    return stringBuffer.toString();
  }

  /// Destroy this value.
  ///
  /// This method invalidates the underlying [pointer].
  void destroy() {
    calloc.free(pointer);
  }
}
