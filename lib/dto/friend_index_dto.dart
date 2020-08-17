import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_im_plugin/entity/friend_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tim_demo/dto/contacts_item_dto.dart';
import 'package:tim_demo/routers.dart';

typedef VoidCallback = dynamic Function();

class FriendIndexDTO extends ContactsItemDTO {
    String id;
    BuildContext _context;

    FriendIndexDTO.fromEntity(FriendEntity entity, BuildContext context) : super(
        name: entity.userInfoEntity.nickName,
        icon: entity.userInfoEntity.faceUrl ?? ''
    ) {
        this.id = entity.userInfoEntity.identifier;
        this._context = context;
        this.onClick = toChat;
    }

    toChat() {
        Routers.router.navigateTo(_context, Routers.getRouteUrlOfParams(Routers.CHAT_PAGE, {
            'id': this.id,
            'typeIndex': SessionType.C2C.index
        }), transition: TransitionType.cupertino);
    }
}