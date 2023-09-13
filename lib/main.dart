import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes_app/db/db_helper.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/ui/screens/home_page.dart';
import 'package:notes_app/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeService().theme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
