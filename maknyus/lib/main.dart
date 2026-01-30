import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Import semua halaman yang telah kita buat
import 'pages/auth/login_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/recipe/recipe_form_page.dart';
import 'pages/recipe/recipe_detail_page.dart';
import 'pages/recipe/favorite_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maknyus',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // Cek status login user
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return const HomePage();
          return const AuthPage(); 
        },
      ),
      // Daftar Rute Navigasi
      routes: {
        '/login': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/recipe-form': (context) => const RecipeFormPage(),
        '/recipe-detail': (context) => const RecipeDetailPage(),
        '/favorites': (context) => const FavoritePage(),
      },
    );
  }
}