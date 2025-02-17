import 'package:flutter/material.dart';
import 'package:ukk_2025/myhomepage.dart';

class SplashScreen extends StatefulWidget {
  final Map user;
  const SplashScreen({super.key,required this.user});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Myhome(
                  user: widget.user,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                child: Image.asset(
                  'assets/image/logo1.jpg',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Waroeng Pocjok",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
