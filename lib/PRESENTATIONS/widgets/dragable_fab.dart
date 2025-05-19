import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraggableFab extends StatefulWidget {
  final Widget child;
  final double initialX;
  final double initialY;

  const DraggableFab({
    Key? key,
    required this.child,
    this.initialX = 0.85,
    this.initialY = 0.9,
  }) : super(key: key);

  @override
  State<DraggableFab> createState() => _DraggableFabState();
}

class _DraggableFabState extends State<DraggableFab> {
  late double _x;
  late double _y;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _x = widget.initialX;
    _y = widget.initialY;
    _loadPosition();
  }

  // Load saved position from SharedPreferences
  Future<void> _loadPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _x = prefs.getDouble('fab_position_x') ?? widget.initialX;
        _y = prefs.getDouble('fab_position_y') ?? widget.initialY;
        _isLoaded = true;
      });
    } catch (e) {
      // Fallback to default position if there's an error
      setState(() {
        _x = widget.initialX;
        _y = widget.initialY;
        _isLoaded = true;
      });
    }
  }

  // Save position to SharedPreferences
  Future<void> _savePosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fab_position_x', _x);
      await prefs.setDouble('fab_position_y', _y);
    } catch (e) {
      // Silent fail if we can't save
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is critical - we need to return a Stack to fix the gray screen issue after the splash screen
    // as Positioned can only be a direct child of Stack
    return Stack(
      fit: StackFit.expand,
      children: [if (_isLoaded) _buildDraggableFab(context)],
    );
  }

  Widget _buildDraggableFab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate actual pixel positions
    final double xPos = _x * screenWidth - 28; // Adjust for FAB size
    final double yPos = _y * screenHeight - 28; // Adjust for FAB size

    return Positioned(
      left: xPos,
      top: yPos,
      child: Draggable(
        feedback: widget.child,
        childWhenDragging: Container(), // Empty container when dragging
        onDragEnd: (details) {
          // Calculate new position relative to screen size
          double newX = (details.offset.dx + 28) / screenWidth;
          double newY = (details.offset.dy + 28) / screenHeight;

          // Ensure it stays within bounds
          newX = newX.clamp(0.1, 0.9);
          newY = newY.clamp(0.1, 0.9);

          setState(() {
            _x = newX;
            _y = newY;
          });

          // Save the new position for persistence
          _savePosition();
        },
        child: widget.child,
      ),
    );
  }
}
