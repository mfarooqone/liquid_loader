import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'bubble_widget.dart';
import 'wave.dart';

/// CustomPainterWidget handles the custom painting of the liquid bottle,
/// including the waves, bubbles, and the bottle structure.
///
/// This widget is responsible for painting the bottle shape, liquid waves,
/// bubbles, cap, and any other graphical effects such as the glossy overlay.
class CustomPainterWidget extends CustomPainter {
  /// List of wave layers to be drawn.
  ///
  /// These wave layers are animated and create the appearance of moving liquid
  /// inside the bottle.
  final List<WaveLayer> waves;

  /// List of bubble widgets to be drawn.
  ///
  /// These bubbles are animated and appear to float inside the liquid.
  final List<BubbleWidget> bubbles;

  /// The current liquid level inside the bottle, ranging from 0.0 (empty) to 1.0 (full).
  ///
  /// This property controls how much of the bottle is filled with liquid.
  final double liquidLevel;

  /// Border color for the bottle.
  ///
  /// This color is used to draw the outer boundary of the bottle.
  final Color borderColor;

  /// Cap color for the bottle.
  ///
  /// This color is used to draw the cap on top of the bottle.
  final Color capColor;

  /// Constructor to initialize the required properties.
  ///
  /// [waves] List of wave layers to be drawn inside the bottle.
  /// [bubbles] List of bubble widgets to be drawn inside the bottle.
  /// [liquidLevel] The level of liquid in the bottle (0.0 to 1.0).
  /// [borderColor] The color for the border of the bottle.
  /// [capColor] The color for the cap of the bottle.
  CustomPainterWidget({
    super.repaint,
    required this.waves,
    required this.bubbles,
    required this.liquidLevel,
    required this.borderColor,
    required this.capColor,
  });

  /// Overridden paint method to perform custom painting.
  ///
  /// This method is called to draw the bottle, waves, bubbles, cap, and glossy overlay.
  /// It uses the provided [canvas] and [size] to render the visual elements.
  @override
  void paint(Canvas canvas, Size size) {
    {
      // Paint the border of the bottle
      final paint = Paint();
      paint.color = borderColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      paintEmptyBottle(canvas, size, paint); // Draw the empty bottle shape
    }
    {
      // Paint the bottle's transparent mask (used for liquid animation)
      final paint = Paint();
      paint.color = Colors.white;
      paint.style = PaintingStyle.fill;
      final rect = Rect.fromLTRB(0, 0, size.width, size.height);
      canvas.saveLayer(rect, paint); // Save the layer for better blending
      paintBottleMask(
        canvas,
        size,
        paint,
      ); // Draw the bottle's mask for liquid fill
    }
    {
      // Paint the liquid waves
      final paint = Paint();
      paint.blendMode = BlendMode.srcIn;
      paint.style = PaintingStyle.fill;
      paintWaves(canvas, size, paint); // Draw the waves inside the bottle
    }
    {
      // Paint the bubbles on top of the liquid waves
      final paint = Paint();
      paint.blendMode = BlendMode.srcATop;
      paint.style = PaintingStyle.fill;
      paintBubbles(canvas, size, paint); // Draw the bubbles inside the bottle
    }
    {
      // Paint the glossy overlay on top of the liquid (adds a shiny effect)
      final paint = Paint();
      paint.blendMode = BlendMode.srcATop;
      paint.style = PaintingStyle.fill;
      paintGlossyOverlay(
        canvas,
        size,
        paint,
      ); // Draw the glossy effect on the liquid
    }
    canvas.restore(); // Restore the canvas state after the mask
    {
      // Paint the cap of the bottle
      final paint = Paint();
      paint.blendMode = BlendMode.srcATop;
      paint.style = PaintingStyle.fill;
      paint.color = capColor;
      paintCap(canvas, size, paint); // Draw the bottle cap
    }
  }

  /// Function to paint the empty bottle's outline.
  ///
  /// This function paints the outline of the bottle without liquid or cap.
  void paintEmptyBottle(Canvas canvas, Size size, Paint paint) {
    final neckTop = size.width * 0.1;
    final neckBottom = size.height;
    const neckRingOuter = 0.0;
    final neckRingOuterR = size.width - neckRingOuter;
    final neckRingInner = size.width * 0.1;
    final neckRingInnerR = size.width - neckRingInner;
    final path = Path();
    path.moveTo(neckRingOuter, neckTop);
    path.lineTo(neckRingInner, neckTop);
    path.lineTo(neckRingInner, neckBottom);
    path.lineTo(neckRingInnerR, neckBottom);
    path.lineTo(neckRingInnerR, neckTop);
    path.lineTo(neckRingOuterR, neckTop);
    canvas.drawPath(path, paint); // Draw the path of the bottle
  }

