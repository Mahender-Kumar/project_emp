import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold({
    super.key,
    required this.currentPath,
    required this.body,
    this.secondaryBody,
    this.mobileNavs = 3,
  });

  final Widget body;
  final String currentPath;
  final Widget? secondaryBody;
  final int mobileNavs;

  final List<Map<String, dynamic>> navList = [
    {
      'icon': const Icon(Icons.home_outlined),
      'selectedIcon': const Icon(Icons.home),
      'label': 'Home',
      'path': '/',
    },
    {
      'icon': const Icon(Icons.search),
      'selectedIcon': const Icon(Icons.search_outlined),
      'label': "Search",
      'path': '/search',
    },
    // {
    //   'icon': const Icon(Icons.edit_note_rounded),
    //   'selectedIcon': const Icon(Icons.edit_note_rounded),
    //   'label': "Add",
    //   'path': '/add',
    // },
  ];
  @override
  Widget build(BuildContext context) {
    int index = navList.indexWhere(
      (e) => e['path'] != '/' && currentPath.startsWith(e['path']),
    );
    int selectedIndex = index == -1 ? 0 : index;

    return AdaptiveLayout(
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.smallAndUp: SlotLayout.from(
            key: const Key('Body All'),
            builder: (_) => body,
          ),
        },
      ),
      bottomNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.smallAndUp: SlotLayout.from(
            key: const Key('Bottom Navigation Small'),
            inAnimation: AdaptiveScaffold.bottomToTop,
            outAnimation: AdaptiveScaffold.topToBottom,
            builder:
                (_) => BottomNavigationBar(
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  elevation: 4,
                  landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    ...navList
                        .take(mobileNavs)
                        .map(
                          (e) => BottomNavigationBarItem(
                            icon: e['icon'],
                            activeIcon: e['selectedIcon'],
                            label: (e['label']),
                          ),
                        ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    GoRouter.of(context).go(navList[index]['path'] ?? '/');
                  },
                ),
          ),
        },
      ),
    );
  }
}
