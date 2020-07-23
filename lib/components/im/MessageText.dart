import 'package:flutter/material.dart';

class MessageText extends StatelessWidget {
    final String text;

    const MessageText({Key key, this.text}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Text(text);
    }
}