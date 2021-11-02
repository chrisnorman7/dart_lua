/// Provides the [LuaState] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dart_lua_base.dart';
import 'enumerations.dart';
import 'error.dart';
import 'lua_bindings.dart';

/// A lua state.
///
/// Binds [lua_State].
///
/// *Note*: Many of the docs for methods on this class are abridged versions of
/// the documentation contained in the
/// [reference manual](https://www.lua.org/manual/5.4/manual.html). Please read
/// that page for the full documentation.
class LuaState {
  /// Create an instance.
  ///
  /// Instead of creating instances directly, use the [Lua.newState] convenience
  /// method.
  const LuaState(this.lua, this.pointer);

  /// The LUA bindings to use.
  final Lua lua;

  /// The pointer to use.
  final Pointer<lua_State> pointer;

  /// Performs an arithmetic or bitwise operation over the two values (or one,
  /// in the case of negations) at the top of the stack, with the value on the
  /// top being the second operand, pops these values, and pushes the result of
  /// the operation.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_arith).
  void arith(int op) => lua.lua.lua_arith(pointer, op);

  /// Close all active to-be-closed variables in the main thread, release all
  /// objects in the given Lua state (calling the corresponding garbage-
  /// collection metamethods, if any), and frees all dynamic memory used by this
  /// state.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_close).
  void close() => lua.lua.lua_close(pointer);

  /// Creates a new thread, pushes it on the stack, and returns a [LuaState]
  /// that represents this new thread.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_newthread).
  LuaState newThread() => LuaState(lua, lua.lua.lua_newthread(pointer));

  /// Resets a thread, cleaning its call stack and closing all pending to-be-
  /// closed variables.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_resetthread).
  int resetThread() => lua.lua.lua_resetthread(pointer);

  /// Registers a new at panic function, and returns the old one.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_atpanic).
  lua_CFunction atpanic(lua_CFunction panicf) =>
      lua.lua.lua_atpanic(pointer, panicf);

  /// Returns the version number of this core.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_version).
  double get version => lua.lua.lua_version(pointer);

  /// Converts the acceptable index idx into an equivalent absolute index (that
  /// is, one that does not depend on the stack size).
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_absindex).
  int absIndex(int index) => lua.lua.lua_absindex(pointer, index);

  /// Returns the index of the top element in the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_gettop).
  int get top => lua.lua.lua_gettop(pointer);

  /// Accepts any index, or 0, and sets the stack top to this [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_settop).
  set top(int index) => lua.lua.lua_settop(pointer, index);

  /// Pushes a copy of the element at the given index onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushvalue).
  void pushValue(int index) => lua.lua.lua_pushvalue(pointer, index);

  /// Rotates the stack elements between the valid index idx and the top of the
  /// stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rotate).
  void rotate(int index, int n) => lua.lua.lua_rotate(pointer, index, n);

  /// Copies the element at index fromidx into the valid index toidx, replacing
  /// the value at that position.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_copy).
  void copy(int fromIndex, int toIndex) =>
      lua.lua.lua_copy(pointer, fromIndex, toIndex);

  /// Ensures that the stack has space for at least n extra elements, that is,
  /// that you can safely push up to n values into it.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_checkstack).
  bool checkStack(int n) => lua.lua.lua_checkstack(pointer, n) == 1;

  /// Exchange values between different threads of the same state.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_xmove).
  void moveX(LuaState to, int n) => lua.lua.lua_xmove(pointer, to.pointer, n);

  /// Returns `true` if the value at the given [index] is a number or a string
  /// convertible to a number, and `false` otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_isnumber).
  bool isNumber(int index) => lua.lua.lua_isnumber(pointer, index) == 1;

  /// Returns `true` if the value at the given [index] is a string or a number
  /// (which is always convertible to a string), and `false` otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_isstring).
  bool isString(int index) => lua.lua.lua_isstring(pointer, index) == 1;

  /// Returns `tru` if the value at the given [index] is a C function, and
  /// `false` otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_iscfunction).
  void isCFunction(int index) => lua.lua.lua_iscfunction(pointer, index) == 1;

  /// Returns `true` if the value at the given index is an integer (that is, the
  /// value is a number and is represented as an integer), and `false`
  /// otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_isinteger).
  bool isInteger(int index) => lua.lua.lua_isinteger(pointer, index) == 1;

  /// Returns `true` if the value at the given index is a userdata (either full
  /// or light), and `false` otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_isuserdata).
  bool isUserData(int index) => lua.lua.lua_isuserdata(pointer, index) == 1;

  /// Returns the type of the value in the given valid [index], or
  /// [LuaType.none] for a non-valid but acceptable index.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_type).
  LuaType getType(int index) => lua.lua.lua_type(pointer, index).toLuaType();

  /// Returns the name of the type encoded by the value [tp], which must be one
  /// of the values of [LuaType].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_typename).
  String getTypeName(LuaType tp) =>
      lua.lua.lua_typename(pointer, tp.toInt()).cast<Utf8>().toDartString();

  /// Converts the Lua value at the given [index] to a double.
  ///
  /// If convertion fails, [LuaError] will be thrown with its code set to
  /// [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_tonumberx).
  double toNumberX(int index) {
    final value = lua.lua.lua_tonumberx(pointer, index, lua.int32Pointer);
    if (lua.int32Pointer.value != 1) {
      throw LuaError(index, 'Converting to number failed.');
    }
    return value;
  }

  /// Converts the Lua value at the given [index] to an integer.
  ///
  /// If convertion fails, [LuaError] will be thrown with its code set to
  /// [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_tointegerx).
  int toIntegerX(int index) {
    final value = lua.lua.lua_tointegerx(pointer, index, lua.int32Pointer);
    if (lua.int32Pointer.value != 1) {
      throw LuaError(index, 'Converting to integer failed.');
    }
    return value;
  }

  /// Converts the Lua value at the given [index] to a boolean value (`false`
  /// or `true`).
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_toboolean).
  bool toBoolean(int index) => lua.lua.lua_toboolean(pointer, index) == 1;

  ///
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_tolstring).
  String toLString(int index) {
    final ptr = lua.lua.lua_tolstring(pointer, index, lua.sizeTPointer);
    if (ptr == nullptr) {
      throw LuaError(index, 'Converting to string failed.');
    }
    return String.fromCharCodes(
        [for (var i = 0; i < lua.sizeTPointer.value; i++) ptr[i]]);
  }

  /// Returns the raw "length" of the value at the given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawlen).
  int rawLen(int index) => lua.lua.lua_rawlen(pointer, index);

  /// Converts a value at the given [index] to a C function.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_tocfunction).
  lua_CFunction? toCFunction(int index) {
    final ptr = lua.lua.lua_tocfunction(pointer, index);
    if (ptr == nullptr) {
      return null;
    }
    return ptr;
  }

  /// Returns the value at the given [index] as userdata.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_touserdata).
  Pointer<Void>? toUserdata(int index) {
    final ptr = lua.lua.lua_touserdata(pointer, index);
    if (ptr == nullptr) {
      return null;
    }
    return ptr;
  }

  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_tothread).
  LuaState? toThread(int index) {
    final ptr = lua.lua.lua_tothread(pointer, index);
    if (ptr == nullptr) {
      return null;
    }
    return LuaState(lua, ptr);
  }
}
