import 'dart:convert';
import 'package:tim_demo/pages/chat_page.dart';
import 'package:tim_demo/pages/language_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tim_demo/pages/login_page.dart';
import 'package:tim_demo/pages/select_location_page.dart';

final navGK = GlobalKey<NavigatorState>();
class Routers {
    static Router router;

    static const String LANGUAGE_PAGE = '/language';
    static const String LOGIN_PAGE = '/login';
    static const String SELECT_LOCATION_PAGE = '/select_localtion';
    static const String CHAT_PAGE = '/chat_localtion';

    static void configureRoutes(Router router) {
        router.define(LANGUAGE_PAGE, handler: Handler(handlerFunc: (context, params) => LanguagePage()));
        router.define(LOGIN_PAGE, handler: Handler(handlerFunc: (context, params) => LoginPage()));
        router.define(SELECT_LOCATION_PAGE, handler: Handler(handlerFunc: (context, params) => SelectLocationPage()));
        router.define(CHAT_PAGE, handler: Handler(handlerFunc: (context, params) => ChatPage(
            params['id'].first,
            int.parse(params['typeIndex'].first)
        )));
        router.printTree();
        Routers.router = router;
    }

    static String getRouteUrlOfParams(String url, Map params) {
        String qs = getQueryString(params);
        return url + '?' + qs.substring(1);
    }

    static String getQueryString(Map params, {String prefix: '&', bool inRecursion: false}) {
        String query = '';
        params.forEach((key, value) {
            if (inRecursion) {
                key = '[$key]';
            }

            if (value is String || value is int || value is double || value is bool) {
                query += '$prefix$key=$value';
            } else if (value is List || value is Map) {
                if (value is List) value = value.asMap();
                value.forEach((k, v) {
                    query += getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
                });
            }
        });
        return query;
    }

    /// 传递中文参数前，先转换，fluro 不支持中文传递
    static String encode(String value) {
        StringBuffer sb = StringBuffer();
        List<int> encoded = Utf8Encoder().convert(value);
        encoded.forEach((val) => sb.write('$val,'));
        return sb.toString().substring(0, sb.length - 1).toString();
    }

    /// 传递后取出参数，解析
    static String decode(String value) {
        List<String> decoded = value.split('[').last.split(']').first.split(',');
        List<int> list = decoded.map((s) => int.parse(s.trim()));
        return Utf8Decoder().convert(list);
    }
}