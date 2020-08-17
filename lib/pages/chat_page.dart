import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/conversation_refresh_header.dart';
import 'package:tim_demo/components/message_item.dart';

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

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
    /// 消息输入框表单KEY
    TextEditingController messageInputController = TextEditingController();

    /// 滚动控制器
    ScrollController scrollController = ScrollController();

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
        WidgetsBinding.instance.addObserver(this);
        this.init();
        TencentImPlugin.addListener(listener);
    }

    @override
    void didChangeMetrics() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if(MediaQuery.of(context).viewInsets.bottom > 0){
                scrollToBottom();
            }
        });
    }

    @override
    void dispose() {
        super.dispose();
        WidgetsBinding.instance.removeObserver(this);
        TencentImPlugin.removeListener(listener);
        scrollController.dispose();
    }

    void init() async {
        this.conversation = await TencentImPlugin.getConversation(
            sessionId: widget.id, sessionType: type);
        this.messages = await TencentImPlugin.getLocalMessages(
            sessionId: widget.id,
            sessionType: type,
            number: MESSAGE_LIST_LENGTH);
        TencentImPlugin.setRead(sessionId: widget.id, sessionType: type);
        setState(() {});
    }

    Widget renderMsg(MessageEntity msg) {
        return MessageItem(msg, type == SessionType.Group);
    }

    /// 输入框
    Widget renderInput() {
        return Expanded(
            child: TextField(
                controller: messageInputController,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    isDense: true
                ),
                onSubmitted: sendTextMessage,
            )
        );
    }

    Future<void> onRefresh() async {
        int oldLength = this.length;
        this.messages = await TencentImPlugin.getMessages(sessionId: widget.id,
            sessionType: type,
            number: length + MESSAGE_LIST_LENGTH);
        this.noMore = oldLength == this.length;
        setState(() {});
    }
    
    scrollToBottom({duration = 200}) {
        Timer(Duration(milliseconds: duration), () {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: new Duration(milliseconds: 250),
                curve: Curves.linear);
        });
    }

    sendMessage(MessageNode node) async {
        MessageEntity msg = await TencentImPlugin.sendMessage(sessionId: widget.id, sessionType: type, node: node);
        addMessage(msg);
        setState(() {});
        scrollToBottom();
    }

    sendTextMessage(String text) async {
        if (text == null || text.trim().length <= 0) {
            return;
        }
        await sendMessage(TextMessageNode(
            content: text.trim()
        ));
        messageInputController.text = '';
    }

    addMessage(MessageEntity msg) {
        if (messages != null) {
            MessageEntity old = messages.firstWhere((element) => element.uniqueId == msg.uniqueId, orElse: () => null);
            if (old == null) {
                messages.add(msg);
                scrollToBottom();
            }
        }
    }

    listener(ListenerTypeEnum type, params) {
        if (type == ListenerTypeEnum.NewMessages) {
            addMessage(params[0]);
            TencentImPlugin.setRead(sessionId: widget.id, sessionType: this.type);
            setState(() {});
        }
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
            body: GestureDetector(
                onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Stack(
                    children: <Widget>[
                        Container(
                            color: Color(0xffefefef),
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 60),
                            child: EasyRefresh.custom(
                                onRefresh: noMore ? null : onRefresh,
                                scrollController: scrollController,
                                header: conversationRefreshHeader(),
                                slivers: <Widget>[
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                                (_, index) =>
                                                renderMsg(
                                                    messages.elementAt(index)),
                                            childCount: length
                                        ),
                                    )
                                ],
                            ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xfff7f7f7),
                                    border: Border(top: BorderSide(
                                        color: Colors.grey[300]))
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                        InkWell(
                                            child: Padding(
                                                child: Image.asset(
                                                    'assets/images/chat/ic_voice.webp',
                                                    width: 28),
                                                padding: EdgeInsets.only(
                                                    bottom: 4.0),
                                            ),
                                        ),
                                        SizedBox(width: 10.0,),
                                        renderInput(),
                                        SizedBox(width: 10.0,),
                                        InkWell(
                                            child: Padding(
                                                child: Icon(
                                                    Icons.insert_emoticon,
                                                    size: 28),
                                                padding: EdgeInsets.only(
                                                    bottom: 4.0)
                                            ),
                                        ),
                                        SizedBox(width: 5.0,),
                                        InkWell(
                                            child: Padding(
                                                child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 28),
                                                padding: EdgeInsets.only(
                                                    bottom: 4.0)
                                            ),
                                        )
                                    ],
                                ),
                            )
                        )
                    ],
                ),
            ),
            bottomNavigationBar: Container(
                height: 40,
                color: Color(0xfff7f7f7),
            ),
        );
    }
}