  /// Function to paint the mask for liquid fill (bottle shape without cap).
  ///
  /// This mask ensures that only the liquid area is visible inside the bottle.
  void paintBottleMask(Canvas canvas, Size size, Paint paint) {
    final neckRingInner = size.width * 0.1;
    final neckRingInnerR = size.width - neckRingInner;
    canvas.drawRect(
      Rect.fromLTRB(neckRingInner + 5, 0, neckRingInnerR - 5, size.height - 5),
      paint, // Draw the mask rectangle for liquid fill
    );
  }

  /// Function to paint the liquid waves inside the bottle.
  ///
  /// This method paints the animated waves of liquid inside the bottle, based
  /// on the current liquid level and wave properties.
  void paintWaves(Canvas canvas, Size size, Paint paint) {
    for (var wave in waves) {
      paint.color = wave.color; // Set the wave color
      final transform =
          Matrix4.identity(); // Create a matrix for transformations
      final desiredW = 15 * size.width;
      final desiredH = 0.1 * size.height;
      final translateRange = desiredW - size.width;
      final scaleX =
          desiredW / wave.svgData.getBounds().width; // Scale the wave width
      final scaleY =
          desiredH / wave.svgData.getBounds().height; // Scale the wave height
      final translateX = -wave.offset * translateRange;
      final liquidRange = size.height + desiredH;
      final translateY =
          (1.0 - liquidLevel) * liquidRange -
          desiredH; // Translate the wave based on liquid level
      transform.translate(translateX, translateY); // Apply translation
      transform.scale(scaleX, scaleY); // Apply scaling
      canvas.drawPath(
        wave.svgData.transform(transform.storage),
        paint, // Draw the transformed wave
      );
      // Draw the gap if necessary (to fill in the space below the wave)
      if (waves.indexOf(wave) != waves.length - 1) {
        continue;
      }
      final gap = size.height - desiredH - translateY;
      if (gap > 0) {
        canvas.drawRect(
          Rect.fromLTRB(0, desiredH + translateY, size.width, size.height),
          paint, // Fill the remaining space below the wave
        );
      }
    }
  }

  /// Function to paint the bubbles inside the bottle.
  ///
  /// This method paints the bubbles inside the bottle based on their current
  /// position, size, and opacity.
  void paintBubbles(Canvas canvas, Size size, Paint paint) {
    for (var bubble in bubbles) {
      paint.color = bubble.color; // Set the bubble color
      final offset = Offset(
        bubble.x * size.width,
        (bubble.y + 1.0 - liquidLevel) *
            size.height, // Adjust the Y position based on liquid level
      );
      final radius =
          bubble.size *
          math.min(
            size.width,
            size.height,
          ); // Calculate the radius based on the size
      canvas.drawCircle(offset, radius, paint); // Draw the bubble
    }
  }

  /// Function to paint the glossy overlay effect on the liquid.
  ///
  /// This function adds a glossy effect on top of the liquid to simulate a shiny
  /// surface, improving the visual appeal.
  void paintGlossyOverlay(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withAlpha(20); // Light glossy overlay
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width * 0.5, size.height),
      paint, // Draw the first part of the glossy effect
    );
    paint.color = Colors.white.withAlpha(80); // Stronger glossy effect
    canvas.drawRect(
      Rect.fromLTRB(size.width * 0.9, 0, size.width * 0.95, size.height),
      paint, // Draw the second part of the glossy effect
    );
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        Colors.white.withAlpha(180), // Strong gloss
        Colors.white.withAlpha(0), // Transparent gloss
      ],
    ).createShader(rect);
    paint.color = Colors.white;
    paint.shader = gradient; // Apply the gradient for glossy effect
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      paint, // Apply the final glossy overlay
    );
  }

  /// Function to paint the cap on top of the bottle.
  ///
  /// This method paints the cap of the bottle on top of the neck.
  void paintCap(Canvas canvas, Size size, Paint paint) {
    const capTop = 0.0;
    final capBottom = size.width * 0.2;
    final capMid = (capBottom - capTop) / 2;
    final capL = size.width * 0.08 + 5;
    final capR = size.width - capL;
    final neckRingInner = size.width * 0.1 + 5;
    final neckRingInnerR = size.width - neckRingInner;
    final path = Path();
    path.moveTo(capL, capTop);
    path.lineTo(neckRingInner, capMid);
    path.lineTo(neckRingInner, capBottom);
    path.lineTo(neckRingInnerR, capBottom);
    path.lineTo(neckRingInnerR, capMid);
    path.lineTo(capR, capTop);
    path.close(); // Close the path to complete the cap shape
    canvas.drawPath(path, paint); // Draw the cap path
  }

  /// Overridden method to determine if the custom painter should repaint.
  ///
  /// Returns true to always trigger a repaint for this custom painter.
  @override
  bool shouldRepaint(CustomPainterWidget oldDelegate) => true; // Always repaint
}
