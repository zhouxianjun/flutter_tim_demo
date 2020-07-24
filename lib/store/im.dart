import 'package:mobx/mobx.dart';
import 'package:tim_demo/constant/storage_key.dart';
import 'package:tim_demo/util/storage.dart';

part 'im.g.dart';

class IMStore = _IMStore with _$IMStore;

abstract class _IMStore with Store {
    @observable
    int unreadCount = getUnreadCountForStorage();

    @action
    void changeUnreadCount(int count) {
        this.unreadCount = count;
    }

    static int getUnreadCountForStorage() {
        if (Storage.sp.containsKey(StorageKeys.unreadCount)) {
            return Storage.sp.getInt(StorageKeys.unreadCount);
        }
        return 0;
    }
}