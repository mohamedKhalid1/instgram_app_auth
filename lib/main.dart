import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instgram_clone/controller/cubit/forgot_password/reset_password_cubit.dart';
import 'package:instgram_clone/controller/cubit/login/login_cubit.dart';
import 'package:instgram_clone/controller/cubit/signup/sign_up_cubit.dart';
import 'package:instgram_clone/utils/constants.dart';
import 'package:instgram_clone/view/screens/home_screen.dart';
import 'package:instgram_clone/view/screens/login_screen.dart';
import 'package:instgram_clone/view/screens/reset_password_screen.dart';
import 'package:instgram_clone/view/screens/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyANMRMucBhYeVFjh2l9A7q5COm_3omfa8Q",
            appId: "1:941531777433:web:d72b1942e5bcb1a2a56b08",
            messagingSenderId: "941531777433",
            projectId: "instgram-app-693f7",
            storageBucket: "instgram-app-693f7.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider(
          create: (context) => ResetPasswordCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'instgram app',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Constants.mobileBackgroundColor,
        ),
        routes: {
          LoginScreen.route: (context) => LoginScreen(),
          SignUpScreen.route: (context) => const SignUpScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ResetPasswordScreen.route: (context) => ResetPasswordScreen(),
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (snapshot.data != null) {
                return const HomeScreen();
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
