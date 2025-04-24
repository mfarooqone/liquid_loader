import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_parsing/path_parsing.dart';

/// PathWriter is a class that extends PathProxy to handle writing SVG path data to a Path object.
///
/// This class facilitates converting SVG path data into Flutter's Path object, allowing for
/// easy integration of complex path shapes, such as those used for the waves in liquid animation.
class PathWriter extends PathProxy {
  /// The Path object that will store the generated path data.
  final Path path;

  /// Constructor to initialize with a Path object or create a new one if none is provided.
  ///
  /// [path] The initial path to use, or a new [Path] will be created if not provided.
  PathWriter({Path? path}) : path = path ?? Path();

  /// Close the current path.
  ///
  /// This method ends the current subpath and is typically used for creating closed shapes.
  @override
  void close() {
    path.close();
  }

  /// Add a cubic Bezier curve to the path.
  ///
  /// [x1], [y1] The control point for the start of the curve.
  /// [x2], [y2] The control point for the end of the curve.
  /// [x3], [y3] The end point of the curve.
  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  /// Add a line to the path from the current position to the specified coordinates.
  ///
  /// [x], [y] The destination coordinates for the line.
  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
  }

  /// Move the current position to the specified coordinates.
  ///
  /// [x], [y] The coordinates to move the current position to.
  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
  }
}

/// WaveLayer handles the animation and rendering of a wave in the bottle.
///
/// This class is responsible for managing the wave's animation, including the offset
/// and wave path, and for rendering the wave in the bottle with an animated effect.
class WaveLayer {
  /// Animation to handle the wave offset.
  late final Animation<double> animation;

  /// The controller for the animation.
  late final AnimationController controller;

  /// Path object to store the wave data (SVG path).
  final svgData = Path();

  /// The color of the wave.
  Color color = Colors.blueGrey;

  /// The current animation value (offset) for the wave.
  double get offset => animation.value;

  /// Setup animations for the wave.
  ///
  /// Initializes the animation controller, creates a Tween for the wave offset,
  /// and builds the path for the wave.
  ///
  /// [provider] The TickerProvider to manage the animation lifecycle.
  /// [frequency] The frequency of the wave animation, affecting the duration.
  void init(TickerProvider provider, {int frequency = 10}) {
    controller = AnimationController(
      vsync: provider,
      duration: Duration(milliseconds: frequency),
    );

    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine));

    // Add a listener to repeat the animation when completed or dismissed.
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.repeat(reverse: true);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.value = math.Random().nextDouble();
    controller.forward();

    buildPath();
  }

  /// Clean up resources by disposing of the animation controller.
  void dispose() {
    controller.dispose();
  }

  /// Build the path for the wave shape from the predefined SVG path data.
  ///
  /// This method selects a random SVG path and converts it into a `Path` object for rendering.
  void buildPath() {
    const path = [
      "M0,64L6.2,58.7C12.3,53,25,43,37,53.3C49.2,64,62,96,74,101.3C86.2,107,98,85,111,69.3C123.1,53,135,43,148,37.3C160,32,172,32,185,32C196.9,32,209,32,222,64C233.8,96,246,160,258,192C270.8,224,283,224,295,197.3C307.7,171,320,117,332,122.7C344.6,128,357,192,369,186.7C381.5,181,394,107,406,80C418.5,53,431,75,443,112C455.4,149,468,203,480,202.7C492.3,203,505,149,517,144C529.2,139,542,181,554,218.7C566.2,256,578,288,591,282.7C603.1,277,615,235,628,229.3C640,224,652,256,665,266.7C676.9,277,689,267,702,245.3C713.8,224,726,192,738,181.3C750.8,171,763,181,775,154.7C787.7,128,800,64,812,69.3C824.6,75,837,149,849,154.7C861.5,160,874,96,886,85.3C898.5,75,911,117,923,138.7C935.4,160,948,160,960,154.7C972.3,149,985,139,997,149.3C1009.2,160,1022,192,1034,192C1046.2,192,1058,160,1071,144C1083.1,128,1095,128,1108,144C1120,160,1132,192,1145,213.3C1156.9,235,1169,245,1182,261.3C1193.8,277,1206,299,1218,261.3C1230.8,224,1243,128,1255,117.3C1267.7,107,1280,181,1292,224C1304.6,267,1317,277,1329,277.3C1341.5,277,1354,267,1366,272C1378.5,277,1391,299,1403,304C1415.4,309,1428,299,1434,293.3L1440,288L1440,320L1433.8,320C1427.7,320,1415,320,1403,320C1390.8,320,1378,320,1366,320C1353.8,320,1342,320,1329,320C1316.9,320,1305,320,1292,320C1280,320,1268,320,1255,320C1243.1,320,1231,320,1218,320C1206.2,320,1194,320,1182,320C1169.2,320,1157,320,1145,320C1132.3,320,1120,320,1108,320C1095.4,320,1083,320,1071,320C1058.5,320,1046,320,1034,320C1021.5,320,1009,320,997,320C984.6,320,972,320,960,320C947.7,320,935,320,923,320C910.8,320,898,320,886,320C873.8,320,862,320,849,320C836.9,320,825,320,812,320C800,320,788,320,775,320C763.1,320,751,320,738,320C726.2,320,714,320,702,320C689.2,320,677,320,665,320C652.3,320,640,320,628,320C615.4,320,603,320,591,320C578.5,320,566,320,554,320C541.5,320,529,320,517,320C504.6,320,492,320,480,320C467.7,320,455,320,443,320C430.8,320,418,320,406,320C393.8,320,382,320,369,320C356.9,320,345,320,332,320C320,320,308,320,295,320C283.1,320,271,320,258,320C246.2,320,234,320,222,320C209.2,320,197,320,185,320C172.3,320,160,320,148,320C135.4,320,123,320,111,320C98.5,320,86,320,74,320C61.5,320,49,320,37,320C24.6,320,12,320,6,320L0,320Z",
    ];

    final i = math.Random().nextInt(
      path.length,
    ); // Randomly select one of the SVG path data
    writeSvgPathDataToPath(
      path[i], // Write the selected SVG path data to the svgData Path
      PathWriter(path: svgData),
    );
  }
}
