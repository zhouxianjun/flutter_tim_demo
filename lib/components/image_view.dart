import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/util/index.dart';

class ImageView extends StatelessWidget {
    final String img;
    final double width;
    final double height;
    final BoxFit fit;
    final bool isRadius;

    ImageView({
        @required this.img,
        this.height,
        this.width,
        this.fit,
        this.isRadius = true,
    });

    renderImage() {
        if (isNetWorkImg(img)) {
            return CachedNetworkImage(
                imageUrl: img,
                width: width,
                height: height,
                fit: fit,
            );
        }
        if (File(img).existsSync()) {
            return Image.file(
                File(img),
                width: width,
                height: height,
                fit: fit,
            );
        }
        if (isAssetsImg(img)) {
            return Image.asset(
                img,
                width: width,
                height: height,
                fit: width != null && height != null ? BoxFit.fill : fit,
            );
        }
        return Container(
            decoration: BoxDecoration(
                color: Colors.black26.withOpacity(0.1),
                border: Border.all(
                    color: Colors.black.withOpacity(0.2), width: 0.3)
            ),
            child: Image.asset(
                defIcon,
                width: width - 1,
                height: height - 1,
                fit: width != null && height != null ? BoxFit.fill : fit,
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        Widget image = renderImage();
        if (isRadius) {
            return ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                ),
                child: image,
            );
        }
        return image;
    }
}