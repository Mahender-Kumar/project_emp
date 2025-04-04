import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/blocs/theme/theme_bloc.dart';
import 'package:project_emp/extensions/string_extensions.dart';
import 'package:project_emp/presentation/widgets/trailing_icon_btn.dart'; 
import '../../../blocs/theme/theme_event.dart';

class ThemeBtn extends StatefulWidget {
  const ThemeBtn({super.key});

  @override
  State<ThemeBtn> createState() => _ThemeBtnState();
}

class _ThemeBtnState extends State<ThemeBtn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, theme) {
        return TrailingButton(
          label: theme.name.toTitleCase(),
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            context.push('/theme');
          },
        );
      },
    );
  }
}

class ThemeSelectorPage extends StatelessWidget {
  const ThemeSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Appearance"),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Done'),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, selectedTheme) {
          return ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 10),
              Divider(height: 0),
              _buildThemeOption(
                context,
                "Light Theme",
                ThemeMode.light,
                selectedTheme,
              ),
              Divider(height: 0),

              _buildThemeOption(
                context,
                "Dark Theme",
                ThemeMode.dark,
                selectedTheme,
              ),
              Divider(height: 0),

              _buildThemeOption(
                context,
                "System Default",
                ThemeMode.system,
                selectedTheme,
              ),
              Divider(height: 0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    ThemeMode value,
    ThemeMode selectedTheme,
  ) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      dense: true,
      title: Text(title),
      trailing: Radio<ThemeMode>(
        value: value,
        groupValue: selectedTheme,
        onChanged: (ThemeMode? newValue) {
          if (newValue != null) {
            context.read<ThemeBloc>().add(ChangeTheme(newValue));
          }
        },
      ),
    );
  }
}
