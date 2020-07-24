// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IMStore on _IMStore, Store {
  final _$unreadCountAtom = Atom(name: '_IMStore.unreadCount');

  @override
  int get unreadCount {
    _$unreadCountAtom.reportRead();
    return super.unreadCount;
  }

  @override
  set unreadCount(int value) {
    _$unreadCountAtom.reportWrite(value, super.unreadCount, () {
      super.unreadCount = value;
    });
  }

  final _$_IMStoreActionController = ActionController(name: '_IMStore');

  @override
  void changeUnreadCount(int count) {
    final _$actionInfo = _$_IMStoreActionController.startAction(
        name: '_IMStore.changeUnreadCount');
    try {
      return super.changeUnreadCount(count);
    } finally {
      _$_IMStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
unreadCount: ${unreadCount}
    ''';
  }
}
