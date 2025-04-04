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
  ];
  @override
  Widget build(BuildContext context) {
    int index = navList.indexWhere(
      (e) => e['path'] != '/' && currentPath.startsWith(e['path']),
    );
    int selectedIndex = index == -1 ? 0 : index;

    return AdaptiveLayout(
      primaryNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.mediumAndUp: SlotLayout.from(
            key: const Key('Primary Navigation Medium'),
            builder:
                (_) => AdaptiveScaffold.standardNavigationRail(
                  extended: false,
                  width: 88,

                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: Icon(Icons.person_2),
                  ),

                  destinations: [
                    ...navList.map(
                      (e) => NavigationRailDestination(
                        icon: e['icon'],
                        selectedIcon: e['selectedIcon'],
                        label: Text(
                          e['label'],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) async {
                    GoRouter.of(context).go(navList[index]['path'] ?? '/');
                  },
                  padding: const EdgeInsets.all(0),
                ),
          ),
        },
      ),
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.smallAndUp: SlotLayout.from(
            key: const Key('Body All'),
            builder: (_) {
              final isBigScreen = MediaQuery.of(context).size.width >= 600;
              return Container(
                decoration: BoxDecoration(
                  border:
                      isBigScreen
                          ? Border(
                            left: BorderSide(
                              width: 1.0,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          )
                          : Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: body,
              );
            },
          ),
        },
      ),

      bottomNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayout.from(
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
