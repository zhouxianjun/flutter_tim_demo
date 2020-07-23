import 'dart:io';

import 'package:flutter/material.dart';

class MessageImage extends StatelessWidget {
    final String url;
    final String path;

    const MessageImage({Key key, this.url, this.path}) : super(key: key);

    Widget localImage() {
        return Image.file(File(path), fit: BoxFit.cover);
    }

    Widget networkImage() {
        return Image.network(url, fit: BoxFit.cover);
    }

    Widget getImage() {
        if (path != null) {
            return localImage();
        }
        if (url != null) {
            return networkImage();
        }
        return SizedBox();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 100,
            width: 100,
            child: getImage()
        );
    }
}