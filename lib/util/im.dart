import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/enums/image_type.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/image_message_node.dart';
import 'package:tencent_im_plugin/message_node/location_message_node.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tim_demo/components/im/MessageImage.dart';
import 'package:tim_demo/components/im/MessageLocation.dart';
import 'package:tim_demo/components/im/MessageText.dart';
import 'package:tim_demo/constant/.config.dart';
import 'package:tim_demo/constant/index.dart';

Widget getComponent(MessageEntity message) {
  List<MessageNode> nodes = message.elemList;
  // 只取第一个
  final node = nodes?.elementAt(0);
  if (node == null) {
    return null;
  }

  switch (node.nodeType) {
    case MessageNodeType.Text:
      TextMessageNode value = node;
      return MessageText(text: value.content, isSelf: message.self);
    case MessageNodeType.Image:
      ImageMessageNode value = node;
      return MessageImage(
          url: value.imageData[ImageType.Original]?.url, path: value.path);
    case MessageNodeType.Location:
      LocationMessageNode value = node;
      return MessageLocation(
        desc: value.desc,
        latitude: value.latitude,
        longitude: value.longitude,
      );
    case MessageNodeType.Custom:
      return MessageText(text: "[自定义节点，未指定解析规则]");
      break;
    case MessageNodeType.GroupTips:
      return MessageText(text: "[群提示节点，未指定解析规则]");
      break;
    default:
      {
        return MessageText(text: "[不支持的消息节点]");
      }
  }
}

String createUploadToken([key]) {
  int deadline = (DateTime.now().millisecondsSinceEpoch / 1000 + 3600).toInt();
  Map<String, dynamic> json = Map<String, dynamic>();
  json['scope'] = key != null ? '$ossBucket:$key' : ossBucket;
  json['deadline'] = deadline;
  String jsonStr = jsonEncode(json);
  String encoded = base64UrlEncode(utf8.encode(jsonStr));
  Hmac mac = Hmac(sha1, utf8.encode(qiniuKey));
  Digest digest = mac.convert(utf8.encode(encoded));
  String encodedSign = base64UrlEncode(digest.bytes);
  print('json: $jsonStr');
  print('sign: $digest');
  print('encodedSign: $encodedSign');
  print('encoded: $encoded');
  return '$qiniuId:$encodedSign:$encoded';
}
