import 'dart:io';
import 'package:amazon_price_tracker/pages/homepage.dart';
import 'package:amazon_price_tracker/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

const String amazonMobile = 'amazonMobile';
const String amazonDesktop = 'amazonDesktop';
const String prozis = 'prozis';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (await Hive.boxExists('products')) await Hive.deleteBoxFromDisk('products');
  await Hive.openBox(amazonMobile);
  await Hive.openBox(amazonDesktop);
  await Hive.openBox(prozis);

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(minimumSize: Size(360, 720), size: Size(500, 720), center: true);
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Price Tracker',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const Homepage(),
    );
  }
}
