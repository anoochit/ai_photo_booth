import 'package:app/firebase_options.dart';
import 'package:app/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: debug mode
  if (kDebugMode) {
    try {
      // 1. Android emulators view the host machine at 10.0.2.2
      // iOS simulators and web view it at localhost (127.0.0.1)
      final String host = defaultTargetPlatform == TargetPlatform.android
          ? '10.0.2.2'
          : 'localhost';

      // 2. Configure Authentication Emulator
      // await FirebaseAuth.instance.useAuthEmulator(host, 9099);

      // 3. Configure Firestore Emulator
      // FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);

      // 4. Configure Cloud Storage Emulator
      await FirebaseStorage.instance.useStorageEmulator(host, 9199);

      print('--- Connected to Firebase Local Emulators ---');
    } catch (e) {
      print('Failed to connect to Firebase Emulators: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
