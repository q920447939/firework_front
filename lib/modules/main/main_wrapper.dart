import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class MainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: TDBottomTabBar(
        TDBottomTabBarBasicType.iconText,
        componentType: TDBottomTabBarComponentType.label,
        outlineType: TDBottomTabBarOutlineType.capsule,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            selectedIcon: const Icon(Icons.home, color: Colors.blue),
            unselectedIcon: const Icon(Icons.home, color: Colors.grey),
            tabText: '首页',
            onTap: () => _onTap(0),
          ),
          TDBottomTabBarTabConfig(
            selectedIcon: const Icon(Icons.shopping_cart, color: Colors.blue),
            unselectedIcon: const Icon(Icons.shopping_cart, color: Colors.grey),
            tabText: '购物车',
            onTap: () => _onTap(1),
          ),
          TDBottomTabBarTabConfig(
            selectedIcon: const Icon(Icons.person, color: Colors.blue),
            unselectedIcon: const Icon(Icons.person, color: Colors.grey),
            tabText: '个人中心',
            onTap: () => _onTap(2),
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
