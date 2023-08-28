// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gogobook/Screens/home_screens/book_page.dart';
//
// import '../../models/books.dart';
//
// class BookCard extends StatefulWidget {
//   final Book book;
//   final bool showBookmarkIcon;
//   final VoidCallback? onBookmarkTapped;
//
//   BookCard({
//     required this.book,
//     this.showBookmarkIcon = false,
//     this.onBookmarkTapped,
//   });
//
//   @override
//   State<BookCard> createState() => _BookCardState();
// }
//
// class _BookCardState extends State<BookCard> {
//   bool isBookmarked = false;
//
//   @override
//   void initState() {
//     super.initState();
//     isBookmarked = widget.book.isBookmarked;
//   }
//
//   void addToBookmarks() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         final bookmarkedBookRef = FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id);
//
//         await bookmarkedBookRef.set({
//           'imageUrl': widget.book.imageUrl,
//           'title': widget.book.title,
//           'authors': widget.book.authors,
//           'description': widget.book.description,
//           'publisher': widget.book.publisher,
//           'publishDate': widget.book.publishedDate,
//           'pagesCount': widget.book.pageCount,
//           'language': widget.book.language,
//           'isbn': widget.book.isbn,
//           'averageRating': widget.book.averageRating,
//           'ratingsCount': widget.book.ratingsCount,
//           // Add other book details as desired
//         });
//
//         setState(() {
//           isBookmarked = true;
//         });
//       }
//     } catch (e) {
//       print('Failed to add to bookmarks: $e');
//       // Handle error
//     }
//   }
//
//   void removeFromBookmarks() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         final bookmarkedBookRef = FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id);
//
//         await bookmarkedBookRef.delete();
//
//         setState(() {
//           isBookmarked = false;
//         });
//       }
//     } catch (e) {
//       print('Failed to remove from bookmarks: $e');
//       // Handle error
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color.fromRGBO(49, 51, 51, 0.5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookDetailsScreen(book: widget.book),
//             ),
//           );
//         },
//         child: Stack(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(
//                 widget.book.imageUrl,
//                 // width: 240,
//                 // height: 250,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.book.title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         fontFamily: 'Sora',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Author: ${widget.book.authors.join(', ')}',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (widget.showBookmarkIcon)
//             Positioned(
//               top: 10,
//               right: 10,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isBookmarked = !isBookmarked;
//                   });
//                   if (isBookmarked) {
//                     addToBookmarks();
//                   } else {
//                     removeFromBookmarks();
//                   }
//                 },
//                 child: Icon(
//                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                   color: const Color(0xfffab313),
//                   size: 32,
//                 ),
//               ),
//             ),
//         ]),
//       ),
//     );
//   }
// }