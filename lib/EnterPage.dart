import 'package:flutter/material.dart';

class PageEnter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Background.jpg'), // Path ke gambar background
                fit: BoxFit.cover, // Sesuaikan gambar dengan layar
              ),
            ),
          ),
          // Overlay gelap di atas background
          Container(
            color: Colors.black
                .withOpacity(0.1), // Memberikan efek gelap pada background
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cafe Logo (opsional)
                Image.asset('assets/images/Logo.png', width: 300, height: 300),
                SizedBox(height: 50),
                // Row untuk menampilkan tombol secara horizontal
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol Login
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/login'); // Pindah ke halaman Login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        minimumSize: Size(150, 50), // Ukuran minimum tombol
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child:
                          Text('Login', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20), // Spasi antara tombol
                    // Tombol Register
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/register'); // Pindah ke halaman Register
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        minimumSize: Size(150, 50), // Ukuran minimum tombol
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
