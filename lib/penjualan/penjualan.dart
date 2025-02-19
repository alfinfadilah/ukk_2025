import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/beranda.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/cetak.dart';
import 'package:ukk_2025/penjualan/tambahpenjualan.dart';
import 'package:ukk_2025/produk/produk.dart';
import 'package:ukk_2025/user/user.dart';

class Penjualan extends StatefulWidget {
  final Map login;
  const Penjualan({super.key, required this.login});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> with TickerProviderStateMixin {
  TabController? myTabControl;
  List penjualan = [];
  List detailPenjualan = [];
  List produk = [];
  List pelanggan = [];
  List user = [];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  void fetchSales() async {
    var myProduk = await Supabase.instance.client
        .from('produk')
        .select()
        .order('ProdukID', ascending: true);
    var myCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('PelangganID', ascending: true);
    var myuser =
        await Supabase.instance.client.from('user').select().order('Username');

    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*), user(*)');
    var responseSalesDetail = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*, penjualan(*, pelanggan(*), user(*)), produk(*)');
    setState(() {
      penjualan = responseSales;
      detailPenjualan = responseSalesDetail;
      produk = myProduk;
      pelanggan = myCustomer;
      user = myuser;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSales();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    myTabControl = TabController(length: 2, vsync: this);
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        fetchSales();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    myTabControl?.dispose();
  }

  generateSales() {
    var filteredSales = penjualan.where((sale) {
      var tanggalPenjualan = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(sale['TanggalPenjualan']));
      return _searchQuery.isEmpty || tanggalPenjualan.contains(_searchQuery);
    }).toList();
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(filteredSales.length, (index) {
          var tanggalPenjualan = DateFormat(
            'dd MMMM yyyy',
          ).format(DateTime.parse(filteredSales[index]['TanggalPenjualan']));
          var diskon = filteredSales[index]['Diskon'] ?? 0;
          return Card(
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(penjualan[index]['PelangganID'] == null
                              ? 'Pelanggan tidak terdaftar'
                              : '${penjualan[index]['pelanggan']['NamaPelanggan']} (${penjualan[index]['pelanggan']['NomorTelepon']}) (${penjualan[index]['pelanggan']['Member']})')
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.rupiahSign,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text('${penjualan[index]['TotalHarga']}')
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.percentage),
                          SizedBox(width: 30),
                          Text(diskon > 0
                              ? 'Diskon: ${diskon}'
                              : 'Tidak ada diskon')
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendar,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text('${tanggalPenjualan}')
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 30,
                          ),
                          Text(penjualan[index]['Username'] == null
                              ? ''
                              : '${penjualan[index]['user']['Username']}')
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.print),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfGenerator(
                                      cetak: widget.login,
                                      penjualanId: penjualan[index]
                                              ['PenjualanID']
                                          .toString(),
                                    )),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  generateSalesDetail() {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 1.5,
      children: [
        ...List.generate(detailPenjualan.length, (index) {
          var tanggalPenjualan = DateFormat('dd MMMM yyyy').format(
              DateTime.parse(
                  detailPenjualan[index]['penjualan']['TanggalPenjualan']));
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 10,
                    ),
                    Text(detailPenjualan[index]['penjualan']['PelangganID'] ==
                            null
                        ? 'Pelanggan tidak terdaftar'
                        : '${detailPenjualan[index]['penjualan']['pelanggan']['NamaPelanggan']} (${detailPenjualan[index]['penjualan']['pelanggan']['NomorTelepon']}) (${detailPenjualan[index]['penjualan']['pelanggan']['Member']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.cartShopping),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${detailPenjualan[index]['produk']['NamaProduk']} (${detailPenjualan[index]['JumlahProduk']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.rupiahSign),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${detailPenjualan[index]['Subtotal']}'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${tanggalPenjualan}'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 30,
                    ),
                    Text(detailPenjualan[index]['Username'] == null
                        ? ''
                        : '${detailPenjualan[index]['penjualan']['user']['Username']}')
                  ],
                )
              ],
            ),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        appBar: AppBar(
          // ),
          centerTitle: true,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: "Cari Riwayat Penjualan",
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF003366),
        ),
        drawer: Drawer(
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
              accountName: Text(widget.login['Username'] ?? 'Unknow User'),
              accountEmail: Text('(${widget.login['Role']})'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 255, 252, 221),
                child: Text(
                  widget.login['Username'].toString().toUpperCase()[0],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            widget.login['Role'] == 'admin'
                ? ListTile(
                    leading: Icon(Icons.person_search),
                    title: Text('daftar petugas'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListPage(
                                  user: widget.login,
                                )),
                      );
                    },
                  )
                : SizedBox(),
            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PelangganListPage(user: widget.login)));
                },
                leading: Icon(Icons.person_search),
                title: Text('Daftar Pelanggan')),
            ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Produk(user: widget.login)));
                },
                leading: Icon(Icons.shopping_cart),
                title: Text('Daftar Produk')),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Beranda(
                            user: widget.login,
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        )),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Sales'),
                Tab(text: 'Sales Detail'),
              ],
              controller: myTabControl,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  penjualan.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : generateSales(),
                  detailPenjualan.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : generateSalesDetail()
                ],
                controller: myTabControl,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var jual = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SalesPage(
                          produk: produk,
                          pelanggan: pelanggan,
                          login: widget.login,
                          user: user,
                        )));
            if (jual == 'success') {
              fetchSales();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFF003366),
        ));
  }
}
