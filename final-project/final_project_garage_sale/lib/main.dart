import 'dart:io';

import 'package:final_project_garage_sale/pages/browse_post_activity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
          apiKey: "AIzaSyAnv1cvdXNu7Lv75KTcOKNT7p4fD-nnk1A",
          appId: "1:1060545363689:android:1235826bccb186be433a78",
          messagingSenderId: "1060545363689",
          projectId: "final-hyper-garage-sale",
          storageBucket: "final-hyper-garage-sale.appspot.com",
        ))
      : await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: BrowsePostActivity());
  }
}
