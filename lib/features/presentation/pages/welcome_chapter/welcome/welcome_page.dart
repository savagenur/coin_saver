import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pageViewModels = [
      PageViewModel(
        title: "Welcome to Coin Saver - Your Financial Companion!",
        body:
            "Welcome to Coin Saver, your ultimate financial companion. Powered by Flutter, our app provides a seamless and user-friendly experience for managing your finances effortlessly.",
        image: Image.asset(
          "assets/page1.jpg",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      PageViewModel(
        title: "Financial Freedom Made Simple",
        body:
            "Experience financial freedom with Coin Saver. Track expenses, set goals, and watch your savings grow. Our intuitive interface caters to users of all levels of financial expertise.",
        image: SizedBox(
          child: Image.asset(
            "assets/page2.jpg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        decoration: const PageDecoration(),
      ),
      PageViewModel(
        title: "Security at Its Best",
        body:
            "Your security is our priority. With robust encryption technology, Coin Saver keeps your financial data safe and confidential. Trust us to safeguard your privacy as you focus on your financial journey.",
        image: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/page3.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
    return SafeArea(
      child: IntroductionScreen(
        key: _introKey,
        pages: pageViewModels.map((e) => e).toList(),
        showNextButton: false,
        showSkipButton: true,
        back: const Icon(FontAwesomeIcons.arrowLeft),
        skip: const Text("Skip"),
        done: const Text("Done"),
        onDone: () {
          Navigator.pushNamedAndRemoveUntil(
              context, PageConst.chooseDefaultCurrencyPage, (route) => false);
        },
        onSkip: () {
          _introKey.currentState?.next();
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
