import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/conversation_item.dart';
import 'package:tim_demo/components/popup_dropdown.dart';
import 'package:tim_demo/components/search_button.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/routers.dart';
import 'package:tim_demo/store/im.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<SessionEntity> list = [];
  IMStore imStore;

  loadChatData() async {
    final list = await TencentImPlugin.getConversationList();
    setState(() {
      this.list = list;
    });
    print(list.length);
  }

  String get title {
    final t = S.of(context).weChat;
    if (imStore.unreadCount > 0) {
      return '$t(${imStore.unreadCount})';
    }
    return t;
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

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    imStore = Provider.of<IMStore>(context);
  }

  refreshConversation([List<SessionEntity> conversationList]) async {
    if (conversationList == null) {
      conversationList = await TencentImPlugin.getConversationList();
    }
    conversationList.forEach((item) {
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

  onRefresh(ListenerTypeEnum type, params) {
    if (type == ListenerTypeEnum.Refresh) {
      refreshConversation();
    }
  }

  Widget renderChatItem(SessionEntity entity) {
    return Material(
      child: InkWell(
        child: ConversationItem(entity: entity),
        onTap: () {
          Routers.router.navigateTo(
              context,
              Routers.getRouteUrlOfParams(Routers.CHAT_PAGE,
                  {'id': entity.id, 'typeIndex': entity.type.index}),
              transition: TransitionType.cupertino);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List items = <PopupDropdownItem<String>>[
      PopupDropdownItem(
          value: 'add_group_message',
          icon: Image.asset('assets/images/contacts_add_newmessage.png'),
          label: '发起群聊'),
      PopupDropdownItem(
        value: Routers.ADD_FRIEND,
        icon: Image.asset('assets/images/ic_add_friend.webp'),
        label: '添加朋友',
      ),
      PopupDropdownItem(value: 'scan', label: '扫一扫'),
    ];
    return Scaffold(
      appBar: CommonBar(
        centerTitle: true,
        title: title,
        rightDMActions: <Widget>[
          PopupDropdown<String>(
            width: MediaQuery.of(context).size.width / 2.5,
            onChange: (String value) {
              print(value);
              Routers.router.navigateTo(context, value,
                  transition: TransitionType.cupertino);
            },
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            items: items,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: new Image.asset('assets/images/add_addressicon.png',
                  color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return index < 1
              ? SearchButton()
              : renderChatItem(list.elementAt(index - 1));
        },
        itemCount: list.length + 1,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
