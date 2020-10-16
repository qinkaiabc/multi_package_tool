import 'dart:math';

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart' as windowSize;
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  windowSize.getWindowInfo().then((window) {
    if (window.screen != null) {
      final screenFrame = window.screen.visibleFrame;
      final width = max((screenFrame.width / 2).roundToDouble(), 800.0);
      final height = max((screenFrame.height / 2).roundToDouble(), 600.0);
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);
      windowSize.setWindowFrame(frame);
      windowSize.setWindowMinSize(Size(0.8 * width, 0.8 * height));
      windowSize.setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      windowSize.setWindowTitle('多渠道打包工具');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
