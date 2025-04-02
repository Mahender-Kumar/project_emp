import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/views/settings/components/change_display_name.dart';
import 'package:project_emp/presentation/views/settings/components/change_pasword.dart';
import 'package:project_emp/presentation/views/settings/components/delete_account.dart';
import 'package:project_emp/presentation/views/settings/components/trailing_icon_btn.dart';
import 'package:project_emp/presentation/views/theme/theme_page.dart';
import 'package:project_emp/presentation/widgets/my_divider.dart'; 

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            centerTitle: true,
            leading: IconButton(
              iconSize: defaultIconSize,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                context.pop();
              },
            ),
            title: Text("Settings"),
            pinned: true, // Keeps it fixed at the top
            floating: false, // Prevents it from appearing mid-scroll
            snap: false, // No snapping behavior
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ProfileHeader(),
                ListTile(title: const Text('Preferences')),
                ListTile(
                  dense: true,
                  title: const Text('Display Name'),
                  subtitle: const Text(
                    'Set a name to be displayed on your profile',
                  ),
                  trailing: TrailingButton(
                    label: 'Display Name',
                    onPressed: () {
                      showDisplayNameChangeDialog(context);
                    },
                  ),
                  onTap: () {
                    showDisplayNameChangeDialog(context);
                  },
                ),
                MyDivider(),
                ListTile(
                  dense: true,
                  title: const Text('Password'),
                  subtitle: const Text(
                    'Set a permanent password to login to your account',
                  ),
                  trailing: TrailingButton(
                    label: 'Change Password',
                    onPressed: () {
                      showChangePasswordDialog(context);
                    },
                  ),
                  onTap: () {
                    // Navigate to Change Password screen
                    showChangePasswordDialog(context);
                  },
                ),
                MyDivider(),
                ListTile(
                  dense: true,
                  title: const Text('Appearance'),
                  subtitle: const Text(
                    'Customize the look and feel of the app',
                  ),
                  trailing: ThemeBtn(),
                ),
                MyDivider(),
                ListTile(
                  dense: true,
                  title: Text(
                    'Delete my Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text(
                    'Permanently delete your account and all data',
                  ),
                  trailing: TrailingButton(
                    label: 'Delete My Account',
                    borderColor: Theme.of(context).colorScheme.error,
                    labelColor: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      // Navigate to Change Password screen
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        useRootNavigator: true,
                        isDismissible: true,
                        enableDrag: true,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DeleteAccountPage(),
                          );
                        },
                      );
                    },
                  ),
                ),
                MyDivider(),

                // _buildProfileMenuButton(
                //   text: 'theme',
                //   icon: Icons.color_lens_outlined,
                //   trailing: BlocBuilder<ThemeBloc, bool>(
                //     builder: (context, state) {
                //       return Switch(
                //         trackOutlineColor: WidgetStateProperty.all(
                //           Colors.grey,
                //         ), // Border color
                //         trackOutlineWidth: WidgetStateProperty.all(2),
                //         value: state,
                //         onChanged: (bool val) {
                //           context.read<ThemeBloc>().add(ChangeTheme());
                //         },
                //       );
                //     },
                //   ),
                // ),

                // _buildProfileMenuButton(
                //   text: 'Log Out',
                //   trailing: Icon(
                //     Icons.arrow_forward_ios,
                //     color: ColorConst.textColor,
                //   ),

                //   icon: Icons.logout_outlined,
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder:
                //           (context) => AlertDialog(
                //             title: const Text('Logout'),
                //             content: const Text(
                //               'Are you sure you want to log out?',
                //             ),
                //             actions: [
                //               TextButton(
                //                 onPressed: () => Navigator.pop(context),
                //                 child: const Text('Cancel'),
                //               ),
                //               TextButton(
                //                 onPressed: () {
                //                   // Perform logout operation
                //                   Navigator.pop(context);
                //                 },
                //                 child: const Text(
                //                   'Logout',
                //                   style: TextStyle(color: Colors.red),
                //                 ),
                //               ),
                //             ],
                //           ),
                //     );
                //     AuthService().logout();
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (_) => const LoginScreen(),
                //     //     fullscreenDialog: true,
                //     //   ),
                //     // );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showChangePasswordDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          content: Padding(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(
                    context,
                  ).viewInsets.bottom, // Adjust for keyboard
            ),
            child: ChangePasswordPage(),
          ),
        );
      },
    );
  }

  Future<dynamic> showDisplayNameChangeDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          content: Padding(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(
                    context,
                  ).viewInsets.bottom, // Adjust for keyboard
            ),
            child: ChangeDisplayNamePage(),
          ),
        );
      },
    );
  }
}



