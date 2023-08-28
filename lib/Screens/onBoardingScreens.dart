import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingScreens extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Colors.black,
              Color(0xFF07abb8),
            ],
          ),
        ),
      ),
      bubble: Image.asset('assets/images/GOGOBOOK_rast.png'),
      body: const Text(
        'Tap the plus sign to add books to your \"Already Read\" list.',
      ),
      title: const Text(
        'Welcome to GoGoBook',
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: Image.asset(
        'assets/images/home.jpeg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Colors.black,
              Color(0xFF8BC34A),
            ],
          ),
        ),
      ),
      iconImageAssetPath: 'assets/images/GOGOBOOK_rast.png',
      body: const Text(
        'Discover and read your favorite books by scanning barcodes or search in search bar.',
      ),
      title: const Text('GoGoBook - Search Books'),
      mainImage: Image.asset(
        'assets/images/search.jpeg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Colors.black,
              Color(0xFFfab313),
            ],
          ),
        ),
      ),
      iconImageAssetPath: 'assets/images/GOGOBOOK_rast.png',
      body: const Text(
        'Tap on the \"Recommend me a Book\" button to Recommend you a book.',
      ),
      title: const Text('GoGoBook - Recommend me a Book'),
      mainImage: Image.asset(
        'assets/images/recommend 2.jpeg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen3(onLogout: () {})),
            );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
