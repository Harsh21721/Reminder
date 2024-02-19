import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remi/reminder/DB/db_helper.dart';
import 'package:remi/reminder/ui/home_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(const Remi());
}

class Remi extends StatelessWidget {
  const Remi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
