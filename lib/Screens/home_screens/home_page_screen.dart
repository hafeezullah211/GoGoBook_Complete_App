import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/home_screens/banner_home.dart';
import 'package:gogobook/Screens/home_screens/horizontal_view_BAR.dart';
import 'package:gogobook/Screens/home_screens/horizontal_view_Recommeded.dart';
import 'package:gogobook/Screens/home_screens/horizontal_view_bookmarked.dart';
import 'package:gogobook/Screens/home_screens/horizontal_view_wishlist.dart';
import 'package:gogobook/Screens/home_screens/profile_screen.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../common_widgets/button.dart';
import '../../models/books.dart';
import '../../theme_changer.dart';
import '../theme_floating_action_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  late BannerAd _bannerAd;
  bool isAdLoaded = false;
  var adUnit = 'ca-app-pub-3940256099942544/6300978111'; //testing ad id
  ScrollController _scrollController = ScrollController();
  List<Book> bookmarkedBooksList = [];
  List<Book> wishlistBooksList = [];
  List<Book> booksAlreadyReadBooksList = [];
  List<Book> RecommendedBooksList = [];
  late PageController _pageController;


  late StreamSubscription<QuerySnapshot> bookmarkedBooksListener;
  late StreamSubscription<QuerySnapshot> wishlistBooksListener;
  late StreamSubscription<QuerySnapshot> booksAlreadyReadBooksListener;
  late StreamSubscription<DocumentSnapshot> recommendedBooksListener;

  initBannerAd(){
    _bannerAd = BannerAd(size: AdSize.fullBanner, adUnitId: adUnit, listener: BannerAdListener(
      onAdLoaded: (ad){
        setState(() {
          isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error){
        ad.dispose();
        print(error);
    }
    ), request: AdRequest());

    _bannerAd.load();
  }

  void fetchBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .snapshots();
        bookmarkedBooksListener = bookmarkedBooksSnapshot.listen((snapshot) {
          final bookmarkedBooks = snapshot.docs
              .map((doc) => Book(
                    id: doc.id,
                    imageUrl: doc['imageUrl'],
                    title: doc['title'],
                    authors: List<String>.from(doc['authors']),
                    description: doc['description'],
                    publisher: doc['publisher'],
                    publishedDate: doc['publishDate'].toDate(),
                    pageCount: doc['pagesCount'],
                    language: doc['language'],
                    isbn: doc['isbn'],
                    averageRating: doc['averageRating'],
                    ratingsCount: doc['ratingsCount'],
                  ))
              .toList();

          setState(() {
            bookmarkedBooksList = bookmarkedBooks;
          });
        });
      }
    } catch (e) {
      print('Failed to fetch bookmarks: $e');
      // Handle error
    }
  }

  void fetchWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('Wishlist')
            .doc(userId)
            .collection('books')
            .snapshots();

        wishlistBooksListener = bookmarkedBooksSnapshot.listen((snapshot) {
          final wishlistBooks = snapshot.docs
              .map((doc) => Book(
                    id: doc.id,
                    imageUrl: doc['imageUrl'],
                    title: doc['title'],
                    authors: List<String>.from(doc['authors']),
                    description: doc['description'],
                    publisher: doc['publisher'],
                    publishedDate: doc['publishDate'].toDate(),
                    pageCount: doc['pagesCount'],
                    language: doc['language'],
                    isbn: doc['isbn'],
                    averageRating: doc['averageRating'],
                    ratingsCount: doc['ratingsCount'],
                  ))
              .toList();

          setState(() {
            wishlistBooksList = wishlistBooks;
          });
        });
      }
    } catch (e) {
      print('Failed to fetch Wishlist Books: $e');
      // Handle error
    }
  }

  bool showRecommendedBooks = false;

  void fetchBooksAlreadyReadlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('BooksAlreadyRead')
            .doc(userId)
            .collection('books')
            .snapshots();

        booksAlreadyReadBooksListener =
            bookmarkedBooksSnapshot.listen((snapshot) {
          final booksAlreadyReadBooks = snapshot.docs
              .map((doc) => Book(
                    id: doc.id,
                    imageUrl: doc['imageUrl'],
                    title: doc['title'],
                    authors: List<String>.from(doc['authors']),
                    description: doc['description'],
                    publisher: doc['publisher'],
                    publishedDate: doc['publishDate'].toDate(),
                    pageCount: doc['pagesCount'],
                    language: doc['language'],
                    isbn: doc['isbn'],
                    averageRating: doc['averageRating'],
                    ratingsCount: doc['ratingsCount'],
                  ))
              .toList();

          setState(() {
            booksAlreadyReadBooksList = booksAlreadyReadBooks;
            if (booksAlreadyReadBooksList.isNotEmpty) {
              showRecommendedBooks = true;
            } else {
              showRecommendedBooks = false;
            }
          });
        });
      }
    } catch (e) {
      print('Failed to fetch Wishlist Books: $e');
      // Handle error
    }
  }

  void fetchRecommendedBooksList() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final recommendedBooksSnapshot = await FirebaseFirestore.instance
            .collection('Recommendations')
            .doc(userId)
            .snapshots();

        recommendedBooksListener = recommendedBooksSnapshot.listen((snapshot) {
          if (snapshot.exists) {
            final recommendedBooksData = snapshot.data();
            List<Book> books = (recommendedBooksData!['books'] as List<dynamic>)
                .map((bookData) => Book(
                      id: bookData['bookId'],
                      imageUrl: bookData['imageUrl'],
                      title: bookData['title'],
                      authors: List<String>.from(bookData['author']),
                      description: bookData['description'],
                      publisher: bookData['publisher'],
                      publishedDate: bookData['publishedDate'].toDate(),
                      pageCount: bookData['number of pages'],
                      language: bookData['language'],
                      isbn: bookData['isbn'],
                      averageRating: bookData['average rating'],
                      ratingsCount: bookData['Ratings Count'],
                    ))
                .toList();

            // Limit the number of books to 5 if there are more than 5
            if (books.length > 5) {
              books.shuffle();
              books = books.sublist(0, 5);
            }

            setState(() {
              RecommendedBooksList = books;
            });
          } else {
            setState(() {
              RecommendedBooksList = [];
            });
          }
        });
      }
    } catch (e) {
      print('Failed to fetch Recommended Books: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    initBannerAd();
    // _scrollController.addListener(_scrollListener);
    _pageController = PageController();
    fetchBookmarks();
    fetchWishlist();
    fetchBooksAlreadyReadlist();
    fetchRecommendedBooksList();
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    // Cancel the Firestore listeners to avoid memory leaks
    // _bannerAd.dispose();

    bookmarkedBooksListener.cancel();
    wishlistBooksListener.cancel();
    booksAlreadyReadBooksListener.cancel();
    recommendedBooksListener.cancel();

    super.dispose();
  }

  // final String adUnitId = 'ca-app-pub-7845131645897317/8910674230';

  @override
  Widget build(BuildContext context) {

    final currentTime = DateTime.now();
    String greeting;

    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      greeting = 'greeting1'.tr;
    } else if (currentTime.hour >= 12 && currentTime.hour < 16) {
      greeting = 'greeting2'.tr;
    } else if (currentTime.hour >= 16 && currentTime.hour < 20) {
      greeting = 'greeting3'.tr;
    } else {
      greeting = 'greeting4'.tr;
    }

    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Page',
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
                // backgroundColor: isDarkMode ? Colors.black : Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              greeting,
                              style: const TextStyle(
                                // color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                fontFamily: 'Sora',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                size: 40,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // AdWidget(ad: _bannerAd),
                        isAdLoaded ? SizedBox(
                          height: _bannerAd.size.height.toDouble(),
                          width: _bannerAd.size.width.toDouble(),
                          child: AdWidget(ad: _bannerAd,),
                        ):SizedBox(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (bookmarkedBooksList.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          HorizontalBooksBookmarkList(
                              books: bookmarkedBooksList,
                              categoryName: 'category1'.tr),
                          const SizedBox(height: 16),
                        ],
                        if (wishlistBooksList.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          HorizontalBooksWishlistList(
                            books: wishlistBooksList,
                            categoryName: 'category2'.tr,
                          ),
                          const SizedBox(height: 16),
                        ],
                        const SizedBox(
                          height: 8,
                        ),
                        HorizontalBooksBARList(
                          books: booksAlreadyReadBooksList,
                          categoryName: 'category3'.tr,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (showRecommendedBooks) ...[
                          const SizedBox(height: 8),
                          HorizontalRecommendedBooksList(
                            books: RecommendedBooksList,
                            categoryName: 'category4'.tr,
                            showBookmarkIcon: true,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
                // floatingActionButton: ThemeFloatingActionButton(),
              ),
            ),
          ),
        );
      });
    });
  }
}

