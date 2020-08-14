import 'package:flutter/material.dart';
import 'package:tim_demo/components/triangle_message_wrapper.dart';

class MessageText extends StatelessWidget {
    final String text;
    final bool isSelf;

    const MessageText({Key key, this.text, this.isSelf}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return TriangleMessageWrapper(
            Text(text),
            isSelf: isSelf,
        );
    }
}