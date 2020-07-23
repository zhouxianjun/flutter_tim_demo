import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/conversation_item.dart';
import 'package:tim_demo/components/popup_dropdown.dart';
import 'package:tim_demo/components/search_button.dart';
import 'package:tim_demo/generated/i18n.dart';

class HomePage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
    List<SessionEntity> list = [];

    loadChatData() async {
        final list = await TencentImPlugin.getConversationList();
        setState(() {
            this.list = list;
        });
        print(list.length);
    }

    @override
    void initState() {
        super.initState();
        TencentImPlugin.addListener(onRefresh);
        loadChatData();
    }

    @override
    void dispose() {
        super.dispose();
        TencentImPlugin.removeListener(onRefresh);
    }

    onRefresh(ListenerTypeEnum type, params) {
        if (type == ListenerTypeEnum.RefreshConversation) {
            (params as List).forEach((item) {
                final msg = list.singleWhere((element) => element.id == item.id);
                print('会话id' + item.id);
                setState(() {
                    if (msg == null) {
                        list.add(item);
                    } else {
                        msg.nickname = item.nickname;
                        msg.faceUrl = item.faceUrl;
                        msg.message = item.message;
                        msg.unreadMessageNum = item.unreadMessageNum;
                    }
                });
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        final List items = <PopupDropdownItem<String>>[
            PopupDropdownItem(value: 'add_group_message', icon: Image.asset('assets/images/contacts_add_newmessage.png'), label: '发起群聊'),
            PopupDropdownItem(value: 'add_friend', icon: Image.asset('assets/images/ic_add_friend.webp'), label: '添加朋友'),
            PopupDropdownItem(value: 'scan', label: '扫一扫'),
        ];
        return Scaffold(
            appBar: CommonBar(
                centerTitle: true,
                title: S.of(context).weChat,
                rightDMActions: <Widget>[
                    PopupDropdown<String>(
                        width: MediaQuery.of(context).size.width / 2.5,
                        onChange: (String value) {
                            print(value);
                        },
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        items: items,
                        child: new Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: new Image.asset('assets/images/add_addressicon.png',
                                color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
                        ),
                    )
                ],
            ),
            body: ListView.builder(
                itemBuilder: (_, index) {
                    return index < 1 ? SearchButton() : ConversationItem(
                        entity: list.elementAt(index - 1),
                    );
                },
                itemCount: list.length + 1,
            ),
        );
    }

    @override
    bool get wantKeepAlive => true;
}