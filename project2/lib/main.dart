import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/providers/user_provider.dart';
import 'package:project2/responsive/mobile_screen_layout.dart';
import 'package:project2/responsive/responsive_layout.dart';
import 'package:project2/responsive/web_screen_layout.dart';
import 'package:project2/screens/login_screen.dart';
import 'package:project2/screens/signup_screen.dart';
import 'package:project2/utils/colors.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PetConnect',
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          //home: const ResponsiveLayout(
            //webScreenLayout: WebScreenLayout(),
            //mobileScreenLayout: MobileScreenLayout(),
          //),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active){
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting)  {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  )
                );
              }
              return const LoginScreen();
            }
          )
        )
    );
  }
}

