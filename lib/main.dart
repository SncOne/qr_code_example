import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_qr_page.dart';
import 'home_page.dart';
import 'scan_qr_page.dart';

void main() async {
  await init();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR Code",
      home: const HomePage(),
      routes: {
        '/Home': (_) => const HomePage(),
        '/CreateQr': (_) => CreateQrPage(),
        '/ScanQr': (_) => const ScanQrPage(),
      },
    );
  }
}
