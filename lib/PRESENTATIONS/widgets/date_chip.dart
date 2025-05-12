import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateChip({
    Key? key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('E').format(date);
    final dayNumber = date.day.toString();
    final isToday = _isToday(date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        width: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName.substring(0, 3),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dayNumber,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isToday)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
