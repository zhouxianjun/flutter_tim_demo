import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/components/image_view.dart';
import 'package:tim_demo/components/list_item.dart';
import 'package:tim_demo/dto/user_profile_item_dto.dart';
import 'package:tim_demo/routers.dart';
import 'package:tim_demo/store/mine.dart';
import 'package:tim_demo/styles/index.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  /// 我的信息存储
  MineStore mineStore;

  Widget renderItem(UserProfileItemDTO item) {
    List<Widget> rights = [
      Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      )
    ];
    if (item.value != null) {
      rights.insertAll(0, [item.value, SizedBox(width: 10)]);
    }
    return ListItem(
      text: Text(item.text),
      margin: EdgeInsets.only(left: 18),
      textPadding: EdgeInsets.fromLTRB(0, 18, 10, 18),
      right: Row(
        children: rights,
      ),
      onClick: item.onClick,
    );
  }

  List<UserProfileItemDTO> get items {
    print('更新');
    return [
      UserProfileItemDTO(
          text: '头像',
          value: ImageView(
            img: mineStore?.faceUrl ?? '',
            height: 50.0,
            width: 50.0,
            fit: BoxFit.cover,
          ),
          onClick: () {
            Routers.router.navigateTo(context, Routers.USER_FACE,
                transition: TransitionType.cupertino);
          }),
      UserProfileItemDTO(text: '名字', value: Text(mineStore?.nickName ?? '')),
      UserProfileItemDTO(text: '微信号', value: Text(mineStore?.identifier ?? '')),
      UserProfileItemDTO(
          text: '我的二维码',
          value: Image.asset('assets/images/mine/ic_small_code.png',
              color: Colors.grey.withOpacity(0.7))),
      UserProfileItemDTO(text: '更多'),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mineStore = Provider.of<MineStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    List<UserProfileItemDTO> others = [
      UserProfileItemDTO(text: '我的地址'),
      UserProfileItemDTO(text: '我的发票抬头')
    ];
    List<Widget> itemList = items.map((e) => renderItem(e)).toList();
    itemList.add(SizedBox(height: 10));
    itemList.addAll(others.map((e) => renderItem(e)));
    return Scaffold(
      appBar: CommonBar(
        title: '个人信息',
        centerTitle: true,
        rightDMActions: <Widget>[
          InkWell(child: Image.asset('assets/images/right_more.png'))
        ],
      ),
      backgroundColor: AppColors.appBarColor,
      body: EasyRefresh.custom(slivers: [
        SliverList(
          delegate: SliverChildListDelegate(itemList),
        )
      ]),
    );
  }
}
