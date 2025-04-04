import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/blocs/change_name/change_name_bloc.dart';
import 'package:project_emp/blocs/change_name/change_name_event.dart';
import 'package:project_emp/blocs/change_name/change_name_state.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';

class ChangeDisplayNamePage extends StatefulWidget {
  const ChangeDisplayNamePage({super.key});

  @override
  ChangeDisplayNamePageState createState() => ChangeDisplayNamePageState();
}

class ChangeDisplayNamePageState extends State<ChangeDisplayNamePage> {
  final TextEditingController _controller = TextEditingController();

  void _saveDisplayName() {
    context.read<DisplayNameBloc>().add(
      UpdateDisplayNameEvent(_controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DisplayNameBloc, DisplayNameState>(
      listener: (context, state) {
        if (state is DisplayNameUpdated) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Display name updated successfully!")),
          );
        } else if (state is DisplayNameError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        } else if (state is DisplayNameLoaded) {
          _controller.text = state.displayName;
        }
      },
      builder: (context, state) {
        return Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const Icon(Icons.person, size: 48),
              const ListTile(
                title: Center(child: Text("Change Display Name")),
                subtitle: Text("Set a name to be displayed on your profile"),
              ),
              if (state is DisplayNameLoaded || state is DisplayNameUpdated)
                Text("Current Name: ${_controller.text}"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: "Enter your name",
                ),
              ),
              const SizedBox(height: 16),
              ExpandedBtn(
                onPressed: _saveDisplayName,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(btnRadius),
                  ),
                ),
                child:
                    (state is DisplayNameUpdating)
                        ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                          ),
                        )
                        : const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }
}
