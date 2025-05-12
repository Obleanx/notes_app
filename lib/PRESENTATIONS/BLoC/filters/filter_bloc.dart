import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class SelectDate extends FilterEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object> get props => [date];
}

class ClearSelectedDate extends FilterEvent {}

class SelectCategory extends FilterEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object> get props => [category];
}

// States
class FilterState extends Equatable {
  final DateTime? selectedDate;
  final String selectedCategory;

  const FilterState({this.selectedDate, this.selectedCategory = 'All'});

  FilterState copyWith({
    DateTime? selectedDate,
    bool clearDate = false,
    String? selectedCategory,
  }) {
    return FilterState(
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [selectedDate, selectedCategory];
}

// BLoC
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<SelectDate>(_onSelectDate);
    on<ClearSelectedDate>(_onClearSelectedDate);
    on<SelectCategory>(_onSelectCategory);
  }

  void _onSelectDate(SelectDate event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onClearSelectedDate(
    ClearSelectedDate event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(clearDate: true));
  }

  void _onSelectCategory(SelectCategory event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}
