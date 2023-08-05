import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/pig_logo.png",width: MediaQuery.of(context).size.width*.3,),
          sizeVer(5),
          Text("Coin Saver",style: GoogleFonts.acme(fontSize: 35,color: Colors.white),)
        ],
      ),
    );
  }
}