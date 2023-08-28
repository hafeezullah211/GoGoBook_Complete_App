import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:gogobook/LanguageChnageProvider.dart';
import 'package:gogobook/Screens/home_screens/home_page_screen.dart';
import 'package:gogobook/Screens/home_screens/tile_preview.dart';
import 'package:gogobook/Services/firestore_service.dart';
import 'package:gogobook/Services/google_api_service.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../common_widgets/tutorial_coach_dialogue.dart';
import '../../models/books.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

import 'barcodeScannerPage.dart';

enum BookDisplayStyle {
  Tile,
  Card,
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BookDisplayStyle _bookDisplayStyle = BookDisplayStyle.Card;
  final FirestoreService firestoreService = FirestoreService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  late TextEditingController _searchController;
  List<Book> _books = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showSearchHistory = false;
  String _barcodeResult = '';
  TextEditingController _searchBarController = TextEditingController();
  late CameraController _cameraController;
  late Future<void> _cameraInitializer;

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey searchBar = GlobalKey();
  GlobalKey searchBarButton = GlobalKey();

  bool tutorialShown = false; // Track if the tutorial has been shown

  void _selectBookDisplayStyle(BookDisplayStyle? style) {
    if (style != null) {
      setState(() {
        _bookDisplayStyle = style;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadSearchHistory();
    SharedPreferences.getInstance().then((prefs) {
      bool tutorialCompleted = prefs.getBool('searchPageTutorialCompleted') ?? false;
      if (!tutorialCompleted && !tutorialShown) {
        // Show the tutorial only if it hasn't been shown before
        Future.delayed(const Duration(seconds: 1), () {
          _showRemainingTutorial();
        });
        setState(() {
          tutorialShown = true;
        });
      }
    });
  }

  void _disposeCamera() {
    if (_cameraController != null) {
      _cameraController.dispose();
    }
  }


  void _showRemainingTutorial() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.amber,
      hideSkip: true,
      onClickTarget: (targets) {},
      onFinish: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('searchPageTutorialCompleted', true);
      },
      onSkip: () {},
    )..show(context: context);
  }


