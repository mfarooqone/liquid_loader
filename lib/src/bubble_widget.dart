import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget representing a bubble inside the liquid.
///
/// The [BubbleWidget] simulates the appearance and movement of a bubble
/// inside the bottle. It has animated properties like position, opacity,
/// and size, and is randomized each time it is initialized or respawned.
class BubbleWidget {
  /// Animation for the bubble's position.
  late Animation<double> positionAnimation;

  /// Animation for the bubble's opacity.
  late Animation<double> opacityAnimation;

  /// Animation for the bubble's size.
  late Animation<double> sizeAnimation;

  /// Controller for the animations.
  late AnimationController controller;

  /// Ticker provider for managing the animations.
  late TickerProvider provider;

  /// Initial X position (horizontal position) of the bubble.
  double initialX = 0;

  /// Initial color of the bubble.
  Color initialColor = Colors.blueGrey;

  /// Gets the color of the bubble, adjusting the alpha based on opacity animation.
  ///
  /// The color of the bubble is modified dynamically during the animation to
  /// reflect its current opacity.
  Color get color => initialColor.withAlpha(opacityAnimation.value.toInt());

  /// Gets the X position of the bubble.
  ///
  /// This is the horizontal position where the bubble is placed.
  double get x => initialX;

  /// Gets the Y position (vertical) of the bubble.
  ///
  /// This value is animated to create the effect of the bubble moving upwards.
  double get y => positionAnimation.value;

  /// Gets the size of the bubble.
  ///
  /// The size of the bubble is animated, creating the effect of the bubble
  /// growing and shrinking.
  double get size => sizeAnimation.value;

  /// Initializes the bubble widget, setting up the provider and controller for animations.
  ///
  /// This method sets up the animation controller, ticker provider, and
  /// initializes the animations for position, size, and opacity.
  ///
  /// [provider] The TickerProvider used to manage animations.
  void init(TickerProvider provider) {
    this.provider = provider;

    controller = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 10000),
    );
  }

  /// Disposes the animation controller when no longer needed.
  ///
  /// This method cleans up resources by disposing of the animation controller
  /// to prevent memory leaks.
  void dispose() {
    controller.dispose();
  }

  /// Returns a random animation curve for the bubble's movement.
  ///
  /// This method randomly selects one of several predefined animation curves
  /// to apply to the bubble's movement, making the animation feel more organic.
  Curve randomCurve() {
    switch (math.Random().nextInt(5)) {
      case 0:
        return Curves.ease;
      case 1:
        return Curves.easeInOutSine;
      case 2:
        return Curves.easeInSine;
      case 3:
        return Curves.easeOutSine;
      case 4:
        return Curves.easeInOutQuad;
      default:
        return Curves.linear;
    }
  }

  /// Randomizes bubble behavior (called at initialization or respawn).
  ///
  /// This method randomizes the bubble's properties such as color, position,
  /// size, and animation duration to create a unique bubble every time it is
  /// initialized or respawned.
  void randomize() {
    // Randomize the duration for each bubble animation (between 3-10 seconds)
    controller.duration = Duration(
      milliseconds: math.Random().nextInt(7000) + 3000,
    );

    // Randomly generate a new color for the bubble
    initialColor =
        HSLColor.fromAHSL(
          1.0, // Full opacity
          math.Random().nextDouble(), // Random hue (color)
          math.Random().nextDouble() * 0.3, // Random saturation
          math.Random().nextDouble() * 0.3 + 0.7, // Random lightness
        ).toColor();

    // Randomize the X position of the bubble
    initialX = math.Random().nextDouble();

    // Randomize the Y position and movement range (from 1.0 to 1.3 for start, 0.2 to 0.5 for end)
    double initialY = math.Random().nextDouble() * 0.3 + 1.0;
    double finalY = math.Random().nextDouble() * 0.3 + 0.2;

    // Randomize the initial and final size of the bubble (from 0.01 to 0.1)
    double initialSize = math.Random().nextDouble() * 0.01;
    double finalSize = math.Random().nextDouble() * 0.1;

    // Set up the position animation with a random curve
    positionAnimation = Tween<double>(
      begin: initialY,
      end: finalY,
    ).animate(CurvedAnimation(parent: controller, curve: randomCurve()));

    // Set up the size animation with a smooth ease-in-out sine curve
    sizeAnimation = Tween<double>(
      begin: initialSize,
      end: finalSize,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine));

    // Set up the opacity animation (random opacity from 155 to 255)
    opacityAnimation = Tween<double>(
      begin: math.Random().nextDouble() * 100 + 155,
      end: 0, // Fade out the bubble to transparency
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine));

    // Add a listener to the position animation to restart it when it completes
    positionAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat(); // Repeat the animation
        randomize(); // Randomize the bubble properties for next cycle
      }
    });

    // Start the animation
    controller.forward();
  }
}
