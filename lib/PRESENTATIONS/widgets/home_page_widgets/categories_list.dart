import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/widgets/category_chip.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';

class CategoriesList extends StatelessWidget {
  final List<String> categories;

  const CategoriesList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, filterState) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = filterState.selectedCategory == category;

              return CategoryChip(
                title: category,
                isSelected: isSelected,
                onTap: () {
                  context.read<FilterBloc>().add(SelectCategory(category));
                },
              );
            },
          );
        },
      ),
    );
  }
}
