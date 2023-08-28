import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/books.dart';
import 'home_page_screen.dart';

class TilePreview extends StatefulWidget {
  final Book book;
  final bool showBookmarkIcon;
  final VoidCallback? onBookmarkTapped;

  TilePreview({
    required this.book,
    this.showBookmarkIcon = false,
    this.onBookmarkTapped,
  });
  @override
  State<TilePreview> createState() => _TilePreviewState();
}

class _TilePreviewState extends State<TilePreview> {
  bool isBookmarked = false;

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
  void initState() {
    super.initState();
    isBookmarked = widget.book.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsScreen(book: widget.book)));
        },
        child: Card(
          color: const Color.fromRGBO(49, 51, 51, 0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)),
          child: Stack(
            children: [
              Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Align content vertically in the center
              children: [
                ListTile(
                  title: Text(
                    widget.book.title.length > 25
                        ? '${widget.book.title.substring(0, 22)}...'
                        : widget.book.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sora',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                      widget.book.authors
                          .join(', ').length > 25
                        ? '${widget.book.authors
                          .join(', ').substring(0, 22)}...'
                        : widget.book.authors
                        .join(', '),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Sora',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  // ... other details ...
                ),
              ],
            ),
              if (widget.showBookmarkIcon)
                Positioned(
                  top: 10,
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
          ]
          ),
        ),
      ),
    );
  }
}
