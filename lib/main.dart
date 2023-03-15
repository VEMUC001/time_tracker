import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "one-life-time-tracker",
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

FirebaseDatabase getInstanceForFireBase() {
  FirebaseApp secondaryApp = Firebase.app('one-life-time-tracker');
  return FirebaseDatabase.instanceFor(app: secondaryApp);
}
