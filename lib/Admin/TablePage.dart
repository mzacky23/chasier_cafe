import 'package:chasier_cafe/Service/Admin/AddTable.dart';
import 'package:chasier_cafe/Service/Admin/ShowTable.dart';
import 'package:chasier_cafe/Service/Admin/DeleteTable.dart'; // Import service untuk menghapus meja
import 'package:chasier_cafe/Service/Admin/UpdateTable.dart'; // Import service untuk update meja
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  Future<List<TableData>>? futureTables;
  final AddTableService addTableService =
      AddTableService(); // Service untuk tambah meja
  final DeleteTableService deleteTableService =
      DeleteTableService(); // Service untuk hapus meja
  final UpdateTableService updateTableService =
      UpdateTableService(); // Service untuk update meja
  int? selectedTableIndex;

  @override
  void initState() {
    super.initState();
    futureTables = fetchTables(); // Memuat data meja saat inisialisasi
  }

  // Fungsi untuk menampilkan dialog tambah meja
  void _showAddTableDialog() {
    String tableNumber = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Meja'),
          content: TextField(
            onChanged: (value) {
              tableNumber = value;
            },
            decoration: InputDecoration(
              labelText: 'Nomor Meja',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Tambah'),
              onPressed: () async {
                // Cek apakah nomor meja sudah ada
                final tables = await futureTables;
                final exists =
                    tables?.any((table) => table.tableNumber == tableNumber) ??
                        false;

                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nomor meja sudah ada!')),
                  );
                  return;
                }

                // Tambah meja menggunakan AddTableService
                final success = await addTableService.addTable(tableNumber);
                Navigator.of(context).pop();

                if (success) {
                  setState(() {
                    futureTables = fetchTables(); // Perbarui daftar meja
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meja berhasil ditambahkan!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan meja!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog update meja
  void _showUpdateTableDialog(String tableId, String currentTableNumber) {
    String newTableNumber = currentTableNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Nomor Meja'),
          content: TextField(
            onChanged: (value) {
              newTableNumber = value;
            },
            decoration: InputDecoration(
              labelText: 'Nomor Meja Baru',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: currentTableNumber),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                if (newTableNumber.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nomor meja tidak boleh kosong!')),
                  );
                  return;
                }

                // Update meja menggunakan UpdateTableService
                final success = await updateTableService.updateTable(
                    tableId, newTableNumber);
                Navigator.of(context).pop();

                if (success) {
                  setState(() {
                    futureTables = fetchTables(); // Perbarui daftar meja
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Meja berhasil diupdate!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengupdate meja!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus meja
  void _deleteTable(String tableId) async {
    final success = await deleteTableService.deleteTable(tableId);
    if (success) {
      setState(() {
        futureTables =
            fetchTables(); // Memperbarui daftar meja setelah berhasil dihapus
        selectedTableIndex =
            null; // Reset selectedTableIndex setelah penghapusan
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meja berhasil dihapus!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus meja!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Meja'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[500],
      ),
      body: FutureBuilder<List<TableData>>(
        future: futureTables,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data meja.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada meja yang tersedia.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kelola Meja',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _showAddTableDialog,
                                icon: Icon(Icons.add),
                                label: Text('Tambah Meja'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final table = snapshot.data![index];
                              final isSelected = selectedTableIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTableIndex =
                                        (selectedTableIndex == index)
                                            ? null
                                            : index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: table.isAvailable
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: table.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.table_restaurant,
                                              size: 50,
                                              color: table.isAvailable
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Meja ${table.tableNumber}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 3,
                                          right: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  onPressed: () {
                                                    _showUpdateTableDialog(
                                                        table.tableId
                                                            .toString(),
                                                        table.tableNumber);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    _deleteTable(table.tableId
                                                        .toString());
                                                    setState(() {
                                                      selectedTableIndex =
                                                          null; // Reset selectedTableIndex setelah penghapusan
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
