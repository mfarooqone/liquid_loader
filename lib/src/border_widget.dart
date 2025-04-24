import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'bubble_widget.dart';
import 'wave.dart';

/// Mixin that handles the initialization and disposal of wave and bubble layers
/// used for creating an animated liquid effect within the bottle widget.
///
/// This mixin is responsible for managing wave layers and bubble widgets that
/// simulate the movement and appearance of liquid inside the bottle.
mixin BorderWidget {
  /// List of wave layers for the animated water effect.
  ///
  /// Each wave layer has its own frequency and color, creating a multi-layered
  /// animated wave effect inside the bottle.
  List<WaveLayer> waves = List<WaveLayer>.empty(growable: true);

  /// List of bubble widgets that will appear inside the bottle.
  ///
  /// These bubbles simulate the motion of bubbles within the liquid and are
  /// animated to appear and move upwards.
  List<BubbleWidget> bubbles = List<BubbleWidget>.empty(growable: true);

  /// Constant for the number of wave layers to create.
  ///
  /// This value defines how many wave layers will be generated to create the
  /// animated liquid effect.
  static const waveCount = 3; // Number of wave layers to create

  /// Constant for the number of bubbles to create.
  ///
  /// This value determines how many bubbles will be displayed within the bottle.
  static const bubbleCount = 10; // Number of bubbles to create

  /// Method to initialize wave and bubble layers.
  ///
  /// This method sets up the wave layers and bubble widgets by configuring
  /// their properties, including their frequency, color, and position.
  /// It also ensures that the waves and bubbles are animated with the provided
  /// `TickerProvider`.
  ///
  /// [themeColor] The color for the waves and bubbles.
  /// [ticker] The TickerProvider to handle the animations for the waves and bubbles.
  void initLayers(
    Color themeColor, // Color for the waves and bubbles
    TickerProvider ticker, // TickerProvider to handle animations
  ) {
    // Generate random frequency and delay values for wave layers
    var f = math.Random().nextInt(5000) + 15000;
    var d = math.Random().nextInt(500) + 1500;

    // Convert the theme color to HSL to adjust lightness and saturation
    var color = HSLColor.fromColor(themeColor);

    // Create the wave layers with varying frequency, color, and saturation/lightness
    for (var i = 1; i <= waveCount; i++) {
      final wave = WaveLayer(); // Create a new wave layer
      wave.init(ticker, frequency: f); // Initialize wave with frequency

      // Adjust the saturation and lightness of the wave color
      final sat =
          color.saturation *
          math.pow(0.6, (waveCount - i)); // Decrease saturation for each wave
      final light =
          color.lightness *
          math.pow(0.8, (waveCount - i)); // Decrease lightness for each wave

      // Set the color for the wave layer
      wave.color = color.withSaturation(sat).withLightness(light).toColor();

      // Add the wave layer to the list
      waves.add(wave);

      // Decrease the frequency for the next wave and ensure it doesn't go negative
      f -= d;
      f = math.max(f, 0);
    }

    // Create bubble widgets with random positions and animations
    for (var i = 0; i < bubbleCount; i++) {
      final bubble = BubbleWidget(); // Create a new bubble widget
      bubble.init(ticker); // Initialize the bubble with the ticker
      bubble.randomize(); // Randomize the bubble's starting position
      bubbles.add(bubble); // Add the bubble to the list
    }
  }

  /// Method to dispose the wave and bubble layers when no longer needed.
  ///
  /// This method ensures that all resources associated with the wave layers
  /// and bubble widgets are properly disposed of to free up memory.
  void disposeLayers() {
    // Dispose all wave layers
    for (var e in waves) {
      e.dispose();
    }

    // Dispose all bubble widgets
    for (var e in bubbles) {
      e.dispose();
    }
  }
}