  void _initTarget() {
    targets = [
      // Search Bar Tutorial
      TargetFocus(
        identify: 'search_bar',
        keyTarget: searchBar,
        color: Color(0xFF91c7bc),
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'searchWizard1st'.tr,
                onNext: () {
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
      TargetFocus(
        identify: 'search_bar_button',
        keyTarget: searchBarButton,
        color: Color(0xFF61493b),
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'searchWizard2nd'.tr,
                next: 'wizardFinishButton'.tr,
                onNext: () {
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


  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    tutorialCoachMark?.finish();
    _disposeCamera();
    _searchBarController.dispose();
    _searchController.dispose();
    super.dispose();
  }


  void _submitBarcodeResult(String barcodeResult) {
    _searchController.text = barcodeResult;
    _submitSearch(barcodeResult);
  }

  Future<void> _scanBarcode() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final cameras = await availableCameras();
        final camera = cameras.first;

        _cameraController = CameraController(
          camera,
          ResolutionPreset.high,
        );
        await _cameraController.initialize();

        final result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'cancelText'.tr,
          true,
          ScanMode.DEFAULT,
        );

        if (result == '-1') {
          // Barcode scanning canceled
          _cameraController.dispose();
          return;
        }

        if (!mounted) return;

        setState(() {
          _barcodeResult = result;
        });

        _submitBarcodeResult(result);
      } else {
        // Handle camera permission not granted
        print('Camera permission not granted');
      }
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print('Platform Exception: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    }
  }

  Future<void> _loadSearchHistory() async {
    List<String> searchHistory = await SearchHistory.loadSearchHistory();
    setState(() {
      _searchHistory = searchHistory;
    });
  }

  Future<void> _saveSearchHistory() async {
    await SearchHistory.saveSearchHistory(_searchHistory);
  }

  void _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await searchBooks(query);
      setState(() {
        _books = response.books.cast<Book>();
        _isLoading = false;
      });
      if (_books.isNotEmpty) {
        final random = Random();
        final randomIndices = List<int>.generate(3, (_) => random.nextInt(_books.length));
        final randomBooks = randomIndices.map((index) => _books[index]).toList();

        // Save the randomly selected books to Firestore
        final userRef = FirebaseFirestore.instance.collection('RecommendedBooks').doc(userId);
        final recommendedBooks = await userRef.get();
        final existingBooks = recommendedBooks.exists ? (recommendedBooks.data() as Map<String, dynamic>)['books'] as List<dynamic> : [];

        for (final randomBook in randomBooks) {
          // Check if the book is already in the user's recommended books
          final bookExists = existingBooks.any((book) => book['bookId'] == randomBook.id);
          if (!bookExists) {
            existingBooks.add({
              'bookId': randomBook.id,
              'title': randomBook.title,
              'author': randomBook.authors,
              'isbn': randomBook.isbn,
              'description': randomBook.description,
              'language': randomBook.language,
              'publishedDate': randomBook.publishedDate,
              'publisher': randomBook.publisher,
              'imageUrl': randomBook.imageUrl,
              'averageRating': randomBook.averageRating,
              'ratingsCount': randomBook.ratingsCount,
              'numberOfPages': randomBook.pageCount,
            });
          }
        }

        // Update the recommended books collection in Firestore
        await userRef.set({'books': existingBooks});
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _books = [];
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'searchError'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Sora',
              fontSize: 18,
            ),
          ),
          content: Text(
            'errorDescription'.tr,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Sora',
              fontSize: 14,
            ),
          ),
          actions: [
            firebaseUIButton(context, 'OK', () {
              Navigator.of(context).pop();
            })
          ],
        ),
      );
    }
  }

  List<Book> previouslyRecommendedBooks = [];

  Future<Book?> getRandomRecommendedBook() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final recommendedBooksSnapshot = await FirebaseFirestore.instance
          .collection('RecommendedBooks')
          .doc(userId)
          .get();

      if (recommendedBooksSnapshot.exists) {
        final recommendedBooksData = recommendedBooksSnapshot.data();
        final books = (recommendedBooksData!['books'] as List<dynamic>)
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

        if (books.isNotEmpty) {
          final random = Random();
          Book? randomBook;
          int maxAttempts = 5; // Maximum number of attempts to find a unique book
          int attempt = 0;

          while (attempt < maxAttempts) {
            final randomIndex = random.nextInt(books.length);
            randomBook = books[randomIndex];

            // Check if the book was previously recommended
            if (!previouslyRecommendedBooks.contains(randomBook)) {
              previouslyRecommendedBooks.add(randomBook);
              break;
            }

            attempt++;
          }

          if (attempt >= maxAttempts) {
            // Reset the previously recommended books list if all books have been recommended
            previouslyRecommendedBooks.clear();
          }

          return randomBook;
        }
      }
    }

    // Return null when there are no recommended books
    return null;
  }

  // void _recommendBook() async {
  //   final recommendedBook = await getRandomRecommendedBook();
  //   if (recommendedBook != null) {
  //     final userRecommendationsRef = FirebaseFirestore.instance.collection('Recommendations').doc(userId);
  //     final userRecommendations = await userRecommendationsRef.get();
  //     final existingRecommendations = userRecommendations.exists ? (userRecommendations.data() as Map<String, dynamic>)['books'] as List<dynamic>? : null;
  //
  //     if (existingRecommendations == null) {
  //       // Create a new recommendations list if it doesn't exist
  //       final newRecommendations = [
  //         {
  //           'bookId': recommendedBook.id,
  //           'title': recommendedBook.title,
  //           'author': recommendedBook.authors,
  //           'isbn': recommendedBook.isbn,
  //           'description': recommendedBook.description,
  //           'language': recommendedBook.language,
  //           'publishedDate': recommendedBook.publishedDate,
  //           'publisher': recommendedBook.publisher,
  //           'imageUrl': recommendedBook.imageUrl,
  //           'averageRating': recommendedBook.averageRating,
  //           'ratingsCount': recommendedBook.ratingsCount,
  //           'numberOfPages': recommendedBook.pageCount,
  //         }
  //       ];
  //
  //       // Update the recommendations collection for the user in Firestore
  //       await userRecommendationsRef.set({'books': newRecommendations});
  //     } else {
  //       // Check if the book is already in the user's recommendations
  //       final bookExists = existingRecommendations.any((book) => book['bookId'] == recommendedBook.id);
  //       if (!bookExists) {
  //         existingRecommendations.add({
  //           'bookId': recommendedBook.id,
  //           'title': recommendedBook.title,
  //           'author': recommendedBook.authors,
  //           'isbn': recommendedBook.isbn,
  //           'description': recommendedBook.description,
  //           'language': recommendedBook.language,
  //           'publishedDate': recommendedBook.publishedDate,
  //           'publisher': recommendedBook.publisher,
  //           'imageUrl': recommendedBook.imageUrl,
  //           'averageRating': recommendedBook.averageRating,
  //           'ratingsCount': recommendedBook.ratingsCount,
  //           'numberOfPages': recommendedBook.pageCount,
  //         });
  //
  //         await userRecommendationsRef.set({'books': existingRecommendations});
  //       }
  //     }
  //   }
  // }

  // Future<bool> isBooksAlreadyReadEmpty() async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //   if (userId != null) {
  //     final collectionRef = FirebaseFirestore.instance
  //         .collection('BooksAlreadyRead')
  //         .doc(userId)
  //         .collection('books');
  //
  //     final querySnapshot = await collectionRef.limit(1).get();
  //     return querySnapshot.size == 0;
  //   }
  //   return true;
  // }


  void _submitSearch(String query) async {
    if (userId != null) {
      await SearchHistory.addSearchQuery(query);
    }

    _searchController.clear();
    _searchBooks(query);

    setState(() {
      _showSearchHistory = false;
    });

    FocusScope.of(context).requestFocus(FocusNode());

  }

  void _deleteSearchHistory(int index) async {
    String query = _searchHistory[index];
    await SearchHistory.removeSearchQuery(query);

    setState(() {
      _searchHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        title: 'Search Screen',
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

          child: Scaffold(
            resizeToAvoidBottomInset: false, // Add this line
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        //Title and BarCode Scan Icon
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'searchScreenTitle'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                fontFamily: 'Sora',
                              ),
                            ),
                            IconButton(
                                onPressed: _scanBarcode,
                                icon: Icon(
                                    Icons.qr_code_scanner,
                                  size: 32,
                                ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //search bar code
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              key: searchBar,
                              controller: _searchController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(22.0),
                                labelText: 'searchBarText'.tr,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Sora',
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Change border color when not focused
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Color(
                                        0xFFCDE7BE), // Change border color when focused
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showSearchHistory =
                                      true; // Show the search history
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 63.0,
                              child: TextButton(
                                key: searchBarButton,
                                onPressed: () {
                                  _submitSearch(_searchController.text);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF07abb8)),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'searchBarButton'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //search history
                    // if (_searchController.text.isNotEmpty)
                    Visibility(
                      visible: _showSearchHistory,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchHistory.length,
                        itemBuilder: (context, index) {
                          final item = _searchHistory[index];
                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _deleteSearchHistory(index);
                              },
                            ),
                            onTap: () {
                              _searchController.text =
                                  item; // Paste the text in the search field
                              _submitSearch(item); // Trigger the search
                              // Remove the selected book from the search history list
                              setState(() {
                                _searchHistory.removeAt(index);
                              });
                              _saveSearchHistory();
                            },
                          );
                        },
                      ),
                    ),

                    //Filter Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'filterDialogueTitle'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sora',
                                  fontSize: 18,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'filterdialogueText1'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                    leading: Radio<BookDisplayStyle>(
                                      value: BookDisplayStyle.Tile,
                                      groupValue: _bookDisplayStyle,
                                      onChanged: (BookDisplayStyle? newValue) {
                                        setState(() {
                                          _bookDisplayStyle = newValue!;
                                        });
                                        Navigator.pop(
                                            context); // Dismiss the pop-up after selection
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'filterdialogueText2'.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                    leading: Radio<BookDisplayStyle>(
                                      value: BookDisplayStyle.Card,
                                      groupValue: _bookDisplayStyle,
                                      onChanged: (BookDisplayStyle? newValue) {
                                        setState(() {
                                          _bookDisplayStyle = newValue!;
                                        });
                                        Navigator.pop(
                                            context); // Dismiss the pop-up after selection
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'filterButton'.tr,
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),

                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (_bookDisplayStyle == BookDisplayStyle.Tile)
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch,
                          },
                        ),
                        child: Scrollbar(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _books.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 4,
                            ),
                            itemBuilder: (context, index) {
                              final book = _books[index];

                              return TilePreview(
                                book: book,
                                showBookmarkIcon: true,
                              );
                            },
                          ),
                        ),
                      )
                    else if (_bookDisplayStyle == BookDisplayStyle.Card)
                      Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (_books.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            final int leftCardIndex = index * 2;
                            final int rightCardIndex = leftCardIndex + 1;

                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BookCard(
                                      book: _books[leftCardIndex],
                                      showBookmarkIcon: true,
                                    ),
                                  ),
                                ),
                                if (rightCardIndex < _books.length)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BookCard(
                                        book: _books[rightCardIndex],
                                        showBookmarkIcon: true,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        child: Text(
                          'recommendButton'.tr,
                          style: TextStyle(
                            fontFamily: "Sora",
                            color: Color(0xFF07abb8),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () async {
                          await recommendBookToUser();
                          // final recommendedBook = await getRandomRecommendedBook();
                          // final isBooksEmpty = await isBooksAlreadyReadEmpty();

                          // if (isBooksEmpty) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: Text('recommendError1Heading'.tr,
                          //         style: TextStyle(
                          //           fontFamily: 'Sora',
                          //           fontWeight: FontWeight.bold
                          //       ),
                          //       ),
                          //       content: Text(
                          //         'recommendError1Content'.tr,
                          //         style: TextStyle(
                          //           fontFamily: "Sora",
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 14.0,
                          //         ),
                          //       ),
                          //       actions: [
                          //         firebaseUIButton(context, 'OK', () {
                          //           Navigator.of(context).pop();
                          //         }),
                          //       ],
                          //     ),
                          //   );
                          // } else if (recommendedBook != null) {
                          //   _recommendBook();
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => CustomDialog(
                          //       width: 250,
                          //       height: 500,
                          //       child: Column(
                          //         children: [
                          //           SizedBox(
                          //             height: 16,
                          //           ),
                          //           BookCard(book: recommendedBook),
                          //           SizedBox(
                          //             height: 16,
                          //           ),
                          //           firebaseUIButton(context, 'OK', () {
                          //             Navigator.of(context).pop();
                          //           }),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          // } else {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: Text('recommendError2Heading'.tr,
                          //       style: TextStyle(
                          //         fontFamily: 'Sora',
                          //         fontWeight: FontWeight.bold
                          //       ),
                          //       ),
                          //       content: Text(
                          //         'recommendError2Content'.tr,
                          //         style: TextStyle(
                          //           fontFamily: "Sora",
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 14.0,
                          //         ),
                          //       ),
                          //       actions: [
                          //         firebaseUIButton(context, 'OK', () {
                          //           Navigator.of(context).pop();
                          //         }),
                          //       ],
                          //     ),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
            // floatingActionButton: ThemeFloatingActionButton(),
          ),
        ),
      ),
    );
  }

  Future<void> recommendBookToUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final bookFromFirestore = await getBookFromFirestore(userId);

      if (bookFromFirestore != null) {
        final chatGptResponse = await getChatGptRecommendations(bookFromFirestore);

        if (chatGptResponse.isNotEmpty) {
          final recommendedBooks = await searchGoogleBooks(chatGptResponse as String);
          if (recommendedBooks.isNotEmpty) {
            await storeRecommendedBooks(userId, recommendedBooks);
            final recommendedBook = recommendedBooks[0];
            _showRecommendedBookDialog(recommendedBook);
          } else {
            _showAlertDialog('No matching books found on Google Books API.');
          }
        } else {
          _showAlertDialog('ChatGPT response is empty.');
        }
      } else {
        _showAlertDialog('Please add at least one book in the BooksAlreadyRead collection.');
      }
    }
  }


  Future<Book?> getBookFromFirestore(String userId) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('BooksAlreadyRead')
          .doc(userId)
          .collection('books');

      final querySnapshot = await collectionRef.limit(1).get();

      if (querySnapshot.size > 0) {
        final bookData = querySnapshot.docs[0].data();
        return Book(
          id: bookData['id'],
          title: bookData['title'],
          authors: List<String>.from(bookData['authors']),
          description: bookData['description'],
          imageUrl: bookData['imageUrl'],
          publisher: bookData['publisher'],
          publishedDate: bookData['publishedDate'].toDate(),
          pageCount: bookData['pageCount'],
          language: bookData['language'],
          isbn: bookData['isbn'],
          averageRating: bookData['averageRating'],
          ratingsCount: bookData['ratingsCount'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching book from Firestore: $e');
      return null;
    }
  }

  Future<void> storeRecommendedBooks(String userId, List<Book> recommendedBooks) async {
    try {
      final userRecommendedBooksRef = FirebaseFirestore.instance
          .collection('RecommendedBooks')
          .doc(userId);

      final recommendedBooksData = recommendedBooks.map((book) => {
        'bookId': book.id,
        'title': book.title,
        'authors': book.authors,
        'description': book.description,
        'imageUrl': book.imageUrl,
        'publisher': book.publisher,
        'publishedDate': book.publishedDate,
        'pageCount': book.pageCount,
        'language': book.language,
        'isbn': book.isbn,
        'averageRating': book.averageRating,
        'ratingsCount': book.ratingsCount,
      }).toList();

      await userRecommendedBooksRef.set({
        'books': recommendedBooksData,
      });
    } catch (e) {
      print('Error storing recommended books: $e');
    }
  }

  Future<void> _showRecommendedBookDialog(Book recommendedBook) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recommended Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${recommendedBook.title}'),
            Text('Authors: ${recommendedBook.authors.join(', ')}'),
            Text('Description: ${recommendedBook.description}'),
            // Add more fields as needed
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }



  Future<List<String>> getChatGptRecommendations(Book bookData) async {
    final apiKey = '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';
    final apiUrl = 'https://api.openai.com/v1/engines/text-davinci-003/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'prompt': 'Recommend me 5 books related to the book titled "${bookData.title}"',
          'max_tokens': 50,  // Adjust as needed
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final chatGptSuggestions = responseData['choices'][0]['text'];
        print(chatGptSuggestions.split('\n'));
        return chatGptSuggestions.split('\n');
      } else {
        print('ChatGPT API request failed with status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching ChatGPT suggestions: $e');
      return [];
    }
  }

  Future<List<Book>> searchGoogleBooks(String query) async {
    final apiKey = 'AIzaSyDY6Ws3XfSsumutEn3bdFlu5fl9US31h9M'; // Replace with your actual API key
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'];

        if (items != null && items is List) {
          final books = items
              .map((item) => Book.fromJson(item['volumeInfo'], id: item['id']))
              .where((book) => book != null)
              .toList();
          return books;
        }
      }
      return [];
    } catch (e) {
      print('Error searching Google Books API: $e');
      return [];
    }
  }

}

class CustomDialog extends Dialog {
  final Widget child;
  final double width;
  final double height;

  CustomDialog(
      {required this.child, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}

class SearchHistory {
  static const String _searchHistoryKey = 'searchHistory';

  static Future<List<String>> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  static Future<void> saveSearchHistory(List<String> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, searchHistory);
  }

  static Future<void> addSearchQuery(String query) async {
    List<String> searchHistory = await loadSearchHistory();
    searchHistory.remove(query); // Remove duplicate entry
    searchHistory.insert(0, query); // Add query at the beginning
    await saveSearchHistory(searchHistory);
  }

  static Future<void> removeSearchQuery(String query) async {
    List<String> searchHistory = await loadSearchHistory();
    searchHistory.remove(query);
    await saveSearchHistory(searchHistory);
  }

  static Future<void> clearSearchHistory() async {
    await saveSearchHistory([]);
  }
}
