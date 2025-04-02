
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart'; 

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(-150, 0),
      crossAxisUnconstrained: false,
      menuChildren: [
        SizedBox(
          width: 200,
          child: MenuItemButton(
            trailingIcon: Icon(
              Icons.settings_outlined,
              size: menuAnchorIconSize,
            ),
            onPressed: () {
              context.push('/settings');
            },
            child: Text('Settings', style: TextStyle()),
          ),
        ),
        SizedBox(
          width: 200,
          child: MenuItemButton(
            trailingIcon: Icon(
              Icons.history_outlined,
              size: menuAnchorIconSize,
            ),
            onPressed: () {
              context.push('/history');
            },
            child: Text('History', style: TextStyle()),
          ),
        ),
        SizedBox(
          width: 200,
          child: MenuItemButton(
            trailingIcon: Icon(
              Icons.delete_outline_rounded,
              size: menuAnchorIconSize,
            ),
            child: Text('Trash'),
            onPressed: () {
              context.push('/trash');
            },
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.more_horiz_outlined),
          onPressed: () {
            controller.open();
          },
        );
      },
    );
  }
}
