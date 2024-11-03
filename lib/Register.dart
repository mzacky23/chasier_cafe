import 'package:chasier_cafe/Service/RegisterService.dart';
import 'package:flutter/material.dart';
import 'Admin/AdminPage.dart';
import 'Cashier/CashierPage.dart';
import 'Manager/ManagerPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterCafeState createState() => _RegisterCafeState();
}

class _RegisterCafeState extends State<RegisterPage> {
  String? selectedRole; // Variabel untuk menyimpan role yang dipilih
  final List<String> roles = ['cashier', 'manager', 'admin']; // Pilihan role

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Untuk validasi form

  RegisterService _registerService =
      RegisterService(); // Instansi dari RegisterService

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Menyiapkan body permintaan
      var request = {
        'user_name': usernameController.text, // Pastikan menggunakan user_name
        'username': emailController.text,
        'password': passwordController.text,
        'role': selectedRole,
      };

      // Debug: Cetak body permintaan
      print("Request Body: ${request}");

      var response = await _registerService
          .registerAct(request); // Panggil method registerAct

      if (response != null && response['success'] == true) {
        // Cek apakah pendaftaran berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pendaftaran berhasil')),
        );

        // Navigasi berdasarkan role yang dipilih
        if (selectedRole == 'cashier') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CashierPage()),
          );
        } else if (selectedRole == 'manager') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManagerPage()),
          );
        } else if (selectedRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        }
      } else {
        // Menghandle kegagalan pendaftaran
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Pendaftaran gagal: ${response?['message'] ?? 'Unknown error'}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar AppBar menyatu dengan background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan
        elevation: 0, // Menghilangkan bayangan AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Tombol back
          iconSize: 30.0,
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/enter'); // Kembali ke PageEnter
          },
        ),
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay semi-transparan
          Container(
            color: Colors.white.withOpacity(0.1),
          ),
          // UI Form
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'WIKUSAMA CAFE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Logo
                    Image.asset(
                      'assets/images/Logo1.png',
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    // Username TextField
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.0),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.black, // Warna hitam untuk border
                            width: 20.0, // Ketebalan border
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Role DropdownButtonFormField
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: Text("Select Role"),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.black, // Warna hitam untuk border
                            width: 20.0, // Ketebalan border
                          ),
                        ),
                      ),
                      items: roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRole =
                              newValue; // Memperbarui role yang dipilih
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Email TextField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.0),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.black, // Warna hitam untuk border
                            width: 20.0, // Ketebalan border
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Password TextField
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.0),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.black, // Warna hitam untuk border
                            width: 20.0, // Ketebalan border
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    // Register Button
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[500],
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 6,
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
