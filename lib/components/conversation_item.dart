import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/styles/index.dart';
import 'package:tim_demo/util/index.dart';

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

    int get unreadCount {
        return this.widget.entity.unreadMessageNum;
    }

    Widget renderTitle() {
        return Text(
            this.title,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400
            ),
        );
    }

    Widget renderTime() {
        return Text(
            this.time == null ? '' : transformTimeOfConversation(time),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
            ),
        );
    }

    Widget renderMessage() {
        return Text(
            this.message != null && this.message.note != null ? this.message.note : '',
            maxLines: 1,
            style: TextStyle(
                color: Colors.grey
            ),
            overflow: TextOverflow.ellipsis,
        );
    }

    String get unreadCountText {
        return unreadCount > 99 ? '...' : '$unreadCount';
    }

    Widget renderFace() {
        final face = ImageView(
            img: this.widget.entity.faceUrl,
            height: 50.0,
            width: 50.0,
            fit: BoxFit.cover,
        );

        return Badge(
            showBadge: unreadCount > 0,
            padding: EdgeInsets.all(3.5),
            position: BadgePosition.topRight(top: -6.0, right: -5.0),
            badgeContent: Text(
                unreadCountText,
                style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white
                ),
            ),
            child: face,
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
                    renderFace(),
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