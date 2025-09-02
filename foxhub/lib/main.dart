import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foxhub/config/firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/signup_screen.dart';
import 'screens/home_screen.dart';
import 'package:foxhub/config/supabase_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Load dotenv and Firebase, but don't block the app UI
  final futureInit = Future.wait([
    dotenv.load(fileName: ".env"),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SupabaseConfig.initialize(),
    Hive.initFlutter(),
    Hive.openBox('jobCache'),// Local DB for jobs
    Hive.openBox('apiUsage') // Tracks daily API calls
  ]);

  runApp(MyApp(initFuture: futureInit));
}

class MyApp extends StatelessWidget {
  final Future<void> initFuture;

  const MyApp({super.key, required this.initFuture});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FoxHub',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // Show splash/loading while dotenv & Firebase load
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // Initialization done, show login screen
            return const LoginScreen();
          },
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}
