import 'package:fluttertoast/fluttertoast.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/loading.dart';
import 'package:tim_demo/constant/storage_key.dart';
import 'package:tim_demo/constant/users.dart';
import 'package:tim_demo/dto/language_dto.dart';
import 'package:tim_demo/dto/user_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/store/mine.dart';
import 'package:tim_demo/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'app.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
    @observable
    MineStore mineStore;

    _AppStore(this.mineStore);

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

    Future<bool> tryLogin() async {
        print('尝试自动登录...');
        bool loginOk = await mineStore.tryLogin();
        print('自动登录结果: $loginOk');
        this.isLogin = loginOk;
        return loginOk;
    }

    @action
    Future<void> login(BuildContext context, String phone) async {
        final UserDto user = users.singleWhere((element) => element.phone == phone, orElse: () => null);
        if (user == null) {
            Fluttertoast.showToast(
                msg: S.of(context).unRegister,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER
            );
            return;
        }
        Loading.show(context: context);
        try {
            await mineStore.doLogin(user.phone, user.sig);
        } catch (e) {
            print(e);
            Fluttertoast.showToast(
                msg: '登录失败',
                backgroundColor: Colors.red,
                textColor: Colors.white
            );
        } finally {
            Loading.close();
        }
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