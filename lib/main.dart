import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuellevel_monitoring/config/color.dart';
import 'package:fuellevel_monitoring/controller/fuel_controller.dart';
import 'package:fuellevel_monitoring/firebase_options.dart';
import 'package:fuellevel_monitoring/page/info.dart';
import 'package:fuellevel_monitoring/page/intro.dart';
import 'package:fuellevel_monitoring/page/monitor1.dart';
import 'package:fuellevel_monitoring/page/tank_detail_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  Get.put(FuelController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const IntroPage(),
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            primaryColor: AppColor.primary,
            colorScheme: const ColorScheme.light(
                primary: AppColor.primary, secondary: AppColor.secondary)),
        routes: {
          '/monitor1': (context) => const Monitor1(),
          '/info': (context) => const InfoPage(),
          '/tank_detail': (context) => TankDetailPage(
                tankIndex: ModalRoute.of(context)!.settings.arguments as int,
              ),
        });
  }
}
