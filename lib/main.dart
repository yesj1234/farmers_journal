// Flutter imports
import 'package:flutter/material.dart';

//Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// pub import
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// pages import
import 'package:farmers_journal/presentation/pages/page_main.dart';
import 'package:flutter/rendering.dart';

// provider observer

import 'package:farmers_journal/data/my_observer.dart';

// temp import for development
import 'package:farmers_journal/presentation/components/carousel/carousel.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:farmers_journal/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/presentation/components/button/button_filter_date.dart';
import 'package:farmers_journal/presentation/pages/page_statistics.dart';
import 'package:farmers_journal/presentation/pages/page_settings.dart';
import 'package:farmers_journal/presentation/pages/page_profile_name.dart';
import 'package:farmers_journal/presentation/pages/page_place.dart';
import 'package:farmers_journal/presentation/pages/page_plant.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting.dart';
import 'package:uuid/uuid.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('ko_KR').then(
    (_) => runApp(
      ProviderScope(
        observers: [MyObserver()],
        child: const MyApp(),
      ),
    ),
  );
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
      home: PlaceAutoComplete(
        sessionToken: Uuid().v4(),
      ),
    );
  }
}
