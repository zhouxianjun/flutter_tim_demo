import 'dart:developer';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

class ContactsItemDTO extends ISuspensionBean {
  VoidCallback onClick;
  String name;
  String icon;
  String tag;

  ContactsItemDTO({@required this.name, this.icon, this.onClick, this.tag}) {
    if (this.tag == null) {
      this.tag = _parseTag();
    }
  }

  @override
  String getSuspensionTag() {
    return tag;
  }

  _parseTag() {
    try {
      String pinyin = PinyinHelper.getPinyinE(this.name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      return RegExp("[A-Z]").hasMatch(tag) ? tag : '#';
    } catch (e) {
      log('获取昵称拼音失败', error: e);
      return '#';
    }
  }
}
