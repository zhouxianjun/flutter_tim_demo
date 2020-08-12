import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/conversation_refresh_header.dart';
import 'package:tim_demo/components/horizontal_line.dart';
import 'package:tim_demo/components/message_item.dart';
import 'package:tim_demo/styles/index.dart';

const int MESSAGE_LIST_LENGTH = 10;

class ChatPage extends StatefulWidget {
    final String id;
    final int typeIndex;

    ChatPage(this.id, this.typeIndex);

    @override
    State<StatefulWidget> createState() {
        return _ChatPageState();
    }
}

class _ChatPageState extends State<ChatPage> {
    /// 聊天消息列表
    List<MessageEntity> messages;

    /// 当前会话信息
    SessionEntity conversation;

    /// 是否已加载完成
    bool noMore = false;

    /// 当前会话类型
    SessionType get type {
        return SessionType.values.elementAt(widget.typeIndex);
    }

    /// 当前会话标题
    String get title {
        return conversation?.nickname ?? '系统';
    }

    int get length {
        return messages?.length ?? 0;
    }

    @override
    void initState() {
        super.initState();
        this.init();
    }

    void init() async {
        this.conversation = await TencentImPlugin.getConversation(sessionId: widget.id, sessionType: type);
        this.messages = await TencentImPlugin.getLocalMessages(sessionId: widget.id, sessionType: type, number: MESSAGE_LIST_LENGTH);
        setState(() {});
    }

    Widget renderMsg(MessageEntity msg) {
        return MessageItem(msg, type == SessionType.Group);
    }

    Future<void> onRefresh() async {
        int oldLength = this.length;
        this.messages = await TencentImPlugin.getMessages(sessionId: widget.id, sessionType: type, number: length + MESSAGE_LIST_LENGTH);
        this.noMore = oldLength == this.length;
        setState(() {});
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: CommonBar(
                title: title,
                centerTitle: true,
                rightDMActions: <Widget>[
                    InkWell(
                        child: Image.asset('assets/images/right_more.png')
                    )
                ],
            ),
            body: Container(
                color: AppColors.appBarColor,
                child: Column(
                    children: <Widget>[
                        HorizontalLine(color: Colors.black26),
                        Expanded(
                            child: LayoutBuilder(
                                builder: (_, constraints) {
                                    return EasyRefresh.custom(
                                        onRefresh: noMore ? null : onRefresh,
                                        header: conversationRefreshHeader(),
                                        slivers: <Widget>[
                                            SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                        (_, index) => renderMsg(messages.elementAt(index)),
                                                    childCount: length
                                                ),
                                            )
                                        ],
                                    );
                                },
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}
