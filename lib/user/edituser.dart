import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Edituser extends StatefulWidget {
  final Map user;
  const Edituser({super.key, required this.user});

  @override
  State<Edituser> createState() => _EdituserState();
}

class _EdituserState extends State<Edituser> {
  Future<void> edit(String username, String password, String id) async {
    final response = await Supabase.instance.client.from('user').update({
      'Username': username,
      'Password': password,
    }).eq('Username', id);

    if (response == null) {
      Navigator.pop(context, 'success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eror mengedit petugas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey();
    final TextEditingController _usernameController = TextEditingController(text: widget.user['Username']);
    final TextEditingController _passwordController = TextEditingController(text: '${widget.user['Password']}');

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
          'Edit Petugas',
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
                    child: Container(
                      height: 100,
                      width: 100,
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
                  ),
                  SizedBox(height: 50,),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
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
                              _usernameController.text,
                              _passwordController.text,
                              widget.user['Username']);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      child: const Text(
                        'Edit Petugas',
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