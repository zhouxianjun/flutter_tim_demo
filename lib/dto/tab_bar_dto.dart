import 'package:flutter/material.dart';

class TabBarDTO {
    String title;
    String icon;
    String activeIcon;
    Widget page;

    TabBarDTO(this.title, this.icon, this.activeIcon, this.page);
}