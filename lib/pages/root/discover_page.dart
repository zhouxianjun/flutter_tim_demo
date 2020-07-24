import 'package:flutter/material.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/generated/i18n.dart';

class DiscoverPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
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