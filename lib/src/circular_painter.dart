import 'package:flutter/material.dart';

import 'bubble_widget.dart'; // your BubbleWidget class with .x, .y, .size, .color
import 'wave.dart'; // your WaveLayer class with .color, .offset, .svgData

/// A [CustomPainter] that draws a circular “bottle” of liquid,
/// complete with animated waves, rising bubbles, and a glossy overlay.
class CustomCirclePainterWidget extends CustomPainter {
  /// The layers of wave shapes to draw, from back (waves[0]) to front (waves.last).
  final List<WaveLayer> waves;

  /// The bubbles to render, each with its own position, size, and color.
  final List<BubbleWidget> bubbles;

  /// How full the circle is: 0.0 = completely empty, 1.0 = completely full.
  final double liquidLevel;

  /// The color used for the circle’s border stroke.
  final Color borderColor;

  /// The color of the glossy overlay drawn on top of the liquid.
  final Color glossColor;

  /// Creates a circle‐shaped liquid painter.
  ///
  /// The [waves], [bubbles], [liquidLevel], and [borderColor] parameters are
  /// required. You can optionally override [glossColor] to tweak the shine.
  CustomCirclePainterWidget({
    Listenable? repaint,
    required this.waves,
    required this.bubbles,
    required this.liquidLevel,
    required this.borderColor,
    this.glossColor = const Color(0x33FFFFFF),
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = size.center(Offset.zero);
    final circleRect = Rect.fromCircle(center: center, radius: radius);
    final circlePath = Path()..addOval(circleRect);

    // 1️⃣ Draw the circular border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 2️⃣ Clip everything inside the circle
    canvas.save();
    canvas.clipPath(circlePath);

    // 3️⃣ Draw each wave, then fill below the last one
    for (var i = 0; i < waves.length; i++) {
      final wave = waves[i];
      final paint = Paint()..color = wave.color;

      final desiredW = 15 * circleRect.width;
      final desiredH = 0.15 * circleRect.height;
      final translateX =
          circleRect.left - wave.offset * (desiredW - circleRect.width);
      final translateY =
          circleRect.bottom - (liquidLevel * circleRect.height) - desiredH;

      final matrix =
          Matrix4.identity()
            ..translate(translateX, translateY)
            ..scale(
              desiredW / wave.svgData.getBounds().width,
              desiredH / wave.svgData.getBounds().height,
            );
      final path = wave.svgData.transform(matrix.storage);

      canvas.drawPath(path, paint);

      if (i == waves.length - 1) {
        final fillTop = translateY + desiredH;
        if (fillTop < circleRect.bottom) {
          canvas.drawRect(
            Rect.fromLTRB(
              circleRect.left,
              fillTop,
              circleRect.right,
              circleRect.bottom,
            ),
            paint,
          );
        }
      }
    }

    // 4️⃣ Draw bubbles rising from bottom → top
    for (final bubble in bubbles) {
      final paint = Paint()..color = bubble.color;
      final dx = circleRect.left + bubble.x * circleRect.width;
      final dy =
          circleRect.bottom - bubble.y * (liquidLevel * circleRect.height);
      final bubbleRadius = bubble.size * radius;
      canvas.drawCircle(Offset(dx, dy), bubbleRadius, paint);
    }

    // 5️⃣ Glossy overlay on top of everything
    final glossPaint = Paint()..color = glossColor;
    canvas.drawRect(circleRect, glossPaint);

    // 6️⃣ Restore to draw anything outside the circle (if needed)
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomCirclePainterWidget old) => true;
}
