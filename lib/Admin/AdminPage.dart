import 'package:chasier_cafe/Admin/MenuPage.dart';
import 'package:chasier_cafe/Admin/ProfilePage.dart';
import 'package:chasier_cafe/Admin/TablePage.dart';
import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Admin/ShowUser.dart';
import 'package:chasier_cafe/Service/Admin/DeleteUser.dart'; // Import file DeleteUser
import 'package:chasier_cafe/Service/Admin/UserSearch.dart';
import 'package:chasier_cafe/Service/Admin/UpdateUser.dart'; // Import file UpdateUser
import 'package:chasier_cafe/Service/Admin/AddUser.dart'; // Import file AddUser

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0; // Variabel untuk melacak halaman yang dipilih

  // Daftar halaman untuk navigasi
  final List<Widget> _pages = [
    AdminPageContent(), // Konten dari AdminPage
    MenuPage(),
    TablePage(),
    ProfilePage(),
  ];

  // Method untuk mengubah halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          false, // Mencegah keluar aplikasi dengan tombol back
      child: Scaffold(
        body: _pages[
            _selectedIndex], // Tampilkan halaman sesuai dengan index yang dipilih
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Halaman yang dipilih saat ini
          onTap: _onItemTapped, // Panggil method saat item dipilih
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_restaurant),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

// Pindahkan konten AdminPage ke widget terpisah
class AdminPageContent extends StatefulWidget {
  @override
  _AdminPageContentState createState() => _AdminPageContentState();
}

class _AdminPageContentState extends State<AdminPageContent> {
  late Future<List<User>> futureUsers;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureUsers = UserService().fetchUsers();
  }

  void searchUsers(String searchKey) {
    setState(() {
      futureUsers = UserSearchService().searchUsers(searchKey);
    });
  }

  void fetchAllUsers() {
    setState(() {
      futureUsers = UserService().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                if (searchQuery.isEmpty) {
                  fetchAllUsers();
                } else {
                  searchUsers(searchQuery);
                }
              },
              decoration: InputDecoration(
                labelText: 'Cari Pengguna',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchUsers(searchQuery);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                List<User> users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      child: ListTile(
                        title: Text(user.userName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Role: ${user.role}'),
                            Text('Username: ${user.username}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                _editUser(user);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteUser(user.userId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _editUser(User user) {
    TextEditingController userNameController =
        TextEditingController(text: user.userName);
    TextEditingController roleController =
        TextEditingController(text: user.role);
    TextEditingController usernameController =
        TextEditingController(text: user.username);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                decoration: InputDecoration(labelText: 'Nama User'),
              ),
              DropdownButtonFormField<String>(
                value: roleController.text,
                items: ['cashier', 'manager', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  roleController.text = newValue!;
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () async {
                bool success = await UpdateUserService().updateUser(
                  user.userId,
                  userNameController.text,
                  roleController.text,
                  usernameController.text,
                );

                Navigator.of(context).pop(); // Tutup dialog

                if (success) {
                  fetchAllUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User berhasil diperbarui')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui user')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus User'),
          content: Text('Apakah Anda yakin ingin menghapus user ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hapus'),
              onPressed: () async {
                bool success = await DeleteUserService().deleteUser(userId);

                Navigator.of(context).pop(); // Tutup dialog

                if (success) {
                  fetchAllUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User berhasil dihapus')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus user')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    TextEditingController userNameController = TextEditingController();
    TextEditingController roleController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController =
        TextEditingController(); // Tambahkan controller untuk password

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                decoration: InputDecoration(labelText: 'Nama User'),
              ),
              DropdownButtonFormField<String>(
                value: roleController.text.isEmpty ? null : roleController.text,
                items: ['cashier', 'manager', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  roleController.text = newValue!;
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () async {
                bool success = await AddUserService().addUser(
                  userNameController.text,
                  roleController.text,
                  usernameController.text,
                  passwordController.text,
                );

                Navigator.of(context).pop(); // Tutup dialog

                if (success) {
                  fetchAllUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User berhasil ditambahkan')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan user')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
