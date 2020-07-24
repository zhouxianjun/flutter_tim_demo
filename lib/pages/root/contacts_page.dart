import 'package:flutter/material.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/generated/i18n.dart';

class ContactsPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
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