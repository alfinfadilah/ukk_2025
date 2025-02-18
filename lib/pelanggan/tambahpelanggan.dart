import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Tambahpelanggan extends StatefulWidget {
  const Tambahpelanggan({super.key, required this.onAddpelanggan});

  final Function(String, String, String, String) onAddpelanggan;

  @override
  State<Tambahpelanggan> createState() => _TambahpelangganState();
}

class _TambahpelangganState extends State<Tambahpelanggan> {
  final TextEditingController _namapelangganController =
      TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _notlpController = TextEditingController();
  final SingleValueDropDownController _memberController = SingleValueDropDownController();

  Future<void> tambahpelanggan(
      String NamaPelanggan, String Alamat, String notlp, Member) async {
    try {
      await Supabase.instance.client.from('pelanggan').insert([
        {
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon': notlp,
          'Member' : Member
        }
      ]);
  
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFAF3E0),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.lightBlue,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _namapelangganController,
                    decoration: InputDecoration(
                        labelText: 'Nama Pelanggan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _alamatController,
                    decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.home)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _notlpController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.phone)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'no tlp tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: DropDownTextField(
                    controller: _memberController,
                    clearOption: true,
                    enableSearch: false,
                    dropDownList: [
                      DropDownValueModel(name: 'platinum', value: 'platinim'),
                      DropDownValueModel(name: 'gold', value: 'gold'),
                      DropDownValueModel(name: 'silver', value: 'silver'),
                      DropDownValueModel(name: 'non member', value: 'non member'),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih status keanggotaan';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                      });
                    },
                    textFieldDecoration: InputDecoration(
                      labelText: 'Keanggotaan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blue),
                    onPressed: () async {
                      final NamaPelanggan =
                          _namapelangganController.text.trim();
                      final Alamat = _alamatController.text.trim();
                      final NomorTelepon = _notlpController.text.trim();
                      final Member = _memberController.dropDownValue?.value;

                      if (NamaPelanggan.isEmpty ||
                          Alamat.isEmpty ||
                          NomorTelepon.isEmpty ||
                          Member == null || Member.isEmpty
                          ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                  'nama, alamat, dan no tlp tidak boleh kosong'
                            )
                          ),
                        );
                        return;
                        }
                      await tambahpelanggan(
                          NamaPelanggan, Alamat, NomorTelepon, Member);
                    },
                    child: Text(
                      "Tambah",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}