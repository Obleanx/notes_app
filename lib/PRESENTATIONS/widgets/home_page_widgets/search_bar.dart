import 'package:flutter/material.dart';

class HomeScreenSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HomeScreenSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors
                      .black // Black text in dark mode
                  : Colors.black, // Black text in light mode
        ),
        decoration: InputDecoration(
          hintText: 'Search for notes',
          hintStyle: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors
                        .black // Black hint in dark mode
                    : Colors.grey.shade500, // Darker grey hint in light mode
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ), // Icon stays grey
          filled: true,
          fillColor: Colors.grey.shade100, // Background stays light grey
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

Color getTextColorBasedOnTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}
