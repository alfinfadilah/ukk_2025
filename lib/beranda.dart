import 'package:flutter/material.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/user/user.dart';

class Beranda extends StatefulWidget {
  final Map user;
  const Beranda({super.key, required this.user});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {

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
                    leading: Icon(Icons.person_add),
                    title: Text('register petugas'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                         MaterialPageRoute(
                          builder: (context) => User(user: widget.user,)
                        )
                      );
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(Icons.person_search),
              title: Text('daftar pelanggan'),
              onTap: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => PelangganListPage(
                //             user: widget.user,
                //           )),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.pageview),
              title: Text('daftar penjualan'),
              onTap: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => Penjualan(
                //             login: widget.user,
                //           )),
                // );
              },
            ),
            ListTile(
              onTap: () {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Produk(user: widget.login)));
              },
              leading: Icon(Icons.shopping_cart),
              title: Text('Daftar Produk')
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
        title: Text(
          'Beranda'
        ),
      ),
      body: Center(
        child: Text(
          'Selamat Datang',
          style: TextStyle(
            fontSize: 30
          ),         
        ),
      ),
    );
  }
}