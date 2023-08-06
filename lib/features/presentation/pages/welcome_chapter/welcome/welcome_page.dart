import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
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
        title: AppLocalizations.of(context)!.welcomePageTitle1,
        body: AppLocalizations.of(context)!.welcomePageBody1,
        image: SvgPicture.asset(
          "assets/svg/page1.svg",
          width: MediaQuery.of(context).size.width * .65,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.welcomePageTitle2,
        body: AppLocalizations.of(context)!.welcomePageBody2,
        image: SvgPicture.asset(
          "assets/svg/page2.svg",
          width: MediaQuery.of(context).size.width * .8,
          fit: BoxFit.cover,
        ),
        decoration: const PageDecoration(),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.welcomePageTitle3,
        body: AppLocalizations.of(context)!.welcomePageBody3,
        image: SvgPicture.asset(
          width: MediaQuery.of(context).size.width * .9,
          "assets/svg/page3.svg",
          fit: BoxFit.cover,
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
        skip: Text(AppLocalizations.of(context)!.skip),
        done: Text(AppLocalizations.of(context)!.done),
        onDone: () async {
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
