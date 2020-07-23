import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tim_demo/components/orntdrag.dart';

class DropdownHeaderBar extends StatefulWidget {
    final Widget header;
    final Widget content;
    final Widget hidden;

    DropdownHeaderBar({
        this.header, this.content, this.hidden
    });

    @override
    _DropWXMenuState createState() => _DropWXMenuState();
}

class _DropWXMenuState extends State<DropdownHeaderBar> with TickerProviderStateMixin {
    double offsetY = 0.0;
    double offsetHeader = 0.0;
    AnimationController animationController;
    Animation<double> animation;

    AnimationController animationHeaderController;
    Animation<double> animationHeader;

    AnimationController animationControllerColor;
    Animation<Color> _colorContent;
    Animation<Color> _colorAppBar;
    Animation<BorderRadius> radius;
    bool isOpen = true;
    bool isClose = true;
    double screenHeight = 0.0;
    double scale = 0.0;
    double opacity = 1;

    Map<Type, GestureRecognizerFactory> _contentGestures;

    @override
    Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        return Container(
            color: _colorContent.value,
            child: Stack(
                children: <Widget>[
                    buildHeaderChild(screenHeight),
                    buildContent(screenHeight),
                ],
            ),
        );
    }

    buildHeaderChild(screenHeight){
        return Transform(
            transform: Matrix4.identity()..translate(0.0,isClose ? -(screenHeight-150 - offsetY): offsetHeader),
            child: Opacity(
                opacity: opacity,
                child: RawGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    gestures: _contentGestures,
                    child: Container(
                        color: Color.fromARGB(255, 200, 199, 208),
                        height: screenHeight,
                        margin: EdgeInsets.only(bottom: kToolbarHeight),
                        child: Transform.scale(
                            scale: scale,
                            child: widget.hidden,
                        ),
                    ),
                ),
            ),
        );
    }

    buildContent(screenHeight) {
        return Transform.translate(
            offset: Offset(
                0, isOpen ? offsetY : offsetY - kToolbarHeight), // 正数向下平移 负数向上偏移
            child: Container(
                height: screenHeight,
                child: Column(
                    children: <Widget>[
                        !isOpen?RawGestureDetector(
                            behavior: HitTestBehavior.translucent,
                            gestures: _contentGestures,
                            child: widget.header,
                        ):widget.header,
                        Expanded(
                            child: NotificationListener<ScrollStartNotification>(
                                child: NotificationListener<OverscrollNotification>(
                                    child: NotificationListener<ScrollEndNotification>(
                                        onNotification: (ScrollEndNotification notification) {
                                            if (notification != null &&
                                                notification.dragDetails != null) {
                                                if (offsetY > 0 && offsetY.abs() > 120) {
                                                    animateToHeaderBottom(); //置底
                                                    animateToBottom(screenHeight,bottom: screenHeight-200);
                                                    setState(() {
                                                        isOpen = false;
                                                        isClose = false;
                                                    });
                                                    SystemChrome.setEnabledSystemUIOverlays([]);
                                                    setBottomColor(screenHeight);
                                                } else {
                                                    animateToTop(screenHeight, 0.0,isReverse: false); //重置top 正向
                                                }
                                            }
                                            return false;
                                        },
                                        child: Container(
                                            color: _colorContent.value,
                                            child: widget.content,
                                        ),
                                    ),
                                    onNotification: (OverscrollNotification notification) {
                                        if (notification != null &&
                                            notification.dragDetails != null) {
                                            offsetY += 0.8 * notification.dragDetails.delta.dy;
                                            offsetY = max(0, min(screenHeight, offsetY));
                                            if (offsetY > 150) {
                                                return false;
                                            }
                                            animateToBottom(offsetY);
                                        }
                                        return true;
                                    },
                                ),
                                onNotification: (ScrollStartNotification notification) {
                                    return false;
                                },
                            ),
                        )
                    ],
                ),
            ),
        );
    }

    @override
    void initState() {
        initAnimateColor(1500); //初始化
        _contentGestures = {
            DirectionGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DirectionGestureRecognizer>(
                    () => DirectionGestureRecognizer(DirectionGestureRecognizer.down),
                    (instance) {
                    instance.onDown = _onDragDown;
                    instance.onStart = _onDragStart;
                    instance.onUpdate = _onDragUpdate;
                    instance.onCancel = _onDragCancel;
                    instance.onEnd = _onDragEnd;
                }),
            TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                    () => TapGestureRecognizer(), (instance) {
                instance.onTap = _onContentTap;
            })
        };
        super.initState();
    }

    _onContentTap() {
    }

    _onDragStart(DragStartDetails details) {}

    _onDragDown(DragDownDetails details) {}

    _onDragUpdate(DragUpdateDetails details) {
        offsetHeader += details.delta.dy;
        if (offsetHeader >= screenHeight) {
            offsetHeader = 0;
            return;
        }
        offsetY = screenHeight + (offsetHeader); //从底部拉向顶部 （高度 + 当前的偏移（负数））= 移动量
        if (offsetHeader > 0) {
            return;
        }
        setState(() {});
    }

    initAnimateColor(int time) {
        animationControllerColor = new AnimationController(
            duration: Duration(milliseconds: time), vsync: this);

        _colorContent =
            getColorTween(Colors.white, Color.fromARGB(255, 200, 199, 208)); //内容背景色

        _colorAppBar =
            getColorTween(Colors.white, Color.fromARGB(255, 217, 217, 217)
                .withOpacity(0.5));//AppBar背景色

        radius = getRadius(); //圆角
    }

    _onDragEnd(DragEndDetails details) {
        _onTouchRelease();
    }

    _onDragCancel() {
        //     _onTouchRelease();
    }

    _onTouchRelease() {
        if (offsetHeader > 0) {
            return;
        }
        if (offsetHeader < 0) {
            //置顶
            animateToHeaderTop();
            animateToTop(screenHeight * 0.9, 0.0); //反向执行
            initAnimateColor(1000);
            animationControllerColor.reverse();
            isOpen = true;
            isClose = true;
            setState(() {});
        }
    }

    void animateToTop(double screenHeight, double endHeight,
        {bool isReverse = true}) {
        animationController = new AnimationController(
            duration: Duration(
                milliseconds: ((screenHeight +
                    (!isReverse
                        ? offsetHeader.abs().floor()
                        : offsetY.abs())) *
                    0.3)
                    .abs()
                    .floor()),
            vsync: this);
        final curve =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
        animation = Tween(
            begin: !isReverse ? offsetY : -screenHeight - offsetHeader,
            end: endHeight)
            .animate(curve);
        animation.addListener(() {
            setState(() {
                if (isReverse) {
                    offsetY = -animation.value; //底部反弹回顶部
                } else {
                    offsetY = animation.value; //正常反弹
                }
            });
        });
        animationController.forward();
    }

    void animateToHeaderTop() {
        animationHeaderController = new AnimationController(
            duration: Duration(
                milliseconds: ((screenHeight + offsetHeader).abs() * 2).floor()),
            vsync: this);
        final curve = CurvedAnimation(
            parent: animationHeaderController, curve: Curves.decelerate);
        animationHeader =
            Tween(begin: offsetHeader, end: -screenHeight).animate(curve);
        animationHeader.addListener(() {
            setState(() {
                offsetHeader = animationHeader.value;
            });
        });
        animationHeaderController.forward(from: offsetHeader);
    }

    void animateToBottom(double screenHeight,{double bottom = 200}) {
        animationController = AnimationController(
            duration: Duration(
                milliseconds: ((screenHeight - offsetY.abs()) * 0.5).abs().floor()),
            vsync: this);
        final curve =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
        animation = Tween(begin: offsetY, end: screenHeight).animate(curve);

        animation.addListener(() {
            setState(() {
                offsetY = animation.value;
                scale = (offsetY.abs() / bottom) > 1? 1: (offsetY.abs() / bottom); //获取当前的缩放进度
                opacity = (offsetY.abs() / screenHeight);
            });
        });
        animationController.forward();
    }

    void animateToHeaderBottom() {
        animationHeaderController = new AnimationController(
            duration: Duration(
                milliseconds: ((screenHeight - offsetY.abs()) * 0.5).abs().floor()),
            vsync: this);
        final curves = CurvedAnimation(
            parent: animationHeaderController, curve: Curves.decelerate);
        animationHeader =
            Tween(begin: -screenHeight + offsetY.abs(), end: 0.0).animate(curves);
        animationHeader.addListener(() {
            setState(() {
                offsetHeader = animationHeader.value;
            });
        });
        animationHeaderController.forward();
    }

    //颜色更改
    void setBottomColor(screenHeight) {
        animationControllerColor.forward();
    }

    void setTopColor(offset) {
        animationControllerColor.reverse(from: offset);
    }

    //获取ColorTween
    Animation<Color> getColorTween(Color begin, Color end) {
        return ColorTween(
            begin: begin,
            end: end,
        ).animate(
            CurvedAnimation(
                parent: animationControllerColor,
                curve: Interval(
                    0,
                    1,
                    curve: Curves.linear,
                ),
            ),
        );
    }

    //获取圆角动画
    Animation<BorderRadius> getRadius() {
        return BorderRadiusTween(
            begin: BorderRadius.circular(0.0),
            end: BorderRadius.only(
                topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        ).animate(
            CurvedAnimation(
                parent: animationControllerColor,
                curve: Interval(
                    0.5,
                    0.75,
                    curve: Curves.ease,
                ),
            ),
        );
    }
}

class MyBehavior extends ScrollBehavior {
    //继承ScrollBehavior 返回滚动手势
    @override
    Widget buildViewportChrome(
        BuildContext context, Widget child, AxisDirection axisDirection) {
        if (Platform.isAndroid || Platform.isFuchsia) {
            //去掉安卓水波纹
            return child;
        } else {
            return super.buildViewportChrome(context, child, axisDirection);
        }
    }
}