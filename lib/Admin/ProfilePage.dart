import 'package:chasier_cafe/Service/UpdateUsername.dart';
import 'package:chasier_cafe/Service/ProfileService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Memuat...';
  String username = 'Memuat...';
  String role = 'Memuat...';
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId != null) {
      await _fetchUserProfile();
    } else {
      _showError('User ID tidak ditemukan. Silakan login ulang.');
      Navigator.pushReplacementNamed(context, '/enter');
    }
  }

  Future<void> _fetchUserProfile() async {
    var profileData = await ProfileService.fetchUserProfile();
    if (profileData != null) {
      setState(() {
        userName = profileData['user_name'] ?? 'Tidak tersedia';
        username = profileData['username'] ?? 'Tidak tersedia';
        role = profileData['role'] ?? 'Tidak tersedia';
      });
    } else {
      _showError('Gagal mengambil profil pengguna.');
    }
  }

  Future<void> _showUpdateUsernameDialog() async {
    final TextEditingController _usernameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Perbarui Username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username Baru',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isUpdating
                  ? null
                  : () async {
                      final newUsername = _usernameController.text.trim();
                      if (newUsername.isNotEmpty) {
                        await _updateUsername(newUsername);
                        Navigator.pop(context);
                      } else {
                        _showError('Username tidak boleh kosong.');
                      }
                    },
              child: isUpdating ? CircularProgressIndicator() : Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    setState(() {
      isUpdating = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      final result =
          await UpdateUsernameService.updateUsername(userId, newUsername);

      if (result != null && result['status'] == 'success') {
        await prefs.setString('username', newUsername);
        _showMessage('Username berhasil diperbarui.');
        setState(() {
          username = newUsername;
        });
      } else {
        _showError(result?['message'] ?? 'Gagal memperbarui username.');
      }
    } else {
      _showError('User ID tidak ditemukan. Silakan login ulang.');
      Navigator.pushReplacementNamed(context, '/enter');
    }

    setState(() {
      isUpdating = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4ECE1),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFD7CCC8),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D4C41),
                ),
              ),
              SizedBox(height: 5),
              Text(
                username,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF8D6E63),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Role: $role',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF8D6E63),
                ),
              ),
              SizedBox(height: 40),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                leading: Icon(Icons.edit, color: Color(0xFF6D4C41)),
                title: Text('Perbarui Username'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: _showUpdateUsernameDialog,
              ),
              SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                leading: Icon(Icons.logout, color: Color(0xFF6D4C41)),
                title: Text('Keluar'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacementNamed(context, '/enter');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
