import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tim_demo/components/triangle_painter.dart';
import 'package:tim_demo/util/index.dart';

/// 1.长按  2.单击
enum PressType { longPress, singleClick }
const double _kMenuScreenPadding = 8.0;
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;

class PopupDropdown<V> extends StatefulWidget {
    // 弹出内容内边距
    final EdgeInsets padding;
    // 点击选项事件
    final ValueChanged<V> onChange;
    // 选项列表
    final List<PopupDropdownItem<V>> items;
    // 触发对象
    final Widget child;
    // 点击方式 长按 还是单击
    final PressType pressType;
    // 弹出内容背景色
    final Color backgroundColor;
    // 弹出内容宽度
    final double width;
    // popup时间
    final Duration transitionDuration;
    // 点击空白处事件
    final VoidCallback onCanceled;
    // 弹出位置偏移
    final Offset offset;
    // 是否开启弹出动画
    final bool isAnimation;
    // 是否在每项之间插入分割线
    final bool isDivider;

    PopupDropdown({
        Key key,
        @required this.onChange,
        @required this.items,
        @required this.child,
        this.pressType = PressType.singleClick,
        this.backgroundColor = Colors.black,
        this.width = 250,
        this.padding,
        this.transitionDuration = const Duration(milliseconds: 300),
        this.onCanceled,
        this.offset = const Offset(-10, 0),
        this.isAnimation = false,
        this.isDivider = false
    })
        : assert(onChange != null),
            assert(items != null && items.length > 0),
            assert(child != null),
            super(key: key);

    @override
    State<StatefulWidget> createState() => _PopupDropdownState<V>();
}

class _PopupDropdownState<V> extends State<PopupDropdown> {

    @override
    Widget build(BuildContext context) {
        return InkWell(
            child: widget.child,
            onTap: () {
                if (widget.pressType == PressType.singleClick) {
                    fire();
                }
            },
            onLongPress: () {
                if (widget.pressType == PressType.longPress) {
                    fire();
                }
            },
        );
    }

    void fire() {
        showPopupDropdown<V>(context, widget.items,
            backgroundColor: widget.backgroundColor,
            onCanceled: widget.onCanceled,
            onChange: (widget as PopupDropdown<V>).onChange,
            transitionDuration: widget.transitionDuration,
            offset: widget.offset,
            width: widget.width,
            padding: widget.padding,
            isAnimation: widget.isAnimation
        );
    }
}

void showPopupDropdown<V>(BuildContext context,
    List<PopupDropdownItem<V>> items,
    {
        Color backgroundColor,
        Offset offset = Offset.zero,
        Duration transitionDuration,
        double width,
        bool isAnimation,
        EdgeInsets padding = EdgeInsets.zero,
        VoidCallback onCanceled,
        ValueChanged<V> onChange,
        bool isDivider = false
    }) {
    RenderBox target = context.findRenderObject();
    RenderBox overlay = Overlay.of(context).context.findRenderObject();
    RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
            target.localToGlobal(offset, ancestor: overlay),
            target.localToGlobal(target.size.bottomRight(Offset.zero), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
    );

    Navigator.push(
        context,
        PopupDropdownRoute<V>(
            targetContext: context,
            position: position,
            target: target,
            items: items,
            backgroundColor: backgroundColor,
            width: width,
            isAnimation: isAnimation,
            isDivider: isDivider,
            duration: transitionDuration,
            padding: padding
        )
    ).then((V result) {
        if (result == null && onCanceled != null) {
            onCanceled();
            return;
        }
        if (result != null) {
            onChange(result);
        }
    });
}

class PopupDropdownRoute<V> extends PopupRoute<V> {
    final EdgeInsets padding;
    final List<PopupDropdownItem<V>> items;
    final Color backgroundColor;
    final double width;
    final Duration duration;
    final BuildContext targetContext;
    final Offset offset;
    final RelativeRect position;
    final RenderBox target;
    final bool isAnimation;
    final bool isDivider;

    PopupDropdownRoute({
        Key key,
        @required this.items,
        @required this.targetContext,
        @required this.position,
        @required this.target,
        this.backgroundColor,
        this.width,
        this.padding,
        this.duration,
        this.offset = Offset.zero,
        this.isAnimation = false,
        this.isDivider = false
    });

    @override
    Color get barrierColor => null;

    @override
    bool get barrierDismissible => true;

    @override
    String get barrierLabel => null;

    @override
    Animation<double> createAnimation() {
        return CurvedAnimation(
            parent: super.createAnimation(),
            curve: Curves.linear,
            reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
        );
    }

    @override
    Widget buildPage(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
        return PopupDropdownWidget(this);
    }

    @override
    Duration get transitionDuration => duration;

}

class PopupDropdownWidget<V> extends StatelessWidget {
    final PopupDropdownRoute<V> route;

    PopupDropdownWidget(this.route);

