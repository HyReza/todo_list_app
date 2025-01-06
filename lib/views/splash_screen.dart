import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: 1),

            // Bagian atas (Animasi Lottie)
            Center(
              child: Lottie.asset(
                'assets/lotties/animasi-login.json',
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20),

            // Bagian tengah (Judul dan deskripsi)
            Column(
              children: [
                Text(
                  'To-Do List App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Organize your tasks, stay productive!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Created By',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Reza Edi Saputra (202203040041)\n'
                  'Urfi Nurwahidah (202203040015)\n'
                  'Lia Khoirun Nisa\' (202203040029)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            Spacer(flex: 1),

            // Bagian bawah (Tombol "Get Started")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Mengatur ukuran tombol lebih kecil
                  children: [
                    Icon(Icons.arrow_forward_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
