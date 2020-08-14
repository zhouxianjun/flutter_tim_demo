import 'dart:developer';

import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:tencent_im_plugin/entity/friend_entity.dart';

class FriendIndexDTO extends ISuspensionBean {
    String nikeName;
    String id;
    String faceUrl;
    String indexTag;

    FriendIndexDTO({this.nikeName, this.id, this.faceUrl, this.indexTag = '#'}) : assert(id != null);

    FriendIndexDTO.fromEntity(FriendEntity entity) {
        this.nikeName = entity.userInfoEntity.nickName;
        this.id = entity.userInfoEntity.identifier;
        this.faceUrl = entity.userInfoEntity.faceUrl;
        this.indexTag = _parseTag();
    }

    _parseTag() {
        try {
            String pinyin = PinyinHelper.getPinyinE(this.nikeName);
            String tag = pinyin.substring(0, 1).toUpperCase();
            return RegExp("[A-Z]").hasMatch(tag) ? tag : '#';
        } catch (e) {
            log('获取昵称拼音失败', error: e);
            return '#';
        }
    }

    @override
    String getSuspensionTag() {
        return indexTag;
    }
}