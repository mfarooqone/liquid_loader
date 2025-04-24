import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:liquid_loader/src/rectangle_painter.dart';
import 'package:liquid_loader/src/spherical_painter.dart';
import 'package:liquid_loader/src/triangular_painter.dart';

import 'src/border_widget.dart';

/// Enum representing the shape of the loader used in the LiquidLoader widget.
///
/// The available shapes are:
/// - [Shape.triangle]: A triangular-shaped.
/// - [Shape.circle]: A circular-shaped.
/// - [Shape.rectangle]: A rectangular-shaped.
/// The available shapes are as follows:
enum Shape {
  /// A triangular-shaped.
  triangle,

  /// A circular-shaped.
  circle,

  /// A rectangular-shaped.
  rectangle,
}

/// A customizable liquid loader widget, representing a liquid bottle with animation and text.
class LiquidLoader extends StatefulWidget {
  /// The color of the liquid in the bottle.
  final Color liquidColor;

  /// The color of the border around the bottle.
  final Color borderColor;

  /// The color of the cap.
  final Color capColor;

  /// The current level of liquid inside the bottle, ranging from 0.0 (empty) to 1.0 (full).
  final double liquidLevel;

  /// The text to display inside the bottle.
  final String text;

  /// The text style to be applied to the text inside the bottle.
  final TextStyle textStyle;

  /// The height of the bottle.
  final double height;

  /// The width of the bottle.
  final double width;

  /// The shape of the bottle, which can be triangle, circle, or rectangle.
  final Shape shape;

  /// Whether to hide the cap of the bottle.
  final bool hideCap;

  /// Constructor for the LiquidLoader widget with optional parameters.
  const LiquidLoader({
    super.key,
    this.liquidColor = Colors.blue, // Default liquid color is blue
    this.borderColor = Colors.blue, // Default border color is blue
    this.capColor = Colors.blueGrey, // Default cap color is blueGrey
    this.liquidLevel = 0.5, // Default liquid level is 50%
    this.text = "", // Default text is an empty string
    this.textStyle = const TextStyle(), // Default text style
    this.height = 200, // Default height of the bottle
    this.width = 100, // Default width of the bottle
    this.shape = Shape.circle, // Default shape is circle
    this.hideCap = false, // Default is not to hide the cap
  });

  @override
  LiquidLoaderState createState() => LiquidLoaderState(); // Creates the state for LiquidLoader
}

/// State for the [LiquidLoader] widget, responsible for managing animations and rendering.
class LiquidLoaderState extends State<LiquidLoader>
    with TickerProviderStateMixin, BorderWidget {
  /// Animation controller to control the wave animation.
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the liquid layers and setup the initial state for animation
    initLayers(widget.liquidColor, this);

    // Setup the animation controller with a 1-second duration to create the animation loop
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ), // Duration of 1 second for each animation cycle
    )..repeat(); // Repeat the animation to simulate continuous wave movement
  }

  /// Returns the appropriate painter based on the selected shape (triangle, circle, or rectangle).
  CustomPainter getShapePainter() {
    switch (widget.shape) {
      case Shape.triangle:
        // Return the painter for a triangular-shaped bottle
        return TriangularBottleStatePainter(
          waves: waves, // Animation for the waves inside the bottle
          bubbles: bubbles, // Bubbles inside the liquid
          liquidLevel: widget.liquidLevel, // The current liquid level
          borderColor: widget.borderColor, // Border color around the bottle
          capColor:
              widget.hideCap
                  ? Colors.transparent
                  : widget.capColor, // Conditionally hide or show the cap
        );
      case Shape.circle:
        // Return the painter for a circular-shaped bottle
        return SphericalBottlePainter(
          waves: waves,
          bubbles: bubbles,
          liquidLevel: widget.liquidLevel,
          borderColor: widget.borderColor,
          capColor: widget.capColor,
        );
      case Shape.rectangle:
        // Return the painter for a rectangular-shaped bottle
        return CustomPainterWidget(
          waves: waves,
          bubbles: bubbles,
          liquidLevel: widget.liquidLevel,
          borderColor: widget.borderColor,
          capColor: widget.capColor,
        );
    }
  }

  @override
  void dispose() {
    // Clean up resources when the widget is disposed of
    disposeLayers(); // Dispose the layers used for painting
    _animationController.dispose(); // Dispose the animation controller
    super.dispose(); // Call the parent dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom painting for the bottle shape with animated waves
        SizedBox(
          height: widget.height, // Set the height of the bottle
          width: widget.width, // Set the width of the bottle
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation:
                  _animationController, // Connect the animation controller
              builder: (context, child) {
                return CustomPaint(
                  painter:
                      getShapePainter(), // Use the appropriate painter for the selected shape
                );
              },
            ),
          ),
        ),

        // Display the text inside the bottle, centered in the middle
        SizedBox(
          height: widget.height, // Set the height of the bottle
          width: widget.width, // Set the width of the bottle
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20, // Add horizontal padding for text
            ),
            child: Center(
              child: AutoSizeText(
                widget.text.isNotEmpty
                    ? widget
                        .text // Display the provided text if available
                    : '', // If no text is provided, display an empty string
                style: widget.textStyle.copyWith(
                  fontSize: 20, // Set the font size for the text
                ),
                overflow:
                    TextOverflow.ellipsis, // Prevent text from overflowing
                maxLines: 1, // Allow only one line of text
              ),
            ),
          ),
        ),
      ],
    );
  }
}
