import 'package:flutter/material.dart';
import 'join.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Walkthrough extends StatefulWidget {
  const Walkthrough({super.key});

  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  List pageInfos = [
    {
      "title": "Sen Taxi",
      "body": "Attachez vos ceintures et profitez du trajet !"
          " Bienvenue dans notre application de taxi, où la commodité rencontre le confort. "
          "Installez-vous, détendez-vous et laissez-nous conduire.",
      "img": "assets/f.jpg",
    },
    {
      "title": "Sunu Taxi",
      "body": "Découvrez un monde de transport sans faille à portée de main."
          "Préparez-vous à vous embarquer dans un voyage unique en son genre. "
          "Explorez la ville avec style et confort."
          "Votre destination, notre priorité.",
      "img": "assets/f.jpg",
    },
    {
      "title": "Sunu Taxi",
      "body": "Voyagez en toute tranquillité avec notre service de taxi."
          "Découvrez une expérience de voyage exceptionnelle."
          "Le moyen le plus rapide et fiable de vous déplacer en ville.",
      "img": "assets/f.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for (int i = 0; i < pageInfos.length; i++) _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IntroductionScreen(
            pages: pages,
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const JoinApp();
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const JoinApp();
                  },
                ),
              );
            },
            showSkipButton: true,
            skip: const Text("Skip"),
            next: const Text(
              "Suivant",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 246, 224, 26)),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item) {
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset("assets/f.jpg", height: 175.0),
      decoration: PageDecoration(
        titleTextStyle: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyTextStyle: const TextStyle(fontSize: 15.0),
//        dotsDecorator: DotsDecorator(
//          activeColor: Theme.of(context).accentColor,
//          activeSize: Size.fromRadius(8),
//        ),
        pageColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
