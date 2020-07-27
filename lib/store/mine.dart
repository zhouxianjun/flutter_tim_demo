import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:tencent_im_plugin/entity/user_info_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/loading.dart';
import 'package:tim_demo/constant/storage_key.dart';
import 'package:tim_demo/constant/users.dart';
import 'package:tim_demo/dto/user_dto.dart';
import 'package:tim_demo/util/storage.dart';

part 'mine.g.dart';

class MineStore = _MineStore with _$MineStore;

abstract class _MineStore with Store {
    @observable
    String faceUrl;

    @observable
    String nickName;

    @observable
    String identifier;

    @observable
    int gender;

    @observable
    String selfSignature;

    @observable
    String location;

    @action
    Future<void> load([bool forceUpdate]) async {
        print('加载当前登录信息');
        UserInfoEntity entity = await TencentImPlugin.getSelfProfile(forceUpdate: forceUpdate);
        this.faceUrl = entity.faceUrl;
        this.nickName = entity.nickName;
        this.identifier = entity.identifier;
        this.gender = entity.gender;
        this.selfSignature = entity.selfSignature;
        this.location = entity.location;
    }

    /// 尝试静默登录
    Future<bool> tryLogin() async {
        String userId = Storage.sp.getString(StorageKeys.account);
        String sig = Storage.sp.getString(StorageKeys.password);
        bool loginOk = false;
        if (userId != null && sig != null) {
            try {
                await doLogin(userId, sig);
                loginOk = true;
            } catch (e) {
                print(e);
            }
        }
        if (!loginOk) {
            await Storage.sp.remove(StorageKeys.account);
            await Storage.sp.remove(StorageKeys.password);
        }
        return loginOk;
    }

    Future<void> doLogin(String userId, String sig) async {
        final loginUser = await TencentImPlugin.getLoginUser();
        print('当前已登录账户: $loginUser');
        if (loginUser == null) {
            await TencentImPlugin.login(identifier: userId, userSig: sig);
        }
        await Storage.sp.setString(StorageKeys.account, userId);
        await Storage.sp.setString(StorageKeys.password, sig);
        await load(true);
    }
}