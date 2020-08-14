import 'package:azlistview/azlistview.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/friend_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/list_item.dart';
import 'package:tim_demo/dto/friend_index_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/routers.dart';

class ContactsPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {

    /// 好友列表
    List<FriendIndexDTO> friends = [];

    init() async {
        List<FriendEntity> list = await TencentImPlugin.getFriendList();
        if (list != null && list.isNotEmpty) {
            friends = list.map((e) => FriendIndexDTO.fromEntity(e)).toList();
            friends.add(FriendIndexDTO(
                nikeName: 'Alone',
                id: 'alone',
                indexTag: 'A',
                faceUrl: 'none'
            ));
            friends.add(FriendIndexDTO(
                nikeName: 'Berry',
                id: '2',
                indexTag: 'B',
                faceUrl: 'none'
            ));
            SuspensionUtil.sortListBySuspensionTag(friends);
            setState(() {});
        }
    }

    toChat(FriendIndexDTO friend) {
        Routers.router.navigateTo(context, Routers.getRouteUrlOfParams(Routers.CHAT_PAGE, {
            'id': friend.id,
            'typeIndex': SessionType.C2C.index
        }), transition: TransitionType.cupertino);
    }
    
    Widget renderItem(FriendIndexDTO friend) {
        return ListItem(
            iconPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            textPadding: EdgeInsets.only(right: 20.0),
            icon: ImageView(
                img: friend.faceUrl,
                width: 40.0,
                height: 40.0,
            ),
            text: Text(
                friend.nikeName,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0
                ),
            ),
            onClick: () {
                toChat(friend);
            }
        );
    }

    @override
    void initState() {
        super.initState();
        init();
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Scaffold(
            appBar: CommonBar(
                centerTitle: true,
                title: S
                    .of(context)
                    .weChat,
            ),
            body: AzListView(
                data: friends,
                itemBuilder: (_, friend) => renderItem(friend),
                isUseRealIndex: true,
                suspensionWidget: Text('aaa'),
            ),
        );
    }

    @override
    bool get wantKeepAlive => true;
}