import 'package:flutter/material.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/produk.dart';
import 'package:ukk_2025/user/user.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class Beranda extends StatefulWidget {
  final Map user;
  const Beranda({super.key, required this.user});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  Map<String, double> salesData = {};
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

  Future<void> _getSalesData() async {
    try {
      final List<String> dates = List.generate(
          7,
          (index) => DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: index))));

      final response = await Supabase.instance.client
          .from('penjualan')
          .select('TanggalPenjualan, TotalHarga')
          .inFilter('TanggalPenjualan', dates);

      setState(() {
        salesData = {
          for (var date in dates.reversed) date: 0.0
        }; // Urutkan tanggal dari yang terlama
        for (var item in response) {
          salesData[item['TanggalPenjualan']] =
              (salesData[item['TanggalPenjualan']] ?? 0) +
                  (item['TotalHarga'] as int);
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getTotalHariIni();
    _getSalesData();
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
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Total Penjualan Hari Ini: Rp $_totalHariIni',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  width: 300,
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final formatter = NumberFormat(
                                    '#.###');
                                return Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    'Rp${formatter.format((value * 1000).toInt())}', // Format nilai dengan koma
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                              reservedSize: 100, // Lebar sumbu Y
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < salesData.length) {
                                  String date = salesData.keys.elementAt(index);
                                  return Text(
                                    DateFormat('EEE').format(DateTime.parse(
                                        date)), // "Sen", "Sel", dll.
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: salesData.entries
                                .toList()
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(),
                                    (e.value.value / 1000)
                                        .clamp(0, double.infinity)))
                                .toList(),
                            isCurved: false,
                            color: Colors.blue,
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
