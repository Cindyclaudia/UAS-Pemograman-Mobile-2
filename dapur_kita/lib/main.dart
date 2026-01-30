import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import screens (pastikan nama file & class persis sama!)
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
// import 'screens/resep_data.dart';  // ← hapus dulu kalau unused, nanti tambah lagi kalau dipakai

void main() {
  runApp(const DapurKitaApp());
}

class DapurKitaApp extends StatelessWidget {
  const DapurKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dapur Kita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // Gunakan const kalau class-nya support const constructor
      home: const SplashScreen(),

      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}