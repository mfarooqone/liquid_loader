import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_loader/src/rectangle_painter.dart';

/// TriangularBottleStatePainter is a CustomPainter that draws a triangular-shaped bottle
/// with liquid waves, bubbles, and a cap. It also includes a glossy overlay effect.
///
/// This class is responsible for painting a triangular bottle shape with animated waves
/// and bubbles inside. It also includes a glossy overlay effect and paints the cap on top.
class TriangularBottleStatePainter extends CustomPainterWidget {
  /// Constant breakpoint for when the bottle neck is cut off based on aspect ratio.
  ///
  /// This value determines whether the bottle is considered to have a "portrait" shape
  /// based on its aspect ratio. If the height is greater than this breakpoint,
  /// the bottle is considered a portrait bottle, otherwise, it is treated as a landscape bottle.
  static const breakPoint = 1.2;

  /// Constructor to initialize the painter with wave and bubble data.
  ///
  /// [waves] List of wave layers to be drawn inside the bottle.
  /// [bubbles] List of bubble widgets to be drawn inside the bottle.
  /// [liquidLevel] The level of liquid inside the bottle, from 0.0 (empty) to 1.0 (full).
  /// [borderColor] The color of the bottle's border.
  /// [capColor] The color of the bottle's cap.
  TriangularBottleStatePainter({
    super.repaint,
    required super.waves,
    required super.bubbles,
    required super.liquidLevel,
    required super.borderColor,
    required super.capColor,
  });

  /// Function to paint the empty bottle outline.
  ///
  /// This method draws the outline of the triangular bottle. It can either draw a smooth
  /// cornered triangular bottle shape or a regular triangular shape based on the flag.
  ///
  /// [canvas] The canvas where the painting will be drawn.
  /// [size] The size of the bottle (width and height).
  /// [paint] The paint object used for drawing the bottle outline.
  @override
  void paintEmptyBottle(Canvas canvas, Size size, Paint paint) {
    const smoothCorner =
        true; // Flag for whether to smooth the corners of the bottle
    final r = math.min(
      size.width,
      size.height,
    ); // Get the smaller dimension for radius

    // Neck and body dimensions for the bottle
    final neckTop = size.width * 0.1;
    final neckBottom = size.height - r + 3;
    final neckRingOuter = size.width * 0.28;
    final neckRingOuterR = size.width - neckRingOuter;
    final neckRingInner = size.width * 0.35;
    final neckRingInnerR = size.width - neckRingInner;
    final bodyBottom = size.height;
    const bodyL = 0.0;
    final bodyR = size.width;

    final path = Path();
    path.moveTo(neckRingOuter, neckTop);
    path.lineTo(neckRingInner, neckTop);
    path.lineTo(neckRingInner, neckBottom);

    if (smoothCorner) {
      // Smooth the corners of the bottle by adding a conic curve
      final bodyLAX = (neckRingInner - bodyL) * 0.1 + bodyL;
      final bodyLAY = (bodyBottom - neckBottom) * 0.9 + neckBottom;
      final bodyLBX = (bodyR - bodyL) * 0.1 + bodyL;
      final bodyLBY = bodyBottom;
      final bodyRAX = size.width - bodyLAX;
      final bodyRAY = bodyLAY;
      final bodyRBX = size.width - bodyLBX;
      final bodyRBY = bodyLBY;
      path.lineTo(bodyLAX, bodyLAY);
      path.conicTo(bodyL, bodyBottom, bodyLBX, bodyLBY, 1);
      path.lineTo(bodyRBX, bodyRBY);
      path.conicTo(bodyR, bodyBottom, bodyRAX, bodyRAY, 1);
    }
    path.lineTo(neckRingInnerR, neckBottom);
    path.lineTo(neckRingInnerR, neckTop);
    path.lineTo(neckRingOuterR, neckTop);
    canvas.drawPath(path, paint); // Draw the path of the bottle shape
  }

