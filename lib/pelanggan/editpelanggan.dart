import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Editpelanggan extends StatefulWidget {
  final Map pelanggan;
  const Editpelanggan({super.key, required this.pelanggan});

  @override
  State<Editpelanggan> createState() => _EditpelangganState();
}

class _EditpelangganState extends State<Editpelanggan> {

  Future<void> edit(String NamaPelanggan, String Alamat, String NomorTelepon, int id) async {
    final response = await Supabase.instance.client.from('pelanggan').update({
      'NamaPelanggan': NamaPelanggan,
      'Alamat': Alamat,
      'NomorTelepon': NomorTelepon,
    }).eq('PelangganID', id);

    if (response == null) {
      Navigator.pop(context, 'success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eror mengedit pelanggan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final TextEditingController _namapelangganController =
        TextEditingController(text: widget.pelanggan['NamaPelanggan']);
    final TextEditingController _alamatController =
        TextEditingController(text: '${widget.pelanggan['Alamat']}');
    final TextEditingController _notlpController =
        TextEditingController(text: '${widget.pelanggan['NomorTelepon']}');
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Pelanggan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 100,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _namapelangganController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'alamat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _notlpController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'no tlp tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          edit(
                              _namapelangganController.text,
                              _alamatController.text,
                              _notlpController.text,
                              widget.pelanggan['PelangganID']);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      child: const Text(
                        'Edit Pelanggan',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFFFAF3E0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}