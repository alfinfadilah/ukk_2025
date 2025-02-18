import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/beranda.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/produk.dart';
import 'package:ukk_2025/user/edituser.dart';
import 'package:ukk_2025/user/tambahuser.dart';


class UserListPage extends StatefulWidget {
  final Map user;
  const UserListPage({super.key, required this.user});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> user = [];
  List<Map<String, dynamic>> User = [];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialis();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
    if (mounted) {
      initialis();
    } else {
      timer.cancel();
    }
  });
  }

  Future<void> initialis() async {
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> hapususer(String Username) async {
    try {
      final response = await Supabase.instance.client
          .from('user')
          .delete()
          .eq('Username', Username);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User berhasil dihapus')),
        );
        initialis();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus user: $e')),
      );
    }
  }

  Future<void> tambahuser(String username, String password) async {
    try {
      final response = await Supabase.instance.client.from('user').insert([
        {
          'Username': username,
          'Password': password,
        }
      ]);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
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
                hintText: "Cari Petugas",
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
          actions: [
            IconButton(
              onPressed: initialis,
              icon: const Icon(Icons.refresh),
              color: Color(0xFFFAF3E0),
            ),
          ],
        ),
        body: user.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: user.where((user) {
                  final username = user['Username']?.toLowerCase() ?? '';
                  return username.startsWith(_searchQuery);
                }).length,
                itemBuilder: (context, index) {
                  final filtereduser = user.where((user) {
                    final nama =
                        user['Username']?.toLowerCase() ?? '';
                    return nama.startsWith(_searchQuery);
                  }).toList();

                  final petugas = filtereduser[index];

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
                        petugas['Username'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            petugas['Role'] ?? 'No Role',
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
                                            builder: (context) => Edituser(
                                                user: petugas,)));
                                    if (result == 'success') {
                                      initialis();
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
                                              'Apakah Anda yakin ingin menghapus user ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                initialis();
                                                Navigator.pop(context, true);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      hapususer(petugas['Username']);
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
                  _AddUser(context);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: const Color(0xFF003366),
              )
            : null);
  }

  void _AddUser(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Tambahuser(onAddUser: (
          Username,
          Password,
        ) {
          tambahuser(
            Username,
            Password,
          );
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      initialis();
    }
  }
}