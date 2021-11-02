/// Provides the [Lua] class.
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../dart_lua.dart';
import 'lua_bindings.dart';

/// The main Lua class.
class Lua {
  /// Create an instance.
  Lua({String? libraryName})
      : int32Pointer = calloc<Int32>(),
        sizeTPointer = calloc<size_t>() {
    if (libraryName == null) {
      if (Platform.isWindows) {
        libraryName = 'lua5.4.3.dll';
      } else {
        throw UnsupportedError(
            'This platform is not supported. Please submit an issue.');
      }
    }
    lua = DartLua(DynamicLibrary.open(libraryName));
  }

  /// The bindings to use.
  late final DartLua lua;

  /// An int32 pointer to be used by various calls.
  final Pointer<Int32> int32Pointer;

  /// A size_t pointer used by various calls.
  final Pointer<size_t> sizeTPointer;

  /// Get a new state.
  ///
  /// Binds [DartLua.lua_newstate].
  LuaState newState() {
    final pointer = lua.luaL_newstate();
    if (pointer == nullptr) {
      throw LuaError(-1, 'Memory allocation error.');
    }
    return LuaState(this, pointer);
  }
}
