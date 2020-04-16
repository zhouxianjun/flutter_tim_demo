import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/pages/root_page.dart';
import 'package:tim_demo/pages/start_page.dart';
import 'package:tim_demo/routers.dart';
import 'package:tim_demo/store/app.dart';
import 'package:tim_demo/styles/index.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class MyApp extends StatefulWidget {
    MyApp() {
        final Router router = new Router();
        Routers.configureRoutes(router);
    }
    @override
    _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
    @override
    void initState() {
        super.initState();
        TencentImPlugin.init(appid: '1400352283');
    }

    @override
    Widget build(BuildContext context) {
        final AppStore appStore = Provider.of<AppStore>(context);
        return Observer(
            builder: (_) => new MaterialApp(
                navigatorKey: navGK,
                title: "flutter im demo",
                theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.bgColor,
                    hintColor: Colors.grey.withOpacity(0.3),
                    splashColor: Colors.transparent,
                    canvasColor: Colors.transparent,
                ),
                onGenerateRoute: Routers.router.generator,
                navigatorObservers: [RouterObserver()],
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                    S.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: appStore.locale,
                home: appStore.isLogin ? RootPage() : StartPage(),
            )
        );
    }
}

class RouterObserver extends NavigatorObserver {
    @override
    void didPush(Route route, Route previousRoute) {
        super.didPush(route, previousRoute);
    }
}