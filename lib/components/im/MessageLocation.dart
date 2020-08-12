import 'package:flutter/material.dart';

class MessageLocation extends StatelessWidget {
    /// 描述
    final String desc;

    /// 经度
    final double longitude;

    /// 纬度
    final double latitude;

    const MessageLocation({Key key, this.desc, this.longitude, this.latitude})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap: () => 0,
            child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey,
                child: Column(
                    children: <Widget>[
                        Text(desc),
                        Text("经度:$longitude"),
                        Text("纬度:$latitude"),
                    ],
                ),
            ),
        );
    }
}