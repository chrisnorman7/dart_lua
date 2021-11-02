// ignore_for_file: avoid_print

import 'package:dart_lua/dart_lua.dart';

void main() {
  final lua = Lua();
  final state = lua.newState();
  print('Lua version ${state.version}.');
  print(state.getTypeName(LuaType.string));
  print(state.toLString(0));
}
