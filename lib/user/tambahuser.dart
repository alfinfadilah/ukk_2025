import 'package:flutter/material.dart';

class Tambahuser extends StatefulWidget {
  const Tambahuser({super.key, required this.onAddUser});

  final Function(String,String) onAddUser;
  
  @override
  State<Tambahuser> createState() => _TambahuserState();
}

class _TambahuserState extends State<Tambahuser> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}