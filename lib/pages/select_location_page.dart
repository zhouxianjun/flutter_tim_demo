import 'package:flutter/material.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/generated/i18n.dart';

class SelectLocationPage extends StatefulWidget {
    @override
    _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
    List data;

    Widget buildItem(BuildContext context, int index) {
        final item = data[index];
        return InkWell(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        Text(
                            '${item['name']}',
                            style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                            '${item['code']}',
                            style: TextStyle(fontSize: 15.0, color: Colors.green),
                        ),
                    ],
                ),
            ),
            onTap: () => Navigator.pop(context, item),
        );
    }

    @override
    Widget build(BuildContext context) {
        data = [
            {'name': S.of(context).australia, 'code': '+61'},
            {'name': S.of(context).macao, 'code': '+853'},
            {'name': S.of(context).canada, 'code': '+001'},
            {'name': S.of(context).uS, 'code': '+001'},
            {'name': S.of(context).taiwan, 'code': '+886'},
            {'name': S.of(context).hongKong, 'code': '+852'},
            {'name': S.of(context).singapore, 'code': '+65'},
            {'name': S.of(context).chinaMainland, 'code': '+86'},
        ];

        return Scaffold(
            appBar: CommonBar(title: S.of(context).selectCountry),
            body: ListView.builder(
                itemBuilder: buildItem, itemCount: data.length
            ),
        );
    }
}