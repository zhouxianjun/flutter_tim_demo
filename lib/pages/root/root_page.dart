import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/tab_bar_icon.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/dto/tab_bar_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/pages/root/contacts_page.dart';
import 'package:tim_demo/pages/root/discover_page.dart';
import 'package:tim_demo/pages/root/home_page.dart';
import 'package:tim_demo/pages/root/mine_page.dart';
import 'package:tim_demo/store/im.dart';
import 'package:tim_demo/styles/index.dart';

class RootPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
    int currentIndex = 0;
    IMStore imStore;

    @override
    void initState() {
        super.initState();
        globalContext = context;
        resetUnreadCount();
        TencentImPlugin.addListener(messageListener);
    }
    @override
    void dispose() {
        super.dispose();
        TencentImPlugin.removeListener(messageListener);
    }

    @override
    didChangeDependencies () {
        super.didChangeDependencies();
        imStore = Provider.of<IMStore>(context);
    }

    Badge getBarBadge(TabBarDTO item, Widget child) {
        return Badge(
            showBadge: item.showBadge(),
            badgeContent: Text(item.badge ?? '', style: TextStyle(color: Colors.white, fontSize: 10.0)),
            position: BadgePosition.topRight(top: -15.0, right: -14.0),
            padding: EdgeInsets.all(4.0),
            child: child,
        );
    }

    List<BottomNavigationBarItem> getBottomBarList(List<TabBarDTO> list) {
        return list.map((item) => BottomNavigationBarItem(
            title: Text(
                item.title,
                style: TextStyle(fontSize: 12.0)
            ),
            icon: getBarBadge(item, TabBarIcon(item.icon)),
            activeIcon: getBarBadge(item, TabBarIcon(item.activeIcon))
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
                    border: Border(top: BorderSide(color: AppColors.lineColor, width: 0.2)),
                    color: Colors.grey[50]
                ),
                padding: EdgeInsets.only(top: 10.0),
                child: bar,
            )
        );
    }

    String get unreadCount {
        return imStore.unreadCount > 0 ? '${imStore.unreadCount}' : null;
    }

    List<TabBarDTO> get tabBars {
        return <TabBarDTO>[
            TabBarDTO(S.of(context).weChat, 'assets/images/tabbar_chat_c.webp', 'assets/images/tabbar_chat_s.webp', HomePage(), unreadCount),
            TabBarDTO(S.of(context).contacts, 'assets/images/tabbar_contacts_c.webp', 'assets/images/tabbar_contacts_s.webp', ContactsPage()),
            TabBarDTO(S.of(context).discover, 'assets/images/tabbar_discover_c.webp', 'assets/images/tabbar_discover_s.webp', DiscoverPage()),
            TabBarDTO(S.of(context).me, 'assets/images/tabbar_me_c.webp', 'assets/images/tabbar_me_s.webp', MinePage())
        ];
    }

    Future<int> getUnreadCount([List<SessionEntity> conversationList]) async {
        if (conversationList == null) {
            conversationList = await TencentImPlugin.getConversationList();
        }
        if (conversationList.length <= 0) {
            return 0;
        }
        return conversationList.map((e) => e.unreadMessageNum).reduce((value, element) => value += element);
    }

    resetUnreadCount([List<SessionEntity> conversationList]) async {
        int count = await getUnreadCount(conversationList);
        imStore.changeUnreadCount(count);
    }

    messageListener(ListenerTypeEnum type, params) {
        print(type);
        if (type == ListenerTypeEnum.Refresh) {
            resetUnreadCount();
        }
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> pages = tabBars.map((item) => item.page).toList();
        return Observer(
            builder: (_) {
                return Scaffold(
                    body: renderBody(pages),
                    bottomNavigationBar: renderBottomBar(bottomNavigationBar(tabBars))
                );
            },
        );
    }
}
