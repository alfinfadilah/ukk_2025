import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/myhomepage.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://rrgtmodwehspujtdshmi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJyZ3Rtb2R3ZWhzcHVqdGRzaG1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDkyOTEsImV4cCI6MjA1NDk4NTI5MX0.ECZghVbyNtVKDEgO473EjWa83eVr82OXACXQpXwqQ6Q'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Myhome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
