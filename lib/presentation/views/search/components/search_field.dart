import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/views/search/search_cubit.dart'; 

class SearchField extends StatelessWidget {
  SearchField({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, String>(
      builder: (context, searchQuery) {
        return TextFormField(
          controller: _controller,
          onChanged: (value) => context.read<SearchCubit>().updateSearch(value),
          decoration: InputDecoration(
            hintText: 'Search by title...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      iconSize: 16,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchCubit>().clearSearch();
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(btnRadius),
            ),
          ),
        );
      },
    );
  }
}
