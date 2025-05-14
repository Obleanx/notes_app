import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/PRESENTATIONS/widgets/date_chip.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/filters/filter_bloc.dart';

class DateList extends StatelessWidget {
  final List<DateTime> dates;

  const DateList({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, filterState) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected =
                  filterState.selectedDate != null &&
                  filterState.selectedDate!.year == date.year &&
                  filterState.selectedDate!.month == date.month &&
                  filterState.selectedDate!.day == date.day;

              return DateChip(
                date: date,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    context.read<FilterBloc>().add(ClearSelectedDate());
                  } else {
                    context.read<FilterBloc>().add(SelectDate(date));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
