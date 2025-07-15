import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/local_storage_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check if a user is already logged in
  final localStorageService = LocalStorageService();
  final user = await localStorageService.getUser();
  
  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payer.rf.gd Collector',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[600],
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[500],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      // If logged in, go to Dashboard, otherwise show Onboarding
      home: isLoggedIn ? DashboardScreen() : OnboardingScreen(),
    );
  }
}