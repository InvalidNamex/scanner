import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/404.dart';
import '/screens/file_management/new_file_screen.dart';
import '/screens/home_screen.dart';
import '/widgets/search_widget/search_screen.dart';
import 'bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: TextDirection.rtl,
      title: 'Scanner',
      initialBinding: HomeBinding(),
      initialRoute: '/',
      fallbackLocale: const Locale('en', 'US'),
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const NotFound(),
        );
      },
      getPages: [
        GetPage(
            name: '/',
            page: () => const HomeScreen(),
            binding: HomeBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/new-file',
            page: () => const NewFileScreen(),
            binding: HomeBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/search',
            page: () => const SearchScreen(),
            binding: HomeBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
      ],
    );
  }
}
//TODO: localization
//TODO: backup & restore
//TODO: login & register
