import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/beranda.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/editproduk.dart';
import 'package:ukk_2025/produk/tambahproduk.dart';
import 'package:ukk_2025/user/user.dart';

class Produk extends StatefulWidget {
  final Map user;

  const Produk({super.key, required this.user});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  List<Map<String, dynamic>> Barang = [];
  List<Map<String, dynamic>> User = [];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  var jenis = [
    null,
    'makanan',
    'minuman',
    'dissert',
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
    if (mounted) {
      initializeData();
    } else {
      timer.cancel();
    }
  });
  }

  Future<void> initializeData() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        Barang = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> tambah(
      String NamaProduk, String Harga, String Stok, String Jenis) async {
    final response = await Supabase.instance.client.from('produk').insert([
      {'NamaProduk': NamaProduk, 'Harga': Harga, 'Stok': Stok, 'Jenis': Jenis}
    ]);
    if (response == null) {
      initializeData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error add produk')),
      );
    }
  }

  Future<void> hapusBarang(int ProdukId) async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .delete()
          .eq('ProdukID', ProdukId);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil dihapus')),
        );
        initializeData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  GridView card([String? jenis]) {
    var filterData = Barang.where((item) {
    bool matchesJenis = jenis == null || item['Jenis'] == jenis;
    bool matchesSearch = item['NamaProduk'].toLowerCase().startsWith(_searchQuery);
    return matchesJenis && matchesSearch;
  }).toList();

    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 3.2,
      children: [
        ...List.generate(filterData.length, (index) {
          final barang = filterData[index];
          var iconBarang;
          if (barang['Jenis'] == 'makanan') {
            iconBarang = Icons.food_bank;
          } else if (barang['Jenis'] == 'minuman') {
            iconBarang = Icons.local_cafe;
          } else {
            iconBarang = Icons.cake;
          }
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: LayoutBuilder(builder: (context, constraint) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barang['NamaProduk'],
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 4),
                            ),
                            Text(
                              'RP ${barang['Harga']}',
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 6),
                            ),
                            Text(
                              'Stok ${barang['Stok']}',
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 6),
                            )
                          ]),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            editproduk(barang: barang)));
                                if (result == 'success') {
                                  initializeData();
                                }
                              },
                              icon: Icon(
                                size: constraint.maxHeight / 4,
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            initializeData();
                                            Navigator.pop(context, true);
                                          },
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true) {
                                  hapusBarang(barang['ProdukID']);
                                }
                              },
                              icon: Icon(
                                size: constraint.maxHeight / 4,
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        iconBarang,
                        size: constraint.maxHeight / 3,
                      ),
                    ],
                  ),
                );
              }));
        })
      ],
    );
  }

  var selectedIndex = 0;
  var _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 0, 26, 255),
                Colors.blue,
                Colors.lightBlue,
              ], begin: Alignment.topLeft)),
              accountName: Text(widget.user['Username'] ?? 'Unknow User'),
              accountEmail: Text('(${widget.user['Role']})'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 255, 252, 221),
                child: Text(
                  widget.user['Username'].toString().toUpperCase()[0],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            widget.user['Role'] == 'admin'
                ? ListTile(
                    leading: Icon(Icons.person_search),
                    title: Text('daftar petugas'),
                    onTap: () {
                      Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserListPage(
                            user: widget.user,
                          )),
                );
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(Icons.person_search),
              title: Text('daftar pelanggan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PelangganListPage(
                            user: widget.user,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pageview),
              title: Text('daftar penjualan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Penjualan(
                            login: widget.user,
                          )),
                );
              },
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Beranda'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Beranda(user: widget.user,)),
                  );
                },
              ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: "Cari Produk",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true),
        ),
        actions: [
          IconButton(
            onPressed: initializeData,
            icon: const Icon(Icons.refresh),
            color: Color(0xFFFAF3E0),
          ),
        ],
      ),
      body: Column(
        children: [
          SlidingClippedNavBar(
            onButtonPressed: (index) {
              setState(() {
                selectedIndex = index;
              });
              _controller.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            activeColor: Colors.deepOrange,
            barItems: [
              BarItem(
                title: "Seller",
                icon: Icons.sell,
              ),
              BarItem(
                title: "Makanan",
                icon: Icons.food_bank,
              ),
              BarItem(
                title: "Minuman",
                icon: Icons.local_cafe,
              ),
              BarItem(
                title: "Dissert",
                icon: Icons.cake,
              ),
            ],
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                card(),
                card('makanan'),
                card('minuman'),
                card('dissert'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF003366), 
      ),
    );
  }

  _showAddDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Tambahproduk(onAddBarang: (Namaproduk, Harga, Stok, Jenis) {
          tambah(Namaproduk, Harga, Stok, Jenis);
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      initializeData();
    }
  }
}