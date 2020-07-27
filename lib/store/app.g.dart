// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$mineStoreAtom = Atom(name: '_AppStore.mineStore');

  @override
  MineStore get mineStore {
    _$mineStoreAtom.reportRead();
    return super.mineStore;
  }

  @override
  set mineStore(MineStore value) {
    _$mineStoreAtom.reportWrite(value, super.mineStore, () {
      super.mineStore = value;
    });
  }

  final _$localeAtom = Atom(name: '_AppStore.locale');

  @override
  Locale get locale {
    _$localeAtom.reportRead();
    return super.locale;
  }

  @override
  set locale(Locale value) {
    _$localeAtom.reportWrite(value, super.locale, () {
      super.locale = value;
    });
  }

  final _$localeNameAtom = Atom(name: '_AppStore.localeName');

  @override
  String get localeName {
    _$localeNameAtom.reportRead();
    return super.localeName;
  }

  @override
  set localeName(String value) {
    _$localeNameAtom.reportWrite(value, super.localeName, () {
      super.localeName = value;
    });
  }

  final _$isLoginAtom = Atom(name: '_AppStore.isLogin');

  @override
  bool get isLogin {
    _$isLoginAtom.reportRead();
    return super.isLogin;
  }

  @override
  set isLogin(bool value) {
    _$isLoginAtom.reportWrite(value, super.isLogin, () {
      super.isLogin = value;
    });
  }

  final _$setLocaleAsyncAction = AsyncAction('_AppStore.setLocale');

  @override
  Future<dynamic> setLocale(LanguageDTO dto) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(dto));
  }

  final _$loginAsyncAction = AsyncAction('_AppStore.login');

  @override
  Future<void> login(BuildContext context, String phone) {
    return _$loginAsyncAction.run(() => super.login(context, phone));
  }

  @override
  String toString() {
    return '''
mineStore: ${mineStore},
locale: ${locale},
localeName: ${localeName},
isLogin: ${isLogin}
    ''';
  }
}
