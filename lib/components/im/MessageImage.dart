import 'package:flutter/material.dart';
import 'package:tim_demo/components/image_view.dart';

class MessageImage extends StatelessWidget {
    final String url;
    final String path;

    const MessageImage({Key key, this.url, this.path}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return ImageView(
            img: path ?? url,
            height: 100,
            width: 100,
            fit: BoxFit.cover
        );
    }
}