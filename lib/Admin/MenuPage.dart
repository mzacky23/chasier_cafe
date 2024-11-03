import 'package:flutter/material.dart';
import 'package:chasier_cafe/Service/Admin/ShowMenu.dart';
import 'package:chasier_cafe/Service/Admin/AddMenu.dart';
import 'package:chasier_cafe/Service/Admin/DeleteMenu.dart';
import 'package:chasier_cafe/Service/Admin/UpdateMenu.dart';
import 'package:image_picker/image_picker.dart'; // Import UpdateMenu

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Menu>> futureMenus;

  @override
  void initState() {
    super.initState();
    futureMenus = MenuService().fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[500],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddMenuDialog();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Tambah Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Menu>>(
              future: futureMenus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada menu ditemukan.'));
                }

                List<Menu> menus = snapshot.data!;

                return ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    return Card(
                      margin: EdgeInsets.all(4),
                      child: ExpansionTile(
                        leading: Image.network(
                          menu.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        title: Text(menu.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(menu.type),
                            Text(menu.description),
                            Text('Rp ${menu.price}'),
                          ],
                        ),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    editMenu(menu);
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    bool success =
                                        await DeleteMenu().deleteMenu(menu.id);
                                    if (success) {
                                      setState(() {
                                        futureMenus = MenuService()
                                            .fetchMenus(); // Refresh list after delete
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Gagal menghapus menu')),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text('Hapus'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMenuDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    String selectedType = 'Food'; // Default value for type
    String? imagePath; // Variabel untuk menyimpan path gambar yang dipilih

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Menu'),
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: 'Food',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: 'Drink',
                    child: Text('Minuman'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipe'),
              ),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              // Tombol untuk memilih gambar
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    imagePath = image.path; // Simpan path gambar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Gambar dipilih: ${image.name}')));
                  }
                },
                child: Text('Pilih Gambar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                // Call AddMenu API
                final addMenuService = AddMenu();
                bool success = await addMenuService.addMenu(
                  nameController.text,
                  selectedType, // Use the selected type
                  descriptionController.text,
                  int.parse(priceController.text),
                  imagePath ?? '', // Gunakan path gambar yang dipilih
                );

                if (success) {
                  Navigator.of(context).pop(); // Close the dialog
                  // Refresh the menu list
                  setState(() {
                    futureMenus =
                        MenuService().fetchMenus(); // Refresh the menu
                  });
                } else {
                  // Handle failure (you can show a Snackbar or AlertDialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan menu')),
                  );
                }
              },
              child: Text('Tambahkan'),
            ),
          ],
        );
      },
    );
  }

  void editMenu(Menu menu) {
    final TextEditingController nameController =
        TextEditingController(text: menu.name);
    final TextEditingController descriptionController =
        TextEditingController(text: menu.description);
    final TextEditingController priceController =
        TextEditingController(text: menu.price.toString());

    // Gunakan default value 'Food' jika selectedType null
    String selectedType =
        menu.type.isNotEmpty && (menu.type == 'Food' || menu.type == 'Drink')
            ? menu.type
            : 'Food'; // Defaultkan ke 'Food' jika tidak sesuai

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Menu'),
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: 'Food',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: 'Drink',
                    child: Text('Minuman'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipe'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                // Tambahkan validasi data
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    selectedType.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mohon lengkapi semua data')),
                  );
                  return;
                }

                // Panggil API UpdateMenu
                final updateMenuService = UpdateMenu();
                bool success = await updateMenuService.updateMenu(
                  menu.id,
                  nameController.text,
                  selectedType,
                  descriptionController.text,
                  int.parse(priceController.text),
                  '', // Gambar opsional
                );

                if (success) {
                  Navigator.of(context).pop(); // Tutup dialog
                  // Refresh daftar menu
                  setState(() {
                    futureMenus = MenuService().fetchMenus();
                  });
                } else {
                  // Tampilkan pesan gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui menu')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
