import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _x = widget.initialX;
    _y = widget.initialY;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: _x * screenWidth - 28, // Adjust for FAB size
      top: _y * screenHeight - 28, // Adjust for FAB size
      child: Draggable(
        feedback: widget.child,
        childWhenDragging: Container(), // Empty container when dragging
        onDragEnd: (details) {
          // Update position based on drag
          setState(() {
            _x = (details.offset.dx + 28) / screenWidth; // Adjust back
            _y = (details.offset.dy + 28) / screenHeight; // Adjust back

            // Ensure it stays within bounds
            _x = _x.clamp(0.1, 0.9);
            _y = _y.clamp(0.1, 0.9);
          });
        },
        child: widget.child,
      ),
    );
  }
}
