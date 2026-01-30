import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya"), backgroundColor: Colors.orange),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Mahasiswa UAS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("mahasiswa@univ.ac.id"),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text("Resep Favorit"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Pengaturan"),
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
                child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}