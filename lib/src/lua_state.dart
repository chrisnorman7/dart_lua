/// Provides the [LuaState] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dart_lua_base.dart';
import 'enumerations.dart';
import 'error.dart';
import 'lua_bindings.dart';
import 'lua_debug.dart';

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

  /// Returns `true` if the value at the given [index] is a C function, and
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
  /// If conversion fails, [LuaError] will be thrown with its code set to
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
  /// If conversion fails, [LuaError] will be thrown with its code set to
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

  /// Converts the value at the given [index] to a generic C pointer.
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_topointer).
  Pointer<Void>? toPointer(int index) {
    final ptr = lua.lua.lua_topointer(pointer, index);
    if (ptr == nullptr) {
      return null;
    }
    return ptr;
  }

  /// Performs an arithmetic or bitwise operation over the two values (or one,
  /// in the case of negations) at the top of the stack, with the value on the
  /// top being the second operand, pops these values, and pushes the result of
  /// the operation.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_arith).
  void arith(int op) => lua.lua.lua_arith(pointer, op);

  /// Returns 1 if the two values in indices [index1] and [index2] are
  /// primitively equal.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawequal).
  bool rawEqual(int index1, int index2) =>
      lua.lua.lua_rawequal(pointer, index1, index2) == 1;

  /// Compares two Lua values.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_compare).
  bool compare(int index1, int index2, int op) =>
      lua.lua.lua_compare(pointer, index1, index2, op) == 1;

  /// Pushes a nil value onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushnil).
  void pushNil() => lua.lua.lua_pushnil(pointer);

  /// Pushes a double with value [n] onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushnumber).
  void pushNumber(double n) => lua.lua.lua_pushnumber(pointer, n);

  /// Pushes an integer with value [n] onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushinteger).
  void pushInteger(int n) => lua.lua.lua_pushinteger(pointer, n);

  /// Pushes the string [s] onto the stack.
  ///
  /// Uses [DartLua.lua_pushlstring].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushlstring).
  Pointer<Int8> pushLString(String s) {
    final stringPointer = s.toNativeUtf8().cast<Int8>();
    final ptr = lua.lua.lua_pushlstring(pointer, stringPointer, s.length);
    malloc.free(stringPointer);
    return ptr;
  }

  /// Pushes the string [s] onto the stack.
  ///
  /// Uses [DartLua.lua_pushstring].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushstring).
  Pointer<Int8> pushString(String s) {
    final stringPointer = s.toNativeUtf8().cast<Int8>();
    final ptr = lua.lua.lua_pushstring(pointer, stringPointer);
    malloc.free(stringPointer);
    return ptr;
  }

  /// See the reference manual.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushvfstring).
  Pointer<Int8> pushVfString(String fmt, String argp) {
    final fmtPointer = fmt.toNativeUtf8().cast<Int8>();
    final argpPointer = argp.toNativeUtf8().cast<Int8>();
    final ptr = lua.lua.lua_pushvfstring(pointer, fmtPointer, argpPointer);
    [fmtPointer, argpPointer].forEach(malloc.free);
    return ptr;
  }

  /// Pushes onto the stack a formatted string [fmt] and returns a pointer to
  /// this string.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushfstring).
  Pointer<Int8> pushFString(String fmt) {
    final fmtPointer = fmt.toNativeUtf8().cast<Int8>();
    final ptr = lua.lua.lua_pushfstring(pointer, fmtPointer);
    malloc.free(fmtPointer);
    return ptr;
  }

  /// Pushes a new C closure [fn] onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushcclosure).
  void pushCClosure(lua_CFunction fn, int n) =>
      lua.lua.lua_pushcclosure(pointer, fn, n);

  /// Pushes a boolean value with value [b] onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushboolean).
  void pushBoolean(bool b) =>
      lua.lua.lua_pushboolean(pointer, b == true ? 1 : 0);

  /// Pushes a light userdata [p] onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushlightuserdata).
  void pushLightUserdata(Pointer<Void> p) =>
      lua.lua.lua_pushlightuserdata(pointer, p);

  /// Pushes this thread onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_pushthread).
  bool pushThread() => lua.lua.lua_pushthread(pointer) == 1;

  /// Pushes onto the stack the value of the global [name].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getglobal).
  LuaType getGlobal(String name) {
    final namePointer = name.toNativeUtf8().cast<Int8>();
    final value = lua.lua.lua_getglobal(pointer, namePointer);
    malloc.free(namePointer);
    return value.toLuaType();
  }

  /// Pushes onto the stack the value `t[k]`, where `t` is the value at the
  /// given [index] and `k` is the value on the top of the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_gettable).
  LuaType getTable(int index) =>
      lua.lua.lua_gettable(pointer, index).toLuaType();

  /// Pushes onto the stack the value `t[k]`, where `t` is the value at the
  /// given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getfield).
  LuaType getField(int index, String k) {
    final kPointer = k.toNativeUtf8().cast<Int8>();
    final value = lua.lua.lua_getfield(pointer, index, kPointer);
    malloc.free(kPointer);
    return value.toLuaType();
  }

  /// Pushes onto the stack the value `t[i]`, where `t` is the value at the
  /// given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_geti).
  LuaType getI(int index, int n) =>
      lua.lua.lua_geti(pointer, index, n).toLuaType();

  /// Similar to [getTable], but does a raw access (i.e., without
  /// metamethods).
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawget).
  LuaType rawGet(int index) => lua.lua.lua_rawget(pointer, index).toLuaType();

  /// Pushes onto the stack the value `t[n]`, where `t` is the table at the
  /// given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawgeti).
  LuaType getRawI(int index, int n) =>
      lua.lua.lua_rawgeti(pointer, index, n).toLuaType();

  /// Pushes onto the stack the value `t[k]`, where `t` is the table at the
  /// given [index] and `k` is the pointer [p] represented as a light userdata.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawgetp).
  LuaType rawGetP(int index, Pointer<Void> p) =>
      lua.lua.lua_rawgetp(pointer, index, p).toLuaType();

  /// Creates a new empty table and pushes it onto the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_createtable).
  void createTable(int narr, int nrec) =>
      lua.lua.lua_createtable(pointer, narr, nrec);

  /// This function creates and pushes on the stack a new full userdata, with
  /// [nuvalue] associated Lua values, called user values, plus an associated
  /// block of raw memory with size [sz] bytes.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_newuserdatauv).
  Pointer<Void> newUserdataV(int sz, int nuvalue) =>
      lua.lua.lua_newuserdatauv(pointer, sz, nuvalue);

  /// If the value at the given [index] has a metatable, the function pushes
  /// that metatable onto the stack and returns `true`. Otherwise, the function
  /// returns `false` and pushes nothing on the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getmetatable).
  bool getMetaTable(int index) => lua.lua.lua_getmetatable(pointer, index) == 1;

  /// Pushes onto the stack the [n]-th user value associated with the full
  /// userdata at the given [index] and returns the type of the pushed value.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getiuservalue).
  LuaType getIUserValue(int index, int n) =>
      lua.lua.lua_getiuservalue(pointer, index, n).toLuaType();

  /// Pops a value from the stack and sets it as the new value of global [name].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setglobal).
  void setGlobal(String name) {
    final namePointer = name.toNativeUtf8().cast<Int8>();
    lua.lua.lua_setglobal(pointer, namePointer);
    malloc.free(namePointer);
  }

  /// Does the equivalent to `t[k] = v`, where `t` is the value at the given
  /// [index], `v` is the value on the top of the stack, and `k` is the value
  /// just below the top.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_settable).
  void setTable(int index) => lua.lua.lua_settable(pointer, index);

  /// Does the equivalent to `t[k] = v`, where `t` is the value at the given
  /// [index] and `v` is the value on the top of the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setfield).
  void setField(int index, String k) {
    final namePointer = k.toNativeUtf8().cast<Int8>();
    lua.lua.lua_setfield(pointer, index, namePointer);
    malloc.free(namePointer);
  }

  /// Does the equivalent to `t[n] = v`, where `t` is the value at the given
  /// [index] and `v` is the value on the top of the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_seti).
  void setI(int index, int n) => lua.lua.lua_seti(pointer, index, n);

  /// Similar to [setTable], but does a raw assignment (i.e., without
  /// metamethods).
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawset).
  void rawSet(int index) => lua.lua.lua_rawset(pointer, index);

  /// Does the equivalent of `t[i] = v`, where `t` is the table at the given
  /// [index] and `v` is the value on the top of the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawseti).
  void rawSetI(int index, int n) => lua.lua.lua_rawseti(pointer, index, n);

  /// Does the equivalent of [t[p] = v], where `t` is the table at the given
  /// [index], `p` is encoded as a light userdata, and v is the value on the
  /// top of the stack.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_rawsetp).
  void rawSetP(int index, Pointer<Void> p) =>
      lua.lua.lua_rawsetp(pointer, index, p);

  /// Pops a table or `nil` from the stack and sets that value as the new
  /// metatable for the value at the given `index`. (`nil` means no metatable.)
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setmetatable).
  int setMetaTable(int index) => lua.lua.lua_setmetatable(pointer, index);

  /// Pops a value from the stack and sets it as the new `n`-th user value
  /// associated to the full userdata at the given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setiuservalue).
  void setIUserValue(int index, int n) =>
      lua.lua.lua_setiuservalue(pointer, index, n);

  /// Calls a function.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_call).
  void call(int nArgs, int nResults) =>
      lua.lua.lua_callk(pointer, nArgs, nResults, 0, nullptr);

  /// Yields a coroutine (thread).
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_yield).
  int yield(int nResults) => lua.lua.lua_yieldk(pointer, nResults, 0, nullptr);

  /// Starts and resumes a coroutine in this thread.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_resume).
  int resume(LuaState from, int nArg, int nRes) {
    lua.int32Pointer.value = nRes;
    return lua.lua.lua_resume(pointer, from.pointer, nArg, lua.int32Pointer);
  }

  /// Returns the status of this thread.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_status).
  int get status => lua.lua.lua_status(pointer);

  /// Returns `true` if this thread can yield, and `false` otherwise.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_isyieldable).
  bool get isYieldable => lua.lua.lua_isyieldable(pointer) == 1;

  /// Emits a warning with the given message.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_warning).
  void warning(String message, bool cont) {
    final ptr = message.toNativeUtf8().cast<Int8>();
    lua.lua.lua_warning(pointer, ptr, cont == true ? 1 : 0);
    malloc.free(ptr);
  }

  /// Raises a Lua error, using the value on the top of the stack as the error
  /// object.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_error).
  int error() => lua.lua.lua_error(pointer);

  /// Pops a key from the stack, and pushes a key - value pair from the table
  /// at the given [index], the "next" pair after the given key.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_next).
  int next(int index) => lua.lua.lua_next(pointer, index);

  /// Concatenates the [n] values at the top of the stack, pops them, and
  /// leaves the result on the top.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_concat).
  void concat(int n) => lua.lua.lua_concat(pointer, n);

  /// Returns the length of the value at the given [index].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_len).
  void len(int index) => lua.lua.lua_len(pointer, index);

  /// Converts the string [s] to a number, pushes that number into the stack,
  /// and returns the total size of the string, that is, its length plus one.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_stringtonumber).
  int stringToNumber(String s) {
    final ptr = s.toNativeUtf8().cast<Int8>();
    final l = lua.lua.lua_stringtonumber(pointer, ptr);
    malloc.free(ptr);
    return l;
  }

  /// Marks the given [index] in the stack as a to-be-closed slot.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_toclose).
  void toClose(int index) => lua.lua.lua_toclose(pointer, index);

  /// Close the to-be-closed slot at the given [index] and set its value to nil.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_closeslot).
  void closeSlot(int index) => lua.lua.lua_closeslot(pointer, index);

  ///
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getstack).
  LuaDebug getStack(int level) {
    final ptr = calloc<lua_Debug>();
    final worked = lua.lua.lua_getstack(pointer, level, ptr) == 1;
    if (worked) {
      return LuaDebug(ptr);
    }
    calloc.free(ptr);
    throw LuaError(
        0, 'The `level` parameter was greater than the stack depth.');
  }

  ///
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getinfo).
  bool getInfo(String what, LuaDebug ar) {
    final whatPointer = what.toNativeUtf8().cast<Int8>();
    final result = lua.lua.lua_getinfo(pointer, whatPointer, ar.pointer) == 1;
    malloc.free(whatPointer);
    return result;
  }

  /// Gets information about a local variable of a given activation record.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getlocal).
  String? getLocal(LuaDebug luaDebug, int n) {
    final ptr = lua.lua.lua_getlocal(pointer, luaDebug.pointer, n);
    if (ptr == nullptr) {
      calloc.free(ptr);
      return null;
    }
    final s = ptr.cast<Utf8>().toDartString();
    calloc.free(ptr);
    return s;
  }

  /// Sets the value of a local variable of a given activation record.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setlocal).
  String? setLocal(LuaDebug luaDebug, int n) {
    final ptr = lua.lua.lua_setlocal(pointer, luaDebug.pointer, n);
    if (ptr == nullptr) {
      calloc.free(ptr);
      return null;
    }
    final s = ptr.cast<Utf8>().toDartString();
    calloc.free(ptr);
    return s;
  }

  /// Gets information about a closure's upvalue.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_getupvalue).
  String? getUpValue(int funcIndex, int n) {
    final ptr = lua.lua.lua_getupvalue(pointer, funcIndex, n);
    if (ptr == nullptr) {
      calloc.free(ptr);
      return null;
    }
    final s = ptr.cast<Utf8>().toDartString();
    calloc.free(ptr);
    return s;
  }

  /// Sets the value of a closure's upvalue.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setupvalue).
  String? setUpValue(int funcIndex, int n) {
    final ptr = lua.lua.lua_setupvalue(pointer, funcIndex, n);
    if (ptr == nullptr) {
      calloc.free(ptr);
      return null;
    }
    final s = ptr.cast<Utf8>().toDartString();
    calloc.free(ptr);
    return s;
  }

  /// Sets the debugging hook function.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_sethook).
  void setHook(
    lua_Hook func,
    int mask,
    int count,
  ) =>
      lua.lua.lua_sethook(pointer, func, mask, count);

  /// Returns the current hook function.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_gethook).
  lua_Hook get hook => lua.lua.lua_gethook(pointer);

  /// Returns the current hook mask.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_gethookmask).
  int get hookMask => lua.lua.lua_gethookmask(pointer);

  /// Returns the current hook count.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_gethookcount).
  int get hookCount => lua.lua.lua_gethookcount(pointer);

  ///
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#lua_setcstacklimit).
  set cStackLimit(int limit) => lua.lua.lua_setcstacklimit(pointer, limit);

  /// Pushes onto the stack the field [e] from the metatable of the object at
  /// index [obj].
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#luaL_getmetafield).
  bool getMetaField(int obj, String e) {
    final ptr = e.toNativeUtf8().cast<Int8>();
    final value = lua.lua.luaL_getmetafield(pointer, obj, ptr);
    malloc.free(ptr);
    return value == 1;
  }

  /// Calls a metamethod.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#luaL_callmeta).
  bool callMeta(int obj, String e) {
    final ptr = e.toNativeUtf8().cast<Int8>();
    final value = lua.lua.luaL_callmeta(pointer, obj, ptr);
    malloc.free(ptr);
    return value == 1;
  }

  /// Raises an error with the following message, where `func` is retrieved
  /// from the call stack:
  /// bad argument #<arg> to <func> (<extraMsg>)
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#luaL_argerror).
  void argError(int arg, String extraMsg) {
    final ptr = extraMsg.toNativeUtf8().cast<Int8>();
    lua.lua.luaL_argerror(pointer, arg, ptr);
    malloc.free(ptr);
  }

  /// No documentation found.
  ///
  /// [Lua Docs](https://www.lua.org/manual/5.4/manual.html#luaL_typeerror).
  void typeError(int arg, String tName) {
    final ptr = tName.toNativeUtf8().cast<Int8>();
    lua.lua.luaL_typeerror(pointer, arg, ptr);
    malloc.free(ptr);
  }
}
