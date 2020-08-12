import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final conversationRefreshHeader = () => CustomHeader(
    extent: 40.0,
    triggerDistance: 40.1,
    headerBuilder: (context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore) {
        return Stack(
            children: <Widget>[
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: SpinKitFadingCircle(
                            color: Colors.grey,
                            size: 30.0,
                        ),
                    ),
                ),
            ],
        );
    }
);