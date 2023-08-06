import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      splash: const SplashImage(),
      duration: 700,
      curve: Curves.fastEaseInToSlowEaseOut,
      splashTransition: SplashTransition.sizeTransition,
      splashIconSize: 250,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: const Color(0xff095d9e),
      screenRouteFunction: () async {
        return PageConst.homePage;
      },
    );
  }
}

class SplashImage extends StatelessWidget {
  const SplashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/pig_logo.png",
            width: MediaQuery.of(context).size.width * .3,
          ),
          sizeVer(5),
          Text(
            "Coin Saver",
            style: GoogleFonts.acme(fontSize: 35, color: Colors.white),
          )
        ],
      ),
    );
  }
}