class BookCard extends StatefulWidget {
  final Book book;
  final bool showBookmarkIcon;
  final VoidCallback? onBookmarkTapped;

  BookCard({
    required this.book,
    this.showBookmarkIcon = false,
    this.onBookmarkTapped,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.book.isBookmarked;
  }

  void addToBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBookRef = FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id);

        await bookmarkedBookRef.set({
          'imageUrl': widget.book.imageUrl,
          'title': widget.book.title,
          'authors': widget.book.authors,
          'description': widget.book.description,
          'publisher': widget.book.publisher,
          'publishDate': widget.book.publishedDate,
          'pagesCount': widget.book.pageCount,
          'language': widget.book.language,
          'isbn': widget.book.isbn,
          'averageRating': widget.book.averageRating,
          'ratingsCount': widget.book.ratingsCount,
          // Add other book details as desired
        });

        setState(() {
          isBookmarked = true;
        });
      }
    } catch (e) {
      print('Failed to add to bookmarks: $e');
      // Handle error
    }
  }

  void removeFromBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBookRef = FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id);

        await bookmarkedBookRef.delete();

        setState(() {
          isBookmarked = false;
        });
      }
    } catch (e) {
      print('Failed to remove from bookmarks: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 51, 51, 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: widget.book),
            ),
          );
        },
        child: Stack(children: [
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
          if (widget.showBookmarkIcon)
            Positioned(
              top: 255,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                  if (isBookmarked) {
                    addToBookmarks();
                  } else {
                    removeFromBookmarks();
                  }
                },
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xfffab313),
                  size: 32,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isBookmarked = false;
  bool isWishlisted = false;
  @override
  void initState() {
    super.initState();
  }

  void addToBooksAlreadyRead() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final bookData = {
        'imageUrl': widget.book.imageUrl,
        'id': widget.book.id,
        'title': widget.book.title,
        'authors': widget.book.authors,
        'description': widget.book.description,
        'publisher': widget.book.publisher,
        'publishDate': widget.book.publishedDate,
        'pagesCount': widget.book.pageCount,
        'language': widget.book.language,
        'isbn': widget.book.isbn,
        'averageRating': widget.book.averageRating,
        'ratingsCount': widget.book.ratingsCount,

        // Add other book details as desired
      };

      if (isWishlisted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'bookDetailWishlistErrorTitle'.tr,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                'bookDetailWishlistErrorDescription'.tr,
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
      } else {
        FirebaseFirestore.instance
            .collection('BooksAlreadyRead')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id)
            .set(bookData)
            .then((value) {
          setState(() {
            isBookmarked = true;
          });
        }).catchError((error) {
          // Handle the error
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'bookDetailWishlistError2Title'.tr,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                'bookDetailWishlistError2Description'.tr,
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
      }
    }
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
        setState(() {
          isBookmarked = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'bookDetailWishlistError2Title'.tr,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                'bookDetailWishlistError3Description'.tr,
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

  void addToWishlist() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print(userId);
      final bookData = {
        'imageUrl': widget.book.imageUrl,
        'id': widget.book.id,
        'title': widget.book.title,
        'authors': widget.book.authors,
        'description': widget.book.description,
        'publisher': widget.book.publisher,
        'publishDate': widget.book.publishedDate,
        'pagesCount': widget.book.pageCount,
        'language': widget.book.language,
        'isbn': widget.book.isbn,
        'averageRating': widget.book.averageRating,
        'ratingsCount': widget.book.ratingsCount,
        // Add other book details as desired
      };

      if (isBookmarked) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'bookDetailWishlistError4Title'.tr,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Sorry! Please remove this book from the Books Already Read category to add it to the Wishlist category.',
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
      } else {
        FirebaseFirestore.instance
            .collection('Wishlist')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id)
            .set(bookData)
            .then((value) {
          setState(() {
            isWishlisted = true;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'bookDetailWishlistError2Title'.tr,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                content: Text(
                  'bookDetailWishlistError5Description'.tr,
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
  }

  void removeFromWishlist() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('Wishlist')
          .doc(userId)
          .collection('books')
          .doc(widget.book.id)
          .delete()
          .then((value) {
        setState(() {
          isWishlisted = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'bookDetailWishlistError2Title'.tr,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                'bookDetailWishlistError6Description'.tr,
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
          title: Text(
            'bookDetailWishlistError7Title'.tr,
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Sora'),
          ),
          content: Text(
            'bookDetailWishlistError7Description'.tr,
            style: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Sora'),
          ),
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
                            icon: Icon(
                              isBookmarked ? Icons.add_circle : Icons.add,
                              size: 40,
                              color: const Color(0xFFfab313),
                            ),
                            onPressed: () {
                              if (isBookmarked) {
                                removeFromBooksAlreadyRead();
                              } else {
                                addToBooksAlreadyRead();
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 110,
                          right: 8.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 40,
                              color: isWishlisted
                                  ? Colors.red
                                  : const Color(0xFFfab313),
                            ),
                            onPressed: () {
                              if (isWishlisted) {
                                removeFromWishlist();
                              } else {
                                addToWishlist();
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 200,
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
                      SelectableText(
                        'bookDetailTitle'.tr,
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
                      SelectableText(
                        'bookDetailAuthor'.tr,
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
                          SelectableText(
                            'bookDetailPages'.tr,
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
                        SelectableText(
                          'bookDetailLan'.tr,
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
                      SelectableText(
                        'bookDetailDesc'.tr,
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
                        SelectableText(
                          'bookDetailPub'.tr,
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
                                child: Text(
                                  'buyButton'.tr,
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
