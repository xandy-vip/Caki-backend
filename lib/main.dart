import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

import 'screens/loja_screen.dart';
import 'screens/login_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CakiApp());
}

class CakiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caki',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenWithRedirect(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/rooms': (context) => RoomsScreen(),
        '/chat': (context) => ChatScreen(),
        '/profile': (context) => ProfileScreen(),
        '/loja': (context) => LojaScreen(),
      },
    );
  }
}

// SplashScreen que redireciona automaticamente para LoginScreen
class SplashScreenWithRedirect extends StatefulWidget {
  @override
  State<SplashScreenWithRedirect> createState() =>
      _SplashScreenWithRedirectState();
}

class _SplashScreenWithRedirectState extends State<SplashScreenWithRedirect> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
