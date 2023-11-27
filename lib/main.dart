import 'package:detect_smoke/provider/app_provider.dart';
import 'package:detect_smoke/screen/auth_ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'custom_bottom_bar/custom_bottom_bar.dart';
import 'firebase_helper/firebase_auth.dart';
import 'firebase_helper/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smoke Detect',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuthHelper.instance.getAuthChange,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return const CustomBottomBar();
            }
            return const Login();
          },
        ),
      ),
    );
  }
}


