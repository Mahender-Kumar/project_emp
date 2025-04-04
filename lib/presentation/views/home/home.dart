import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/presentation/views/home/components/home_popup_menu.dart';
import 'package:project_emp/presentation/views/home/components/leading_name_icon.dart';
import 'package:project_emp/presentation/views/home/components/employee_list.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,

            title: ListTile(
              dense: true,
              leading: LeadingNameIcon(),
              title: Text(_authService.currentUser?.displayName ?? 'User'),
              subtitle: Text(_authService.currentUser?.email ?? ''),
              trailing: HomeMenu(),

              onTap: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  showDragHandle: true,
                  useSafeArea: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Accounts'),
                          ListTile(
                            title: Text(_authService.currentUser?.email ?? ''),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_horiz),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              dense: true,
                              leading: LeadingNameIcon(),
                              title: Text(
                                _authService.currentUser?.displayName ?? 'User',
                              ),
                              subtitle: Text(
                                _authService.currentUser?.email ?? '',
                              ),
                              trailing: Icon(
                                Icons.done,
                                size: menuAnchorIconSize,
                              ),
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  titleAlignment: ListTileTitleAlignment.center,
                                  leading: Icon(
                                    Icons.add,
                                    size: menuAnchorIconSize,
                                  ),
                                  title: Text("Add an Account"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: menuAnchorIconSize,
                                  ),
                                ),
                                Divider(height: 0, thickness: 1),
                                ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.logout_outlined,
                                    size: menuAnchorIconSize,
                                  ),
                                  onTap: () {
                                    _authService.logout();
                                  },

                                  title: Text("Log Out"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            pinned: true,
            floating: false,
            snap: false,
          ),
          ExployeeListview(),
        ],  
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
