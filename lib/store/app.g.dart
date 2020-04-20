// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$localeAtom = Atom(name: '_AppStore.locale');

  @override
  Locale get locale {
    _$localeAtom.context.enforceReadPolicy(_$localeAtom);
    _$localeAtom.reportObserved();
    return super.locale;
  }

  @override
  set locale(Locale value) {
    _$localeAtom.context.conditionallyRunInAction(() {
      super.locale = value;
      _$localeAtom.reportChanged();
    }, _$localeAtom, name: '${_$localeAtom.name}_set');
  }

  final _$localeNameAtom = Atom(name: '_AppStore.localeName');

  @override
  String get localeName {
    _$localeNameAtom.context.enforceReadPolicy(_$localeNameAtom);
    _$localeNameAtom.reportObserved();
    return super.localeName;
  }

  @override
  set localeName(String value) {
    _$localeNameAtom.context.conditionallyRunInAction(() {
      super.localeName = value;
      _$localeNameAtom.reportChanged();
    }, _$localeNameAtom, name: '${_$localeNameAtom.name}_set');
  }

  final _$isLoginAtom = Atom(name: '_AppStore.isLogin');

  @override
  bool get isLogin {
    _$isLoginAtom.context.enforceReadPolicy(_$isLoginAtom);
    _$isLoginAtom.reportObserved();
    return super.isLogin;
  }

  @override
  set isLogin(bool value) {
    _$isLoginAtom.context.conditionallyRunInAction(() {
      super.isLogin = value;
      _$isLoginAtom.reportChanged();
    }, _$isLoginAtom, name: '${_$isLoginAtom.name}_set');
  }

  final _$setLocaleAsyncAction = AsyncAction('setLocale');

  @override
  Future<dynamic> setLocale(LanguageDTO dto) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(dto));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void login(BuildContext context, String phone) {
    final _$actionInfo = _$_AppStoreActionController.startAction();
    try {
      return super.login(context, phone);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'locale: ${locale.toString()},localeName: ${localeName.toString()},isLogin: ${isLogin.toString()}';
    return '{$string}';
  }
}
