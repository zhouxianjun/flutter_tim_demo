import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/common_button.dart';
import 'package:tim_demo/components/loading.dart';
import 'package:tim_demo/components/vertical_line.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/routers.dart';
import 'package:tim_demo/store/app.dart';
import 'package:tim_demo/styles/index.dart';
import 'package:tim_demo/util/index.dart';

class LoginPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final _formKey = GlobalKey<FormBuilderState>();
    bool formValidate = false;
    AppStore appStore;
    String locationName;

    @override
    didChangeDependencies () {
        super.didChangeDependencies();
        appStore = Provider.of<AppStore>(context);
    }

    String getLocationName() {
        return locationName ?? '${S.of(context).chinaMainland}  (+86)';
    }

    /// 底部按钮
    List<Widget> _bottomItems() {
        List items = [
            S.of(context).retrievePW,
            S.of(context).emergencyFreeze,
            S.of(context).weChatSecurityCenter,
        ];
        List<Widget> list = items.map((text) => InkWell(
            child: Text(text, style: TextStyle(color: AppColors.tipColor)),
            onTap: () {
                Fluttertoast.showToast(
                    msg: S.of(context).notOpen + text,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    fontSize: 16.0
                );
            }
        )).toList();
        return joinWrapper(list, (item) => Row(
            children: <Widget>[
                item,
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: VerticalLine(height: 15.0),
                )
            ],
        ));
    }

    /// 底部块
    Widget bottomWrapper() {
        return Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bottomItems(),
            ),
        );
    }

    /// 表单标题
    Widget bodyTitle() {
        return Padding(
            padding: EdgeInsets.only(
                left: 20.0, top: mainSpace * 3, bottom: mainSpace * 2
            ),
            child: Text(
                S.of(context).mobileNumberLogin,
                style: TextStyle(fontSize: 25.0)
            ),
        );
    }

    /// 国家/地区
    Widget phoneCity() {
        return FlatButton(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                    children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                S.of(context).phoneCity,
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w400
                                )
                            ),
                        ),
                        Expanded(
                            child: Text(
                                getLocationName(),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400
                                ),
                            ),
                        )
                    ],
                ),
            ),
            onPressed: () async {
                final result = await Routers.router.navigateTo(context, Routers.SELECT_LOCATION_PAGE);
                setState(() {
                    locationName = '${result['name']}  (${result['code']})';
                });
            },
        );
    }

    /// 手机号输入
    Widget phoneItem() {
        return Row(
            children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 25.0),
                    child: Text(
                        S.of(context).phoneNumber,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                ),
                FormBuilder(
                    key: _formKey,
                    autovalidate: true,
                    child: Expanded(
                        child: FormBuilderTextField(
                            attribute: 'phone',
                            decoration: InputDecoration(hintText: S.of(context).phoneNumberHint, border: InputBorder.none),
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],
                            validators: [
                                FormBuilderValidators.required(errorText: S.of(context).phoneNumberError),
                                FormBuilderValidators.pattern(phonePattern.pattern, errorText: S.of(context).phoneNumberError)
                            ],
                        )
                    ),
                    onChanged: (_) {
                        setState(() {
                            formValidate = _formKey.currentState.validate();
                        });
                    },
                )
            ],
        );
    }

    /// 登录按钮
    Widget loginButton() {
        return CommonButton(
            text: S.of(context).login,
            style: TextStyle(
                color:
                formValidate ? Colors.white : Colors.grey.withOpacity(0.8)
            ),
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            color: formValidate
                ? Color.fromRGBO(8, 191, 98, 1.0)
                : Color.fromRGBO(226, 226, 226, 1.0),
            onTap: formValidate ? () {
                appStore.login(context, _formKey.currentState.value['phone']);
            } : () => {},
        );
    }

    Widget body() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                bodyTitle(),
                phoneCity(),
                Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.grey, width: 0.15))
                    ),
                    child: phoneItem(),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: InkWell(
                        child: Text(
                            S.of(context).userLoginTip,
                            style: TextStyle(color: AppColors.tipColor),
                        ),
                        onTap: () => Fluttertoast.showToast(msg: S.of(context).notOpen),
                    ),
                ),
                Container(width: 10.0, height: mainSpace * 2.5),
                loginButton(),
            ],
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: CommonBar(title: '', leadingImg: 'assets/images/bar_close.png'),
            body: Container(
                color: AppColors.appBarColor,
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                    child: Stack(
                        children: <Widget>[
                            SingleChildScrollView(child: body()),
                            bottomWrapper(),
                        ],
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                    },
                ),
            )
        );
    }
}