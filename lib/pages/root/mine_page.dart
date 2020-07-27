import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/store/mine.dart';
import 'package:tim_demo/styles/index.dart';

class MinePage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
    MineStore mineStore;
    double infoHeight = 80;

    Widget renderInfo() {
        return Container(
            padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 45.0),
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    ImageView(
                        img: mineStore.faceUrl ?? defIcon,
                        height: infoHeight,
                        width: infoHeight,
                        fit: BoxFit.cover,
                    ),
                    SizedBox(
                        width: 20.0,
                    ),
                    Expanded(
                        child: Container(
                            height: infoHeight,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                    Text(
                                        mineStore.nickName ?? '',
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500
                                        ),
                                    ),
                                    Text(
                                        '微信号: ${mineStore.identifier}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey
                                        ),
                                    )
                                ],
                            ),
                        ),
                    ),
                    Container(
                        height: infoHeight,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                                Text(''),
                                Row(
                                    children: <Widget>[
                                        Image.asset(
                                            'assets/images/mine/ic_small_code.png',
                                            fit: BoxFit.cover,
                                            height: 18.0,
                                            width: 18.0,
                                            color: Colors.grey,
                                        ),
                                        SizedBox(
                                            width: 20.0,
                                        ),
                                        Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18.0,
                                            color: Colors.grey,
                                        )
                                    ],
                                )
                            ],
                        ),
                    )
                ],
            ),
        );
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        mineStore = Provider.of<MineStore>(context);
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Scaffold(
            appBar: CommonBar(
                backgroundColor: AppColors.bgColor,
                rightDMActions: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                        ),
                    )
                ],
            ),
            backgroundColor: AppColors.appBarColor,
            body: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        renderInfo()
                    ],
                ),
            ),
        );
    }

    @override
    bool get wantKeepAlive => true;
}