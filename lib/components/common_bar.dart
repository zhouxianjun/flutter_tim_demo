import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tim_demo/styles/index.dart';

class CommonBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonBar(
      {this.title = '',
      this.showShadow = false,
      this.rightDMActions,
      this.backgroundColor = AppColors.appBarColor,
      this.mainColor = Colors.black,
      this.titleWidget,
      this.bottom,
      this.leadingImg = '',
      this.leadingWidget,
      this.canBack = true,
      this.centerTitle = false});

  final String title;
  final bool showShadow;
  final List<Widget> rightDMActions;
  final Color backgroundColor;
  final Color mainColor;
  final Widget titleWidget;
  final Widget leadingWidget;
  final PreferredSizeWidget bottom;
  final String leadingImg;
  final bool centerTitle;
  final bool canBack;

  @override
  Size get preferredSize => Size(100, 50);

  Widget _leading(BuildContext context) {
    final bool isShow = Navigator.canPop(context);
    if (isShow && canBack) {
      return InkWell(
        child: Container(
          width: 15,
          height: 28,
          child: leadingImg != ''
              ? Image.asset(leadingImg)
              : Icon(CupertinoIcons.back, color: mainColor),
        ),
        onTap: () {
          if (Navigator.canPop(context)) {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          }
        },
      );
    } else {
      return null;
    }
  }

  Widget _title() {
    return Text(title,
        style: TextStyle(
            color: mainColor, fontSize: 17.0, fontWeight: FontWeight.w500));
  }

  Widget _shadowBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: showShadow ? 0.5 : 0.0))),
      child: _bar(context, mainColor),
    );
  }

  Widget _bar(BuildContext context, Color bgColor) {
    return AppBar(
      title: titleWidget ?? _title(),
      backgroundColor: bgColor,
      elevation: 0.0,
      brightness: Brightness.light,
      leading: leadingWidget ?? _leading(context),
      centerTitle: centerTitle,
      actions: rightDMActions ?? [Center()],
      bottom: bottom,
      automaticallyImplyLeading: canBack,
      titleSpacing: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return showShadow ? _shadowBar(context) : _bar(context, backgroundColor);
  }
}
