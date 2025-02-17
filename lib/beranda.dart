import 'package:flutter/material.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/produk.dart';
import 'package:ukk_2025/user/user.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Beranda extends StatefulWidget {
  final Map user;
  const Beranda({super.key, required this.user});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _totalHariIni = 0;

  Future<void> _getTotalHariIni() async {
    try {
      String todayStart =
          DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
      String tomorrowStart = DateFormat('yyyy-MM-dd 00:00:00')
          .format(DateTime.now().add(Duration(days: 1)));

      final response = await Supabase.instance.client
          .from('penjualan')
          .select('TotalHarga')
          .gte('TanggalPenjualan', todayStart)
          .lt('TanggalPenjualan', tomorrowStart);

      print('Response dari Supabase: $response');

      if (response.isNotEmpty) {
        int total = 0;
        for (var item in response) {
          total += item['TotalHarga'] as int;
        }
        setState(() {
          _totalHariIni = total;
        });
      } else {
        print('Tidak ada transaksi hari ini');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getTotalHariIni();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAF3E0),
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
                                    )));
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
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Produk(user: widget.user)));
                  },
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Daftar Produk')),
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
          title: Text('Beranda'),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ClipOval(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 5)),
                    child: Image.asset(
                      'assets/image/logo1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Selamat Datang Di Kasir Waroeng Pocjok',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Siap melayani pesanan anda',
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                  'Total Penjualan Hari Ini: Rp $_totalHariIni',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
