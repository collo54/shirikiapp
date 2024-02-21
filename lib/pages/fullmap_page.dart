import 'package:flutter/material.dart';
import 'package:shiriki/screens/fullmap_screen.dart';

import '../constants/colors.dart';

class FullMapPage extends StatelessWidget {
  const FullMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kwhite25525525510,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FullMapScreen(),
          ],
        ),
      ),
    );
  }
}
