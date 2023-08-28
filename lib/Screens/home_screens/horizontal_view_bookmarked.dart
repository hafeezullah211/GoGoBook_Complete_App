import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/home_page_screen.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';

import '../../models/books.dart';
// import 'package:gogobook/Screens/home_screens/home_page_screen.dart';

class HorizontalBooksBookmarkList extends StatefulWidget {
  final List<Book> books;
  final String categoryName;
  final bool showBookmarkIcon;

  HorizontalBooksBookmarkList({
    required this.books,
    required this.categoryName,
    this.showBookmarkIcon = false,
  });

  @override
  _HorizontalBooksListState createState() => _HorizontalBooksListState();
}

class _HorizontalBooksListState extends State<HorizontalBooksBookmarkList> {
  ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
              (book) => BookCardBookmark(
                book: book,
                onBookmarkRemoved: () {
                  removeBookFromList(book);
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class BookCardBookmark extends StatefulWidget {
  final Book book;
  final VoidCallback? onBookmarkRemoved;

  BookCardBookmark({required this.book, this.onBookmarkRemoved});

  @override
  _BookCardBookmarkState createState() => _BookCardBookmarkState();
}

class _BookCardBookmarkState extends State<BookCardBookmark> {
  @override
  void initState() {
    super.initState();
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
        if (widget.onBookmarkRemoved != null) {
          widget.onBookmarkRemoved!();
        }
        setState(() {});
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: widget.book),
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
                  removeFromBookmarks();
                },
                child: Icon(
                  Icons.bookmark,
                  color: const Color(0xfffab313),
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
