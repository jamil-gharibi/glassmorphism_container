import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_container/liquied_glass.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: LiquidGlassCard(
                lightAngle: 1.1,
                borderRadius: 42,
                padding: 10,
                noLightRange: 0.3,
                borderWith: 4,
                degreeRange: 0.4,
                isFullyTransparent: true,
                child: Center(
                  child: Text(
                    'Hello World!',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
