import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        title: AppLocalizations.of(context)!.welcomePageTitle1,
        body: AppLocalizations.of(context)!.welcomePageBody1,
        image: Image.asset(
          "assets/page1.jpg",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.welcomePageTitle2,
        body: AppLocalizations.of(context)!.welcomePageBody2,
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
        title: AppLocalizations.of(context)!.welcomePageTitle3,
        body: AppLocalizations.of(context)!.welcomePageBody3,
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
        skip:  Text(AppLocalizations.of(context)!.skip),
        done:  Text(AppLocalizations.of(context)!.done),
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
