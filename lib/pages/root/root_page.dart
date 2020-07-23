import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/tab_bar_icon.dart';
import 'package:tim_demo/dto/tab_bar_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/pages/root/home_page.dart';
import 'package:tim_demo/styles/index.dart';

class RootPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
    int currentIndex = 0;

    @override
    void initState() {
        super.initState();
        TencentImPlugin.addListener(messageListener);
    }
    @override
    void dispose() {
        super.dispose();
        TencentImPlugin.removeListener(messageListener);
    }

    List<BottomNavigationBarItem> getBottomBarList(List<TabBarDTO> list) {
        return list.map((item) => BottomNavigationBarItem(
            title: Text(
                item.title,
                style: TextStyle(fontSize: 12.0)
            ),
            icon: TabBarIcon(item.icon),
            activeIcon: TabBarIcon(item.activeIcon)
        )).toList();
    }

    /// 由于内部页面要保存状态，所有混入了AutomaticKeepAliveClientMixin，而AutomaticKeepAliveClientMixin则需要PageView或者IndexedStack包装
    Widget renderBody(List<Widget> children) {
        return IndexedStack(
            index: currentIndex,
            children: children
        );
    }

    BottomNavigationBar bottomNavigationBar(List<TabBarDTO> tabBarList) {
        return BottomNavigationBar(
            items: getBottomBarList(tabBarList),
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Colors.green,
            onTap: (int index) {
                setState(() => currentIndex = index);
            },
            unselectedFontSize: 18.0,
            selectedFontSize: 18.0,
            elevation: 0
        );
    }

    /// 底部导航栏有背景色并且有上边框，所有在上面包装了一层
    Widget renderBottomBar(BottomNavigationBar bar) {
        return Theme(
            data: ThemeData(
                canvasColor: Colors.grey[50],
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
            ),
            child: Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.lineColor, width: 0.2))
                ),
                child: bar,
            )
        );
    }

    messageListener(ListenerTypeEnum type, params) {
        print('接收到消息 ${type}');
        print(params);
        if (type == ListenerTypeEnum.NewMessages) {
            print('收到消息');
        }
    }

    @override
    Widget build(BuildContext context) {
        List<TabBarDTO> tabBarList = <TabBarDTO>[
            TabBarDTO(S.of(context).weChat, 'assets/images/tabbar_chat_c.webp', 'assets/images/tabbar_chat_s.webp', HomePage()),
            TabBarDTO(S.of(context).contacts, 'assets/images/tabbar_contacts_c.webp', 'assets/images/tabbar_contacts_s.webp', HomePage()),
            TabBarDTO(S.of(context).discover, 'assets/images/tabbar_discover_c.webp', 'assets/images/tabbar_discover_s.webp', HomePage()),
            TabBarDTO(S.of(context).me, 'assets/images/tabbar_me_c.webp', 'assets/images/tabbar_me_s.webp', HomePage())
        ];
        List<Widget> pages = tabBarList.map((item) => item.page).toList();
        return Scaffold(
            body: renderBody(pages),
            bottomNavigationBar: renderBottomBar(bottomNavigationBar(tabBarList))
        );
    }
}
