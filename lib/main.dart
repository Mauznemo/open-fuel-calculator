import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:fuel_calculator_flutter/pages/home.dart';
import 'package:fuel_calculator_flutter/pages/settings.dart';

import 'helpers/object_box.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBox.init();

  runApp(
    DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Fallback to default color schemes if dynamic colors are not available
        ColorScheme lightColorScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue);
        ColorScheme darkColorScheme = darkDynamic ??
            ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.dark);

        return MaterialApp(
          theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
          darkTheme:
              ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
          themeMode:
              ThemeMode.system, // Automatically switch based on system settings
          initialRoute: "/",
          routes: {
            "/": (context) => const HomePage(),
            "/settings": (context) => const SettingsPage(),
          },
        );
      },
    ),
  );
}