  /// Function to paint the mask that holds the liquid (used for liquid fill).
  ///
  /// This method creates a mask for the liquid fill area inside the bottle. It draws a
  /// triangle-shaped mask that holds the liquid for the animated effect.
  ///
  /// [canvas] The canvas where the mask will be drawn.
  /// [size] The size of the bottle (width and height).
  /// [paint] The paint object used for drawing the mask.
  @override
  void paintBottleMask(Canvas canvas, Size size, Paint paint) {
    const smoothCorner = true; // Flag for smoothing the corner
    final r = math.min(
      size.width,
      size.height,
    ); // Get the smaller dimension for radius

    // Neck and body dimensions for the mask
    final neckTop = size.width * 0.1;
    final neckBottom = size.height - r + 3;
    final neckRingInner = size.width * 0.35 + 5;
    final neckRingInnerR = size.width - neckRingInner;
    final bodyBottom = size.height - 5;
    const bodyL = 5.0;
    final bodyR = size.width - 5;

    final path = Path();
    path.moveTo(neckRingInner, neckTop);
    path.lineTo(neckRingInner, neckBottom);

    if (smoothCorner) {
      // Smooth the corners of the bottle mask
      final bodyLAX = (neckRingInner - bodyL) * 0.1 + bodyL;
      final bodyLAY = (bodyBottom - neckBottom) * 0.9 + neckBottom;
      final bodyLBX = (bodyR - bodyL) * 0.1 + bodyL;
      final bodyLBY = bodyBottom;
      final bodyRAX = size.width - bodyLAX;
      final bodyRAY = bodyLAY;
      final bodyRBX = size.width - bodyLBX;
      final bodyRBY = bodyLBY;
      path.lineTo(bodyLAX, bodyLAY);
      path.conicTo(bodyL, bodyBottom, bodyLBX, bodyLBY, 1);
      path.lineTo(bodyRBX, bodyRBY);
      path.conicTo(bodyR, bodyBottom, bodyRAX, bodyRAY, 1);
    }
    path.lineTo(neckRingInnerR, neckBottom);
    path.lineTo(neckRingInnerR, neckTop);
    path.close();
    canvas.drawPath(path, paint); // Draw the mask path
  }

  /// Function to paint the glossy overlay effect on the liquid.
  ///
  /// This function adds a glossy effect on top of the liquid to simulate a shiny
  /// surface, improving the visual appeal.
  ///
  /// [canvas] The canvas where the glossy overlay will be drawn.
  /// [size] The size of the bottle (width and height).
  /// [paint] The paint object used for the glossy effect.
  @override
  void paintGlossyOverlay(Canvas canvas, Size size, Paint paint) {
    final r = math.min(
      size.width,
      size.height,
    ); // Get the smaller dimension for radius
    final rect =
        Offset(0, size.height - r) &
        size; // Define the rectangle for the gradient
    final gradient = RadialGradient(
      center: Alignment.center, // Create a radial gradient centered at the top
      colors: [
        Colors.white.withAlpha(120), // Lighter gloss
        Colors.white.withAlpha(0), // Transparent gloss
      ],
    ).createShader(rect); // Create the shader from the gradient
    paint.color = Colors.white;
    paint.shader = gradient;

    // Draw the glossy effect rectangle
    canvas.drawRect(
      Rect.fromLTRB(5, size.height - r + 3, size.width - 5, size.height - 5),
      paint,
    );
  }

  /// Function to paint the cap on top of the bottle.
  ///
  /// This method draws the cap on top of the neck of the bottle, but it only
  /// draws the cap for bottles with a landscape orientation.
  ///
  /// [canvas] The canvas where the cap will be drawn.
  /// [size] The size of the bottle (width and height).
  /// [paint] The paint object used for the cap.
  @override
  void paintCap(Canvas canvas, Size size, Paint paint) {
    if (size.height / size.width < breakPoint) {
      return; // Skip if the bottle is 'portrait'
    }

    // Cap dimensions and path for the bottle cap
    const capTop = 0.0;
    final capBottom = size.width * 0.2;
    final capMid = (capBottom - capTop) / 2;
    final capL = size.width * 0.33 + 5;
    final capR = size.width - capL;
    final neckRingInner = size.width * 0.35 + 5;
    final neckRingInnerR = size.width - neckRingInner;

    final path = Path();
    path.moveTo(capL, capTop);
    path.lineTo(neckRingInner, capMid);
    path.lineTo(neckRingInner, capBottom);
    path.lineTo(neckRingInnerR, capBottom);
    path.lineTo(neckRingInnerR, capMid);
    path.lineTo(capR, capTop);
    path.close();
    canvas.drawPath(path, paint); // Draw the bottle cap
  }
}
