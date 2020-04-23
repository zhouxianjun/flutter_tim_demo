import 'package:tim_demo/constant/storage_key.dart';
import 'package:tim_demo/dto/language_dto.dart';
import 'package:tim_demo/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'app.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
    @observable
    Locale locale = getLocalForStorage();

    @observable
    String localeName = getLocalNameForStorage();

    @observable
    bool isLogin = false;

    @action
    Future setLocale(LanguageDTO dto) async {
        await Storage.sp.setStringList(StorageKeys.languageCode, [dto.languageCode, dto.countryCode]);
        await Storage.sp.setString(StorageKeys.languageName, dto.name);
        this.locale = Locale(dto.languageCode, dto.countryCode);
        this.localeName = dto.name;
    }

    @action
    void login(BuildContext context, String phone) {
        this.isLogin = true;
        Navigator.pop(context);
    }

    static Locale getLocalForStorage() {
        List<String> code = Storage.sp.getStringList(StorageKeys.languageCode);
        if (code != null && code.length == 2) {
            return Locale(code[0], code[1]);
        }
        return Locale('zh', 'CN');
    }

    static String getLocalNameForStorage() {
        String name = Storage.sp.getString(StorageKeys.languageName);
        return name ?? '中文';
    }
}