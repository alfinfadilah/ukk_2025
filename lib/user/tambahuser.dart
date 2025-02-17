import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tambahuser extends StatefulWidget {
  const Tambahuser({super.key, required this.onAddUser});

  final Function(String,String) onAddUser;
  
  @override
  State<Tambahuser> createState() => _TambahuserState();
}

class _TambahuserState extends State<Tambahuser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SingleValueDropDownController _roleController = SingleValueDropDownController();

  Future<bool> cekNamauser(String namaBarang) async {
    final response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('Username', namaBarang).maybeSingle();
        return response != null;
  }

  Future<void> tambahuser(
      String username, String password, String role) async {
    try {
      bool exists = await cekNamauser(username);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('username sudah ada, pilih username lain')),
      );
      return;
    }
      final response = await Supabase.instance.client.from('user').insert([
        {'Username': username, 'Password': password, 'Role': role}
      ]);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF003366),
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
                    shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.lightBlue,
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'username tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: DropDownTextField(
                    controller: _roleController,
                    textFieldDecoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.remove_red_eye)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Role tidak boleh kosong';
                      }
                      return null;
                    },
                    dropDownItemCount: 1,
                    dropDownList: [
                      DropDownValueModel(name: 'petugas', value: 'petugas'),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
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
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();
                      final role =
                          _roleController.dropDownValue!.value;

                      if (username.isEmpty || password.isEmpty || role.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Username, Role dan Password tidak boleh kosong')),
                        );
                        return;
                      }
                      await tambahuser(username, password, role);
                    },
                    child: Text(
                      "Daftarkan",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}