import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/common_widgets/tutorial_coach_dialogue.dart';
import 'package:gogobook/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../models/books.dart';

class HorizontalBooksBARList extends StatefulWidget {
  final List<Book> books;
  final String categoryName;
  final bool showBookmarkIcon;

  HorizontalBooksBARList({
    required this.books,
    required this.categoryName,
    this.showBookmarkIcon = false,
  });

  @override
  _HorizontalBooksListState createState() => _HorizontalBooksListState();
}

class _HorizontalBooksListState extends State<HorizontalBooksBARList> {
  ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey plusIcon = GlobalKey();
  // GlobalKey plusIcon = GlobalKey();


  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      checkUserStatus();
    });
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialCompleted = prefs.getBool('homepageTutorialCompleted') ?? false;

    if (!tutorialCompleted) {
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorial();
      });
    }
  }

  void _showTutorial() async {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Color(0xFFfab313),
      onFinish: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('homepageTutorialCompleted', true);
      },
    )..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: 'plus_icon',
        keyTarget: plusIcon,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'wizard1Text'.tr,
                onNext: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    tutorialCoachMark?.finish();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _showLeftArrow = _scrollController.position.pixels > 0;
      _showRightArrow = _scrollController.position.pixels <
          _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollTo(double offset) {
    _scrollController.jumpTo(offset);
  }

  void removeBookFromList(Book book) {
    setState(() {
      widget.books.remove(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.categoryName,
              style: const TextStyle(
                fontFamily: 'Sora',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ...widget.books.map(
              (book) => BookCardBAR(
                book: book,
                onBookmarkRemoved: () {
                  removeBookFromList(book);
                },
              ),
            ),
            if (widget.categoryName == 'Books Already Read' ||
                widget.categoryName == 'Libri già letti')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  child: Card(
                    color: const Color.fromRGBO(49, 51, 51, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(children: [
                      Container(
                        key: plusIcon,
                        width: 180,
                        height: 295,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                      Text(
                        'booksAlreadyReadButtonText'.tr,
                        style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}

class BookCardBAR extends StatefulWidget {
  final Book book;
  final VoidCallback? onBookmarkRemoved;

  BookCardBAR({required this.book, this.onBookmarkRemoved});

  @override
  _BookCardBookmarkState createState() => _BookCardBookmarkState();
}

class _BookCardBookmarkState extends State<BookCardBAR> {
  @override
  void initState() {
    super.initState();
  }

  void removeFromBooksAlreadyRead() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('BooksAlreadyRead')
          .doc(userId)
          .collection('books')
          .doc(widget.book.id)
          .delete()
          .then((value) {
        widget.onBookmarkRemoved?.call();
        setState(() {});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Success!',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Book removed successfully from the Books Already Read List.',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              actions: [
                firebaseUIButton(context, 'OK', () {
                  Navigator.of(context).pop();
                })
              ],
            );
          },
        );
      }).catchError((error) {
        // Handle the error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 51, 51, 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsBARScreen(book: widget.book),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.book.imageUrl,
                  width: 230,
                  height: 270,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title.length > 20
                            ? '${widget.book.title.substring(0, 20)}...'
                            : widget.book.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.book.authors.join(', ').length > 20
                            ? '${widget.book.authors.join(', ').substring(0, 20)}...'
                            : widget.book.authors.join(', '),
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Sora',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 255,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                  removeFromBooksAlreadyRead();
                },
                child: Icon(
                  Icons.add_circle,
                  color: Color(0xFFfab313),
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailsBARScreen extends StatefulWidget {
  final Book book;

  const BookDetailsBARScreen({required this.book});

  @override
  State<BookDetailsBARScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsBARScreen> {
  bool isBookmarked = false;
  bool isWishlisted = false;
  @override
  void initState() {
    super.initState();
  }

  void _launchAmazonUrl() async {
    // Replace the 'isbn' variable with the actual ISBN of the book
    String isbn = widget.book.isbn;

    // Check if the ISBN is valid
    if (isbn != null && isbn.isNotEmpty) {
      // Construct the Amazon search URL using the ISBN
      String searchUrl =
          'https://www.amazon.it/s?k=${Uri.encodeComponent(isbn)}';

      // Open the URL in a web browser
      await FlutterWebBrowser.openWebPage(
        url: searchUrl,
        customTabsOptions: CustomTabsOptions(
          toolbarColor: Colors.deepPurple,
          showTitle: true,
        ),
      );
    } else {
      // Handle error if the ISBN is null or empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid ISBN.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Details Screen',
        theme: themeChanger.currentTheme,
        home: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // First color
                Color(0xFF07abb8), // Second color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(alignment: Alignment.topRight, children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Image.network(
                            widget.book.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 30.0,
                          right: 8.0,
                          child: IconButton(
                            onPressed: () {
                              // final bookLink =
                              //     'https://books.google.com/books?id=${widget.book.id}';
                              Share.share(
                                  '${widget.book.title} written by ${widget.book.authors}: Check out this book on GoGoBook: Play store Link!');
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Color(0xFFfab313),
                              size: 40,
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const SelectableText(
                        'Title:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SelectableText(
                        widget.book.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SelectableText(
                        'Author:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SelectableText(
                        widget.book.authors.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SelectableText(
                            'Number of Pages:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Sora',
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          SelectableText(
                            '${widget.book.pageCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        const SelectableText(
                          'Language:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Sora',
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        SelectableText(
                          '${widget.book.language}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        const SelectableText(
                          'ISBN:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Sora',
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        SelectableText(
                          '${widget.book.isbn}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      const SelectableText(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SelectableText(
                        '${widget.book.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        const SelectableText(
                          'Publisher:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Sora',
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        SelectableText(
                          '${widget.book.publisher}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),

                      // Buy from affiliate link or other text links
                      GestureDetector(
                        onTap: () {
                          _launchAmazonUrl();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.shopping_basket,
                                color: Color(0xFFfab313),
                              ),
                              TextButton(
                                onPressed: () {
                                  _launchAmazonUrl();
                                },
                                child: const Text(
                                  'Buy this Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      );
    });
  }
}
