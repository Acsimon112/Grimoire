import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  await FirebaseAuth.instance.signInAnonymously();
  //I'm too lazy to do email auth, this works for what I need it to do for now.

  runApp(const MyApp());
}
