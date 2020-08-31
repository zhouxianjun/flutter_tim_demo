import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/list_item.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/routers.dart';
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
    return InkWell(
      child: Container(
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
                          fontSize: 22.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '微信号: ${mineStore.identifier}',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
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
      ),
      onTap: () => Routers.router.navigateTo(context, Routers.USER_PROFILE,
          transition: TransitionType.cupertino),
    );
  }

  Widget renderItem(String icon, String label, VoidCallback callback) {
    return ListItem(
        iconPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        textPadding: EdgeInsets.only(right: 20.0),
        icon: ImageView(
          img: icon,
          width: 30.0,
        ),
        text: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
        ),
        right: Icon(
          Icons.arrow_forward_ios,
          size: 18.0,
          color: Colors.grey,
        ),
        onClick: callback);
  }

  List<Widget> renderOtherItems() {
    List data = [
      {'label': '收藏', 'icon': 'assets/images/favorite.webp'},
      {'label': '相册', 'icon': 'assets/images/mine/ic_card_package.png'},
      {'label': '卡片', 'icon': 'assets/images/mine/ic_card_package.png'},
      {'label': '表情', 'icon': 'assets/images/mine/ic_emoji.png'}
    ];
    return data
        .map((item) => renderItem(item['icon'], item['label'], () {}))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mineStore = Provider.of<MineStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> items = [
      renderInfo(),
      SizedBox(height: 10),
      renderItem('assets/images/mine/ic_pay.png', '支付', () {}),
      SizedBox(height: 10)
    ];
    items.addAll(renderOtherItems());
    items.add(SizedBox(height: 10));
    items.add(renderItem('assets/images/mine/ic_setting.png', '设置', () {}));
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
          children: items,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
