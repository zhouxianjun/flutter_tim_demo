import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/list_item.dart';
import 'package:tim_demo/components/search_button.dart';
import 'package:tim_demo/pages/search_page.dart';
import 'package:tim_demo/store/mine.dart';
import 'package:tim_demo/styles/index.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddFriendPage();
  }
}

class _AddFriendPage extends State<AddFriendPage> {
  MineStore mineStore;

  Widget renderItem(
      String icon, String label, String memo, VoidCallback callback) {
    return ListItem(
      iconPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      textPadding: EdgeInsets.only(right: 20.0),
      icon: ImageView(
        img: icon,
        width: 30.0,
      ),
      text: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),
          ),
          Text(
            memo,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          )
        ],
      ),
      right: Icon(
        Icons.arrow_forward_ios,
        size: 18.0,
        color: Colors.grey,
      ),
      onClick: callback,
    );
  }

  List<Widget> renderOtherItems() {
    List data = [
      {
        'label': '雷达加朋友',
        'memo': '添加身边的朋友',
        'icon': 'assets/images/contact/ic_reda.webp'
      },
      {
        'label': '面对面建群',
        'memo': '与身边的朋友进入同一个群聊',
        'icon': 'assets/images/contact/ic_group.webp'
      },
      {
        'label': '扫一扫',
        'memo': '扫描二维码名片',
        'icon': 'assets/images/contact/ic_scanqr.webp'
      },
      {
        'label': '公众号',
        'memo': '获取更多咨询和服务',
        'icon': 'assets/images/contact/ic_offical.webp'
      },
      {
        'label': '企业微信联系人',
        'memo': '通过手机号搜索企业微信用户',
        'icon': 'assets/images/contact/ic_search_wework.webp'
      }
    ];
    return data
        .map((item) =>
            renderItem(item['icon'], item['label'], item['memo'], () {}))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mineStore = Provider.of<MineStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      SearchButton(
          text: '微信号/手机号',
          callback: () {
            showASearch(
                context: context,
                delegate: SearchPage(onSearch: (value) async {
                  return Container(
                    child: Text(value),
                  );
                }));
          }),
      Container(
        color: AppColors.appBarColor,
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('我的微信号:'),
            SizedBox(width: 10),
            Text(mineStore?.identifier ?? ''),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/mine/ic_small_code.png',
              fit: BoxFit.cover,
              height: 16.0,
              width: 16.0,
              color: Colors.green,
            ),
          ],
        ),
      )
    ];

    list.addAll(renderOtherItems());

    return Scaffold(
      appBar: CommonBar(
        title: '添加朋友',
        centerTitle: true,
      ),
      body: EasyRefresh.custom(slivers: [
        SliverList(
          delegate: SliverChildListDelegate(list),
        )
      ]),
    );
  }
}
