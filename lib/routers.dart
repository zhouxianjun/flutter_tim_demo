import 'dart:convert';
import 'package:tim_demo/pages/language_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final navGK = new GlobalKey<NavigatorState>();
class Routers {
    static Router router;

    static const String LANGUAGE_PAGE = '/language';

    static void configureRoutes(Router router) {
        router.define(LANGUAGE_PAGE, handler: Handler(handlerFunc: (context, params) => LanguagePage()));
        router.printTree();
        Routers.router = router;
    }

    static String encode(String value) {
        StringBuffer sb = StringBuffer();
        List<int> encoded = Utf8Encoder().convert(value);
        encoded.forEach((val) => sb.write('$val,'));
        return sb.toString().substring(0, sb.length - 1).toString();
    }

    static String decode(String value) {
        List<String> decoded = value.split('[').last.split(']').first.split(',');
        List<int> list = decoded.map((s) => int.parse(s.trim()));
        return Utf8Decoder().convert(list);
    }
}