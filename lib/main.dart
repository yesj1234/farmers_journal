// Flutter imports
import 'package:flutter/material.dart';

//Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// pub import
import 'package:flex_color_scheme/flex_color_scheme.dart';

// pages import
import 'package:farmers_journal/pages/page_main.dart';
import 'package:flutter/rendering.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.green,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useM2StyleDividerInM3: true,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedBorderIsColored: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: const PageMain(),
    );
  }
}
