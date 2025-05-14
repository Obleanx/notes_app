import 'package:flutter/material.dart';

class SortOptionsRow extends StatelessWidget {
  final Function(SortOption) onSortSelected;
  final SortOption currentSort;

  const SortOptionsRow({
    super.key,
    required this.onSortSelected,
    required this.currentSort,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSortButton(context, SortOption.dateCreatedNewest, 'Newest'),
          _buildSortButton(context, SortOption.dateCreatedOldest, 'Oldest'),
          _buildSortButton(context, SortOption.alphabetical, 'A-Z'),
          _buildSortButton(context, SortOption.reverseAlphabetical, 'Z-A'),
        ],
      ),
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    SortOption option,
    String label,
  ) {
    final isSelected = currentSort == option;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => onSortSelected(option),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Icon(
                  option == SortOption.dateCreatedNewest ||
                          option == SortOption.reverseAlphabetical
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 14,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SortOption {
  dateCreatedNewest,
  dateCreatedOldest,
  alphabetical,
  reverseAlphabetical,
}
