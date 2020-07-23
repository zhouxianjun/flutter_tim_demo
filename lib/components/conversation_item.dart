import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/styles/index.dart';

class ConversationItem extends StatefulWidget {
    final SessionEntity entity;

    const ConversationItem({Key key, this.entity}) : super(key: key);

    @override
    State<StatefulWidget> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {

    String get title {
        final nickname = this.widget.entity.nickname;
        if (nickname == null || nickname.length <= 0) {
            return this.widget.entity.type == SessionType.System ? '系统账号' : '';
        }
        return nickname;
    }

    MessageEntity get message {
        return this.widget.entity.message;
    }

    DateTime get time {
        return this.message != null ? DateTime.fromMillisecondsSinceEpoch(this.message.timestamp * 1000) : null;
    }

    Widget renderTitle() {
        return Text(this.title);
    }

    Widget renderTime() {
        return Text(
            this.time == null ? "" : "${this.time.year}-${this.time.month}-${this.time.day} ${this.time.hour}:${this.time.minute}:${this.time.second}",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
            ),
        );
    }

    Widget renderMessage() {
        return Text(
            this.message != null && this.message.note != null ? this.message.note : "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
        );
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(left: 18.0),
            height: 68.0,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    ImageView(
                        img: this.widget.entity.faceUrl,
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                    ),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 10.0, 12.0, 10.0),
                            margin: EdgeInsets.only(left: 18.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.lineColor, width: 0.2
                                    ),
                                ),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            renderTitle(),
                                            renderTime()
                                        ],
                                    ),
                                    renderMessage()
                                ],
                            ),
                        ),
                    )
                ],
            ),
        );
    }
}