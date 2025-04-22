import 'dart:math' as math;

import 'package:flutter/material.dart';

class BubbleWidget {
  // Animation properties for the bubble: position, opacity, and size
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> sizeAnimation;

  // Controller for the animations
  late AnimationController controller;

  // Ticker provider for managing the animations
  late TickerProvider provider;

  // Initial properties of the bubble
  double initialX =
      0; // Initial X position (horizontal position)
  Color initialColor =
      Colors.blueGrey; // Initial color of the bubble

  // Getters for the bubble properties with live animation values
  Color get color => initialColor.withAlpha(
    opacityAnimation.value
        .toInt(), // Adjust alpha (transparency) based on opacity animation
  );
  double get x =>
      initialX; // Get the X position of the bubble
  double get y =>
      positionAnimation
          .value; // Get the Y position (vertical) of the bubble
  double get size =>
      sizeAnimation
          .value; // Get the size of the bubble

  // Initializes the bubble widget, setting up the provider and controller for animations
  void init(TickerProvider provider) {
    this.provider =
        provider; // Set the provider for managing animations
    controller = AnimationController(
      vsync:
          provider, // Use the provided ticker for animations
      duration: Duration(
        milliseconds: 10000,
      ), // Set the duration of the animation (10 seconds)
    );
  }

  // Disposes the animation controller when no longer needed
  void dispose() {
    controller.dispose();
  }

  // Returns a random animation curve for the bubble's movement
  Curve randomCurve() {
    switch (math.Random().nextInt(5)) {
      case 0:
        return Curves.ease; // Ease-in-out curve
      case 1:
        return Curves
            .easeInOutSine; // Ease-in-out sine curve
      case 2:
        return Curves.easeInSine; // Ease-in sine curve
      case 3:
        return Curves
            .easeOutSine; // Ease-out sine curve
      case 4:
        return Curves
            .easeInOutQuad; // Ease-in-out quadratic curve
      case 5:
        return Curves
            .easeInQuad; // Ease-in quadratic curve
      case 6:
        return Curves
            .easeOutQuad; // Ease-out quadratic curve
      case 7:
        return Curves
            .easeInOutExpo; // Ease-in-out exponential curve
      case 8:
        return Curves
            .easeOutExpo; // Ease-out exponential curve
      case 9:
        return Curves
            .easeInExpo; // Ease-in exponential curve
      default:
    }
    return Curves.linear; // Default to a linear curve
  }

  /// Randomize bubble behavior (called at initialization or respawn)
  void randomize() {
    // Randomize the duration for each bubble animation (between 3-10 seconds)
    controller.duration = Duration(
      milliseconds: math.Random().nextInt(7000) + 3000,
    );

    // Randomly generate a new color for the bubble
    initialColor =
        HSLColor.fromAHSL(
          1.0, // Full opacity
          math.Random()
              .nextDouble(), // Random hue (color)
          math.Random().nextDouble() *
              0.3, // Random saturation
          math.Random().nextDouble() * 0.3 +
              0.7, // Random lightness
        ).toColor();

    // Randomize the X position of the bubble
    initialX = math.Random().nextDouble();

    // Randomize the Y position and movement range (from 1.0 to 1.3 for start, 0.2 to 0.5 for end)
    double initialY =
        math.Random().nextDouble() * 0.3 + 1.0;
    double finalY =
        math.Random().nextDouble() * 0.3 + 0.2;

    // Randomize the initial and final size of the bubble (from 0.01 to 0.1)
    double initialSize =
        math.Random().nextDouble() * 0.01;
    double finalSize =
        math.Random().nextDouble() * 0.1;

    // Set up the position animation with a random curve
    positionAnimation = Tween<double>(
      begin: initialY,
      end: finalY,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve:
            randomCurve(), // Use a random curve for the movement
      ),
    );

    // Set up the size animation with a smooth ease-in-out sine curve
    sizeAnimation = Tween<double>(
      begin: initialSize,
      end: finalSize,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve:
            Curves
                .easeInOutSine, // Use a smooth ease-in-out curve for size
      ),
    );

    // Set up the opacity animation (random opacity from 155 to 255)
    opacityAnimation = Tween<double>(
      begin: math.Random().nextDouble() * 100 + 155,
      end: 0, // Fade out the bubble to transparency
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve:
            Curves
                .easeInOutSine, // Use a smooth ease-in-out curve for opacity
      ),
    );

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
