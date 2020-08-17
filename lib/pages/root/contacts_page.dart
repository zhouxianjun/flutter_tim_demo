import 'package:azlistview/azlistview.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/friend_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/list_item.dart';
import 'package:tim_demo/dto/contacts_item_dto.dart';
import 'package:tim_demo/dto/friend_index_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/routers.dart';

const _SUSPENSION_HEIGHT = 40.0;

class ContactsPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {

    /// 好友列表
    List<FriendIndexDTO> friends = [];

    /// 当前tag
    String currentTag = '';

    init() async {
        List<FriendEntity> list = await TencentImPlugin.getFriendList();
        if (list != null && list.isNotEmpty) {
            friends = list.map((e) => FriendIndexDTO.fromEntity(e, context)).toList();
            SuspensionUtil.sortListBySuspensionTag(friends);
            setState(() {});
        }
    }

    /// 渲染分组tag标签
    Widget renderSusWidget(String susTag) {
        return Container(
            height: _SUSPENSION_HEIGHT,
            padding: const EdgeInsets.only(left: 15.0),
            color: Color(0xfff3f4f5),
            alignment: Alignment.centerLeft,
            child: Text(
                '$susTag',
                softWrap: false,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff999999),
                ),
            ),
        );
    }

    /// 渲染包装项
    Widget renderSuspensionItem(FriendIndexDTO friend) {
        return Column(
            children: <Widget>[
                Offstage(
                    offstage: friend.isShowSuspension != true,
                    child: renderSusWidget(friend.getSuspensionTag()),
                ),
                renderItem(friend)
            ],
        );
    }

    /// 渲染真实item项
    Widget renderItem(ContactsItemDTO item) {
        return ListItem(
            iconPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            textPadding: EdgeInsets.only(right: 20.0),
            icon: ImageView(
                img: item.icon,
                width: 40.0,
                height: 40.0,
            ),
            text: Text(
                item.name,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0
                ),
            ),
            onClick: item.onClick
        );
    }

    /// 渲染通讯录上面选项卡
    AzListViewHeader renderListHeader() {
        List<ContactsItemDTO> list = [
            ContactsItemDTO(name: '新的朋友', icon: 'assets/images/contact/ic_new_friend.webp'),
            ContactsItemDTO(name: '群聊', icon: 'assets/images/contact/ic_group.webp'),
            ContactsItemDTO(name: '标签', icon: 'assets/images/contact/ic_tag.webp'),
            ContactsItemDTO(name: '公众号', icon: 'assets/images/contact/ic_no_public.webp'),
        ];
        return AzListViewHeader(
            height: list.length * 70,
            builder: (_) {
                return Column(
                    children: list.map((e) => renderItem(e)).toList(),
                );
            }
        );
    }

    /// 当tag变化事件
    void onSusTagChanged(String tag) {
        setState(() {
            currentTag = tag;
        });
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
                itemBuilder: (_, friend) => renderSuspensionItem(friend),
                isUseRealIndex: true,
                header: renderListHeader(),
                suspensionWidget: renderSusWidget(currentTag),
                suspensionHeight: _SUSPENSION_HEIGHT.toInt(),
                onSusTagChanged: onSusTagChanged
            ),
        );
    }

    @override
    bool get wantKeepAlive => true;
}