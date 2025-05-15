import 'dart:ui';
import 'package:flutter/material.dart';

class CategoryBottomSheet extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Function() onSave;
  final Function()? onDelete;
  final Function(String) onAddCategory;

  const CategoryBottomSheet({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSave,
    this.onDelete,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late String _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on theme
    final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color searchBgColor =
        isDarkMode ? Colors.grey[800]! : Color.fromARGB(255, 244, 242, 242);
    final Color iconColor =
        isDarkMode ? Colors.grey[400]! : Color.fromARGB(255, 133, 131, 131);
    final Color selectedCircleColor = isDarkMode ? Colors.blue : Colors.black;
    final Color selectedCheckColor = isDarkMode ? Colors.white : Colors.white;

    // Filter categories based on search query
    final filteredCategories =
        _searchQuery.isEmpty
            ? widget.categories
            : widget.categories
                .where(
                  (category) => category.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

    // Take approximately 60% of the screen height
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Blur overlay for background effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0.5),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with title and close button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 30,
                        decoration: BoxDecoration(
                          color: searchBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, color: iconColor),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search field (formerly Add new category section)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: _buildSearchField(iconColor, textColor),
              ),

              // Category list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return ListTile(
                      title: Text(category, style: TextStyle(color: textColor)),
                      contentPadding: const EdgeInsets.symmetric(
                        //vertical: 2,
                      ),
                      dense: true, // Reduces the height of the ListTile
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      trailing:
                          _selectedCategory == category
                              ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: selectedCircleColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: selectedCheckColor,
                                  size: 14,
                                ),
                              )
                              : null,
                    );
                  },
                ),
              ),

              // Delete button (if applicable)
              if (widget.onDelete != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Delete Note',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDelete!();
                    },
                  ),
                ),

              // Save button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    widget.onCategorySelected(_selectedCategory);
                    Navigator.pop(context);
                    widget.onSave();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(Color iconColor, Color textColor) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: 'Add category',
        hintStyle: TextStyle(
          fontSize: 16,
          color: iconColor,
        ), // smaller hint text
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: iconColor,
              width: 1,
            ), // border color from theme
          ),
          child: Icon(Icons.add, size: 18, color: iconColor),
        ),

        border: InputBorder.none, // no border
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        filled: true,
        fillColor: Colors.transparent, // ensures no background color
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty && !widget.categories.contains(value)) {
          widget.onAddCategory(value);
          setState(() {
            _selectedCategory = value;
            _searchController.clear();
            _searchQuery = '';
          });
        }
      },
    );
  }
}
