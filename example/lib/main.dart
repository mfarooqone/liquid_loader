import 'package:flutter/material.dart';
import 'package:liquid_loader/liquid_loader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Loader Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Liquid Loader Example'),
        ),
        body: Center(
          child: LiquidLoader(
            width: 300,
            height: 500,
            liquidColor: Colors.orange,
            borderColor: Colors.grey,
            capColor: Colors.orange,
            liquidLevel: 0.7,
            // text: "70%",
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            shape: Shape.rectangle,
            hideCap: false,
          ),
        ),
      ),
    );
  }
}