    Widget buildItem(BuildContext context, PopupDropdownItem<V> item, bool isLast) {
        final Widget widget = item.buildWidget(isLast);
        return item.isDivider ? widget : FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
                Navigator.of(context).pop(item.value);
            },
            child: widget,
        );
    }

    Widget buildContent(BuildContext context, List<Widget> items) {
        return Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                CustomPaint(
                    size: Size(route.width, 8),
                    painter: TrianglePainter(
                        color: route.backgroundColor,
                        position: route.position,
                        isInverted: true,
                        size: route.target.size,
                        screenWidth: MediaQuery.of(context).size.width,
                    ),
                ),
                Container(
                    width: route.width,
                    padding: route.padding,
                    decoration: BoxDecoration(
                        color: route.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items,
                    ),
                ),
            ]),
        );
    }

    /// 动画
    AnimatedBuilder builderAnimation(Widget child) {
        final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
        final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
        final CurveTween width = CurveTween(curve: Interval(0.0, unit));
        final CurveTween height = CurveTween(curve: Interval(0.0, unit));
        return AnimatedBuilder(
            animation: route.animation,
            builder: (_, Widget child) => Opacity(
                opacity: opacity.evaluate(route.animation),
                child: Material(
                    type: MaterialType.card,
                    child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        widthFactor: width.evaluate(route.animation),
                        heightFactor: height.evaluate(route.animation),
                        child: child,
                    ),
                ),
            ),
            child: child,
        );
    }

    Widget buildBody(BuildContext context, List<Widget> list) {
        final Widget child = buildContent(context, list);
        return route.isAnimation ? builderAnimation(child) : child;
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> items = route.items.asMap().entries.map((MapEntry<int, PopupDropdownItem<V>> entry) => buildItem(context, entry.value, entry.key >= route.items.length - 1)).toList();
        if (route.isDivider && !route.items.any((item) => item.isDivider)) {
            join(items, _DividerItem());
        }
        return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: Builder(builder: (BuildContext context) {
                return CustomSingleChildLayout(
                    // 这里计算偏移量
                    delegate: PopupDropdownRouteLayout(
                        route.position,
                        route.target.size.width,
                        route.target.size.height
                    ),
                    child: buildBody(context, items)
                );
            }),
        );
    }
}

/// widget 采用 => build => item => label
class PopupDropdownItem<V> {
    final V value;
    final bool cache;
    final String label;
    final Color color;
    final Widget icon;
    final Widget item;
    final bool isDivider;
    final double height;
    final Widget Function(PopupDropdownItem<V> item) build;
    final Alignment alignment;
    Widget _widget;

    PopupDropdownItem({
        this.value,
        this.label,
        this.icon,
        this.height = 50.0,
        this.color = Colors.white,
        this.isDivider = false,
        this.item,
        this.build,
        this.alignment = Alignment.centerLeft,
        this.cache = false
    }) : assert(build != null || item != null || label != null || isDivider),
    assert(value != null || isDivider);

    Widget buildWidget(bool isLast) {
        if (cache && _widget != null) {
            return _widget;
        }
        if (build != null) {
            _widget = build(this);
        } else if (item != null) {
            _widget = item;
        } else {
            if (isDivider) {
                _widget = _DividerItem();
            } else {
                List<Widget> list = [
                    Expanded(
                        child: Container(
                            height: height,
                            alignment: alignment,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                                border: isLast ? null : Border(
                                    bottom: BorderSide(
                                        color: color.withOpacity(0.7),
                                        width: 0.2
                                    )
                                )
                            ),
                            child: Text(
                                label,
                                style: TextStyle(color: color),
                            )
                        )
                    )
                ];
                if (icon != null) {
                    list.insert(0, icon);
                }
                _widget = Row(mainAxisSize: MainAxisSize.min, children: list);
            }
        }
        return _widget;
    }
}

// Positioning of the menu on the screen.
class PopupDropdownRouteLayout extends SingleChildLayoutDelegate {
    PopupDropdownRouteLayout(this.position, this.fireWidth, this.fireHeight);

    // Rectangle of underlying button, relative to the overlay's dimensions.
    final RelativeRect position;

    // 触发者宽度
    final double fireWidth;
    // 触发者高度
    final double fireHeight;

    // We put the child wherever position specifies, so long as it will fit within
    // the specified parent size padded (inset) by 8. If necessary, we adjust the
    // child's position so that it fits.

    @override
    BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
        // The menu can be at most the size of the overlay minus 8.0 pixels in each
        // direction.
        return BoxConstraints.loose(constraints.biggest -
            const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
    }

    @override
    Offset getPositionForChild(Size size, Size childSize) {
        // size: The size of the overlay.
        // childSize: The size of the menu, when fully open, as determined by
        // getConstraintsForChild.

        // Find the ideal vertical position.
        double y = position.top;
        // Find the ideal horizontal position.
        double x;

        // 如果menu 的宽度 小于 child(触发者) 的宽度，则直接把menu 放在 child 中间
        if (childSize.width < fireWidth) {
            x = position.left + (fireWidth - childSize.width) / 2;
        } else {
            // 如果靠右
            if (position.left > size.width - (position.left + fireWidth)) {
                if (size.width - (position.left + fireWidth) >
                    childSize.width / 2 + _kMenuScreenPadding) {
                    x = position.left - (childSize.width - fireWidth) / 2;
                } else
                    x = position.left + fireWidth - childSize.width;
            } else if (position.left < size.width - (position.left + fireWidth)) {
                if (position.left > childSize.width / 2 + _kMenuScreenPadding) {
                    x = position.left - (childSize.width - fireWidth) / 2;
                } else
                    x = position.left;
            } else {
                x = position.right - fireWidth / 2 - childSize.width / 2;
            }
        }

        if (y < _kMenuScreenPadding)
            y = _kMenuScreenPadding;
        else if (y + childSize.height > size.height - _kMenuScreenPadding)
            y = size.height - childSize.height - _kMenuScreenPadding;
        else if (y < childSize.height * 2) {
            y = position.top + fireHeight;
        }
        return Offset(x, y);
    }

    @override
    bool shouldRelayout(PopupDropdownRouteLayout oldDelegate) {
        return position != oldDelegate.position;
    }
}
Widget _DividerItem() {
    return Divider(height: 1.0, color: Colors.white.withOpacity(0.8));
}
