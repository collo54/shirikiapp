import 'package:flutter/material.dart';
import 'package:shiriki/models/user_model.dart';

import '../constants/colors.dart';
import '../screens/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kwhite25525525510,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HomeScreen(),
          ],
        ),
      ),
    );
  }
}
