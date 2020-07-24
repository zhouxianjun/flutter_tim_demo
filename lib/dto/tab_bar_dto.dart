import 'package:flutter/material.dart';

class TabBarDTO {
    String title;
    String icon;
    String activeIcon;
    Widget page;
    String badge;

    TabBarDTO(this.title, this.icon, this.activeIcon, this.page, [this.badge]);

    bool showBadge() {
        return badge != null;
    }
}