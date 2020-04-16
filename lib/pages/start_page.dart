import 'package:tim_demo/components/common_button.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/routers.dart';
import 'package:tim_demo/styles/index.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

    Widget _renderLanguageSelect() {
        return Container(
            alignment: Alignment.topRight,
            child: InkWell(
                child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        S.of(context).language,
                        style: TextStyle(color: Colors.white)
                    ),
                ),
                onTap: () {
                    Routers.router.navigateTo(context, Routers.LANGUAGE_PAGE);
                }
            ),
        );
    }

    List<Widget> _buttons() {
        return [
            CommonButton(
                text: S.of(context).login,
                margin: EdgeInsets.only(left: 10.0),
                width: 100.0
            ),
            CommonButton(
                text: S.of(context).register,
                color: AppColors.bgColor,
                style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(8, 191, 98, 1.0)),
                margin: EdgeInsets.only(right: 10.0),
                width: 100.0
            )
        ];
    }

    Widget _body() {
        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bsc.webp'),
                    fit: BoxFit.cover
                )
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    _renderLanguageSelect(),
                    Container(
                        margin: EdgeInsets.only(bottom: 40.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _buttons(),
                        )
                    )
                ],
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(body: _body());
    }
}
