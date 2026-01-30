import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Untuk berpindah antara tab Masuk dan Daftar
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  // Fungsi untuk Login dan Register
  Future<void> handleAuth() async {
    try {
      if (isLogin) {
        // Logika MASUK
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        // Logika DAFTAR
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Simpan nama pengguna ke profil Firebase
        await FirebaseAuth.instance.currentUser!.updateDisplayName(nameController.text.trim());
      }
      // Jika berhasil, pindah ke rute /home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${e.toString()}")),
      );
    }
  }

  // Fungsi Fitur Lupa Kata Sandi
  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan masukkan email Anda terlebih dahulu")),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link reset kata sandi telah dikirim ke email Anda")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // PENGGANTI LOGO: Menggunakan Icon agar tidak error ImageCodec
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
              const Text(
                "Maknyus",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 30),

              // TAB SWITCHER: Daftar atau Masuk
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() => isLogin = false),
                    child: Text("Daftar", 
                      style: TextStyle(color: !isLogin ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    onPressed: () => setState(() => isLogin = true),
                    child: Text("Masuk", 
                      style: TextStyle(color: isLogin ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // FORM INPUT
              if (!isLogin) // Nama Lengkap hanya muncul jika tab Daftar dipilih
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Lengkap", prefixIcon: Icon(Icons.person_outline)),
                ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Kata Sandi", prefixIcon: Icon(Icons.lock_outline)),
              ),

              // FITUR LUPA KATA SANDI
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: forgotPassword,
                  child: const Text("Lupa Kata Sandi?", style: TextStyle(color: Colors.orange, fontSize: 12)),
                ),
              ),

              const SizedBox(height: 20),

              // TOMBOL UTAMA
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    isLogin ? "MASUK" : "BUAT AKUN",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}