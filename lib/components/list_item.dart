import 'package:flutter/material.dart';
import 'package:tim_demo/components/horizontal_line.dart';
import 'package:tim_demo/styles/index.dart';

class ListItem extends StatelessWidget {
    final EdgeInsetsGeometry iconPadding;
    final EdgeInsetsGeometry textPadding;
    final EdgeInsetsGeometry margin;
    final bool bottomLine;
    final double height;
    final Widget icon;
    final Text text;
    final Widget right;
    final Color bgColor;
    final VoidCallback onClick;
    final Color bottomLineColor;
    final double bottomLineWidth;

    const ListItem({
        this.iconPadding,
        this.textPadding,
        this.bottomLine = true,
        this.margin,
        this.height,
        this.icon,
        this.text,
        this.right,
        this.bgColor = Colors.white,
        this.onClick,
        this.bottomLineColor = AppColors.lineColor,
        this.bottomLineWidth = 0.2
    });

    Widget renderText() {
        if (text == null) {
            return SizedBox();
        }
        return Expanded(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Expanded(
                            child: Container(
                                padding: textPadding,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                    children: <Widget>[
                                        Expanded(
                                            child: text,
                                        ),
                                        right ?? SizedBox()
                                    ],
                                ),
                            ),
                        ),
                        HorizontalLine()
                    ],
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> rows = [];
        if (icon != null) {
            rows.add(Padding(
                padding: iconPadding,
                child: icon
            ));
        }
        if (text != null) {
            rows.add(renderText());
        }
        return Material(
            color: bgColor,
            child: InkWell(
                child: Container(
                    height: height,
                    margin: margin,
                    child: IntrinsicHeight(
                        child: Row(
                            children: rows,
                        ),
                    ),
                ),
                onTap: onClick,
            ),
        );
    }
}