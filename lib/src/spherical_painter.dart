import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_loader/src/rectangle_painter.dart';

// SphericalBottlePainter is a CustomPainter that draws a spherical-shaped bottle
// with waves, bubbles, and a cap. It also includes a glossy overlay effect.
class SphericalBottlePainter extends CustomPainterWidget {
  // Constant breakpoint for when the bottle neck is cut off based on aspect ratio
  static const breakPoint = 1.2;

  // Constructor to initialize the painter with wave and bubble data
  SphericalBottlePainter({
    super.repaint,
    required super.waves,
    required super.bubbles,
    required super.liquidLevel,
    required super.borderColor,
    required super.capColor,
  });

  // Function to paint the empty bottle outline
  @override
  void paintEmptyBottle(Canvas canvas, Size size, Paint paint) {
    final r = math.min(
      size.width,
      size.height,
    ); // Get the smaller dimension for radius

    // If the aspect ratio suggests a more 'portrait' bottle (height > width), paint a circle
    if (size.height / size.width < breakPoint) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height - r / 2),
        r / 2,
        paint,
      );
      return; // Exit if it's a circle
    }

    // Paint the neck of the bottle for wider bottles
    final neckTop = size.width * 0.1;
    final neckBottom = size.height - r + 3;
    final neckRingOuter = size.width * 0.28;
    final neckRingOuterR = size.width - neckRingOuter;
    final neckRingInner = size.width * 0.35;
    final neckRingInnerR = size.width - neckRingInner;

    final path = Path();
    path.moveTo(neckRingOuter, neckTop);
    path.lineTo(neckRingInner, neckTop);
    path.lineTo(neckRingInner, neckBottom);
    path.moveTo(neckRingInnerR, neckBottom);
    path.lineTo(neckRingInnerR, neckTop);
    path.lineTo(neckRingOuterR, neckTop);
    canvas.drawPath(path, paint);

    // Paint the bottom part of the bottle (with a circular arc)
    canvas.drawArc(
      Rect.fromLTRB(0, size.height - r, size.width, size.height),
      math.pi * 1.59,
      math.pi * 1.82,
      false,
      paint,
    );
  }

  // Function to paint the mask that holds the liquid (used for liquid fill)
  @override
  void paintBottleMask(Canvas canvas, Size size, Paint paint) {
    final r = math.min(size.width, size.height);

    // Draw the bottle mask (the liquid area)
    canvas.drawCircle(
      Offset(size.width / 2, size.height - r / 2),
      r / 2 - 5,
      paint,
    );

    // If the bottle is 'portrait', skip drawing the neck mask
    if (size.height / size.width < breakPoint) {
      return;
    }

    // Paint the neck region for wider bottles
    final neckRingInner = size.width * 0.35;
    final neckRingInnerR = size.width - neckRingInner;
    canvas.drawRect(
      Rect.fromLTRB(
        neckRingInner + 5,
        0,
        neckRingInnerR - 5,
        size.height - r / 2,
      ),
      paint,
    );
  }

  // Function to paint the liquid waves inside the bottle
  @override
  void paintWaves(Canvas canvas, Size size, Paint paint) {
    for (var wave in waves) {
      paint.color = wave.color; // Set the color of the wave
      final transform = Matrix4.identity();
      final desiredW = 15 * size.width;
      final desiredH = 0.1 * size.height;
      final translateRange = desiredW - size.width;
      final scaleX =
          desiredW / wave.svgData.getBounds().width; // Scale based on wave size
      final scaleY =
          desiredH /
          wave.svgData.getBounds().height; // Scale the height of the wave
      final translateX = -wave.offset * translateRange;
      final liquidRange = size.height + desiredH;
      final translateY =
          (1.0 - liquidLevel) * liquidRange -
          desiredH; // Adjust wave's vertical position based on liquid level
      transform.translate(translateX, translateY);
      transform.scale(scaleX, scaleY);
      canvas.drawPath(wave.svgData.transform(transform.storage), paint);

      // If this is the last wave, fill the remaining space below the wave
      if (waves.indexOf(wave) != waves.length - 1) {
        continue;
      }
      final gap = size.height - desiredH - translateY;
      if (gap > 0) {
        canvas.drawRect(
          Rect.fromLTRB(0, desiredH + translateY, size.width, size.height),
          paint,
        );
      }
    }
  }

  // Function to paint the bubbles on top of the liquid
  @override
  void paintBubbles(Canvas canvas, Size size, Paint paint) {
    for (var bubble in bubbles) {
      paint.color = bubble.color; // Set the bubble color
      final offset = Offset(
        bubble.x * size.width,
        (bubble.y + 1.0 - liquidLevel) * size.height,
      );
      final radius =
          bubble.size *
          math.min(size.width, size.height); // Scale the bubble size
      canvas.drawCircle(offset, radius, paint); // Draw the bubble
    }
  }

  // Function to paint the glossy overlay effect on the liquid
  @override
  void paintGlossyOverlay(Canvas canvas, Size size, Paint paint) {
    final r = math.min(size.width, size.height);
    final rect = Offset(0, size.height - r) & size;
    final gradient = RadialGradient(
      center: Alignment.center,
      colors: [Colors.white.withAlpha(120), Colors.white.withAlpha(0)],
    ).createShader(rect); // Create a radial gradient for the glossy effect
    paint.color = Colors.white;
    paint.shader = gradient;

    // Draw the glossy effect on the liquid
    canvas.drawRect(
      Rect.fromLTRB(5, size.height - r + 3, size.width - 5, size.height - 5),
      paint,
    );

    // Draw a highlight on top of the liquid for a shiny effect
    paint.shader = null;
    paint.color = Colors.white.withAlpha(30);
    paint.style = PaintingStyle.stroke;
    const highlightWidth = 0.1;
    paint.strokeWidth = r * highlightWidth;
    const highlightOffset = 0.1;
    final delta = r * highlightOffset;
    canvas.drawArc(
      Rect.fromLTRB(
        delta,
        size.height - r + delta,
        size.width - delta,
        size.height - delta,
      ),
      math.pi * 0.8,
      math.pi * 0.4,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTRB(
        delta,
        size.height - r + delta,
        size.width - delta,
        size.height - delta,
      ),
      math.pi * 1.25,
      math.pi * 0.1,
      false,
      paint,
    );
  }

  // Function to paint the cap of the bottle
  @override
  void paintCap(Canvas canvas, Size size, Paint paint) {
    if (size.height / size.width < breakPoint) {
      return; // Skip if the bottle is 'portrait'
    }
    final capTop = 0.0;
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
    canvas.drawPath(path, paint); // Draw the cap path
  }
}
