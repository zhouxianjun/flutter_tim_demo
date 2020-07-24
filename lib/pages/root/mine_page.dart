import 'package:flutter/material.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/generated/i18n.dart';

class MinePage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Scaffold(
            appBar: CommonBar(
                centerTitle: true,
                title: S.of(context).weChat,
            ),
        );
    }

    @override
    bool get wantKeepAlive => true;
}