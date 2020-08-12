import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/enums/message_status_enum.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/just_triangle_painter.dart';
import 'package:tim_demo/components/triangle_painter.dart';
import 'package:tim_demo/dto/coordinate.dart';
import 'package:tim_demo/util/im.dart';

const FACE_SIZE = 40.0;

class MessageItem extends StatefulWidget {
    final MessageEntity entity;
    final bool isGroup;

    MessageItem(this.entity, this.isGroup);

    @override
    State<StatefulWidget> createState() {
        return _MessageItem();
    }
}

class _MessageItem extends State<MessageItem> {

    String get faceUrl {
        return widget.entity.userInfo.faceUrl;
    }

    bool get isSelf {
        return widget.entity.self;
    }

    String get nickName {
        return widget.entity.userInfo.nickName ?? '';
    }

    bool get isRevoked {
        return widget.entity.status == MessageStatusEnum.HasRevoked;
    }

    Widget renderMsg() {
        return getComponent(widget.entity);
    }

    Widget renderFace() {
        return ImageView(
            img: faceUrl,
            height: FACE_SIZE,
            width: FACE_SIZE,
            fit: BoxFit.cover
        );
    }

    Widget renderFaceWrapper(Widget face) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: face,
        );
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(bottom: 14.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    renderFaceWrapper(isSelf ? SizedBox(width: FACE_SIZE) : renderFace()),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: <Widget>[
                                widget.isGroup ? Text(nickName, style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13.0
                                )) : SizedBox(height: 0),
                                renderMsg()
                            ],
                        ),
                    ),
                    renderFaceWrapper(isSelf ? renderFace() : SizedBox(width: FACE_SIZE)),
                ],
            ),
        );
    }
}