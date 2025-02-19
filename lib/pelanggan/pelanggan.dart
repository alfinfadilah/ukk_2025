import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/beranda.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/editpelanggan.dart';
import 'package:ukk_2025/pelanggan/tambahpelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/produk.dart';
import 'package:ukk_2025/user/user.dart';

class PelangganListPage extends StatefulWidget {
  final Map user;
  const PelangganListPage({super.key, required this.user});

  @override
  State<PelangganListPage> createState() => _PelangganListPageState();
}

class _PelangganListPageState extends State<PelangganListPage> {
  List<Map<String, dynamic>> Pelanggan = [];
  List<Map<String, dynamic>> User = [];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
    if (mounted) {
      fetch();
    } else {
      timer.cancel();
    }
  });
  }

  Future<void> fetch() async {
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        Pelanggan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> tambahpelanggan(
      String NamaPelanggan, String Alamat, String NomorTelepon, String Member) async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').insert([
        {
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon': NomorTelepon,
          'Member' : Member
        }
      ]);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi tidak berhasil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $Error')),
      );
    }
  }

  Future<void> hapuspelanggan(int PelangganId) async {
    try {
      final response = await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', PelangganId);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil dihapus')),
        );
        fetch();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

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
                leading: Icon(Icons.shopping_cart),
                title: Text('daftar produk'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Produk(
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
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: "Cari Pelanggan",
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
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
        body: Pelanggan.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: Pelanggan.where((pelanggan) {
                  final nama = pelanggan['NamaPelanggan']?.toLowerCase() ?? '';
                  final alamat = pelanggan['Alamat']?.toLowerCase() ?? '';
                  final nomor = pelanggan['NomorTelepon']?.toLowerCase() ?? '';
                  final member = pelanggan['Member']?.toLowerCase() ?? '';
                  return nama.startsWith(_searchQuery) ||
                      alamat.contains(_searchQuery) ||
                      nomor.startsWith(_searchQuery) ||
                      member.contains(_searchQuery) 
                      ;
                }).length,
                itemBuilder: (context, index) {
                  final filteredPelanggan = Pelanggan.where((pelanggan) {
                    final nama =
                        pelanggan['NamaPelanggan']?.toLowerCase() ?? '';
                    final alamat = pelanggan['Alamat']?.toLowerCase() ?? '';
                    final nomor =
                        pelanggan['NomorTelepon']?.toLowerCase() ?? '';
                        final member =
                        pelanggan['Member']?.toLowerCase() ?? '';
                    return nama.contains(_searchQuery) ||
                        alamat.contains(_searchQuery) ||
                        nomor.startsWith(_searchQuery) ||
                        member.startsWith(_searchQuery);
                  }).toList();

                  final pelanggan = filteredPelanggan[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                          color: Color(0xFF003366),
                          width: 1),
                    ),
                    child: ListTile(
                      title: Text(
                        pelanggan['NamaPelanggan'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pelanggan['Alamat'] ?? 'No Alamat',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            pelanggan['NomorTelepon'] ?? 'No Nomor',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            pelanggan['Member'] ?? 'Non Member',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.user['Role'] == 'admin'
                              ? IconButton(
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Editpelanggan(
                                                pelanggan: pelanggan)));
                                    if (result == 'success') {
                                      fetch();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ))
                              : SizedBox(),
                          widget.user['Role'] == 'admin'
                              ? IconButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus pelanggan ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                fetch();
                                                Navigator.pop(context, true);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      hapuspelanggan(pelanggan['PelangganID']);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                }),
        floatingActionButton: widget.user['Role'] == 'admin'
            ? FloatingActionButton(
                onPressed: () {
                  _AddPelanggan(context);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: const Color(0xFF003366),
              )
            : null);
  }

  void _AddPelanggan(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Tambahpelanggan(
            onAddpelanggan: (NamaPelanggan, Alamat, NomorTelepon, Member) {
          tambahpelanggan(NamaPelanggan, Alamat, NomorTelepon, Member);
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      fetch();
    }
  }
}