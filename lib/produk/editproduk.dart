import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class editproduk extends StatefulWidget {
  final Map barang;
  const editproduk({super.key, required this.barang});

  @override
  State<editproduk> createState() => _editprodukState();
}

class _editprodukState extends State<editproduk> {
  Future<void> edit(String NamaProduk, String Harga, String Stok, String Jenis,
      int id) async {
    final response = await Supabase.instance.client.from('produk').update({
      'NamaProduk': NamaProduk,
      'Harga': Harga,
      'Stok': Stok,
      'Jenis': Jenis
    }).eq('ProdukID', id);

    if (response == null) {
      Navigator.pop(context, 'success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eror mengedit produk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final TextEditingController _namaprodukController =
        TextEditingController(text: widget.barang['NamaProduk']);
    final TextEditingController _hargaController =
        TextEditingController(text: '${widget.barang['Harga']}');
    final TextEditingController _stokController =
        TextEditingController(text: '${widget.barang['Stok']}');
    final SingleValueDropDownController _jenisController =
        SingleValueDropDownController(
            data: DropDownValueModel(
                name: widget.barang['Jenis'], value: widget.barang['Jenis']));
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Produk',
          style: TextStyle(color: Colors.white, fontSize: 20),
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
                      controller: _namaprodukController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Produk',
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
                      controller: _hargaController,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'harga tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _stokController,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: DropDownTextField(
                      controller: _jenisController,
                      textFieldDecoration: const InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis tidak boleh kosong';
                        }
                        return null;
                      },
                      dropDownItemCount: 3,
                      dropDownList: [
                        DropDownValueModel(name: 'makanan', value: 'makanan'),
                        DropDownValueModel(name: 'minuman', value: 'minuman'),
                        DropDownValueModel(name: 'dissert', value: 'dissert'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          edit(
                              _namaprodukController.text,
                              _hargaController.text,
                              _stokController.text,
                              _jenisController.dropDownValue?.value,
                              widget.barang['ProdukID']);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      child: const Text(
                        'Edit Produk',
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