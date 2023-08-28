// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/books.dart';
//
// class BookDetailsScreen extends StatefulWidget {
//   final Book book;
//
//   const BookDetailsScreen({Key? key, required this.book}) : super(key: key);
//
//   @override
//   State<BookDetailsScreen> createState() => _BookDetailsScreenState();
// }
//
// class _BookDetailsScreenState extends State<BookDetailsScreen> {
//   bool isBookmarked = false;
//   bool isWishlisted = false;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void addToBooksAlreadyRead() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       final bookData = {
//         'imageUrl': widget.book.imageUrl,
//         'id': widget.book.id,
//         'title': widget.book.title,
//         'authors': widget.book.authors,
//         'description': widget.book.description,
//         'publisher': widget.book.publisher,
//         'publishDate': widget.book.publishedDate,
//         'pagesCount': widget.book.pageCount,
//         'language': widget.book.language,
//         'isbn': widget.book.isbn,
//         'averageRating': widget.book.averageRating,
//         'ratingsCount': widget.book.ratingsCount,
//
//         // Add other book details as desired
//       };
//
//       FirebaseFirestore.instance
//           .collection('BooksAlreadyRead')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .set(bookData)
//           .then((value) {
//         setState(() {
//           isBookmarked = true;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   void removeFromBooksAlreadyRead() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       FirebaseFirestore.instance
//           .collection('BooksAlreadyRead')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .delete()
//           .then((value) {
//         setState(() {
//           isBookmarked = false;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   void addToWishlist() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       print(userId);
//       final bookData = {
//         'imageUrl': widget.book.imageUrl,
//         'id': widget.book.id,
//         'title': widget.book.title,
//         'authors': widget.book.authors,
//         'description': widget.book.description,
//         'publisher': widget.book.publisher,
//         'publishDate': widget.book.publishedDate,
//         'pagesCount': widget.book.pageCount,
//         'language': widget.book.language,
//         'isbn': widget.book.isbn,
//         'averageRating': widget.book.averageRating,
//         'ratingsCount': widget.book.ratingsCount,
//         // Add other book details as desired
//       };
//
//       FirebaseFirestore.instance
//           .collection('Wishlist')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .set(bookData)
//           .then((value) {
//         setState(() {
//           isWishlisted = true;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   void removeFromWishlist() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       FirebaseFirestore.instance
//           .collection('Wishlist')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .delete()
//           .then((value) {
//         setState(() {
//           isWishlisted = false;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.book.title), actions: [
//         IconButton(
//           icon: Icon(
//             isBookmarked ? Icons.add_circle : Icons.add,
//             size: 30,
//           ),
//           onPressed: () {
//             if (isBookmarked) {
//               removeFromBooksAlreadyRead();
//             } else {
//               addToBooksAlreadyRead();
//             }
//           },
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.favorite,
//             size: 30,
//             color: isWishlisted ? Colors.red : null,
//           ),
//           onPressed: () {
//             if (isWishlisted) {
//               removeFromWishlist();
//             } else {
//               addToWishlist();
//             }
//           },
//         ),
//       ]),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Book id: ${widget.book.id}'),
//             Image.network(
//               widget.book.imageUrl,
//               // height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Title: ${widget.book.title}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Author: ${widget.book.authors.join(', ')}',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Number of Pages: ${widget.book.pageCount}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Language: ${widget.book.language}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'ISBN: ${widget.book.isbn}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Description: ${widget.book.description}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Publisher: ${widget.book.publisher}',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Publication Date: ${widget.book.publishedDate}',
//               style: TextStyle(fontSize: 16),
//             ),
//
//             // IconButton(
//             //   icon: Icon(
//             //     isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//             //     size: 30,
//             //   ),
//             //   onPressed: () {
//             //     if (isBookmarked) {
//             //       removeFromBookmarks();
//             //     } else {
//             //       addToBookmarks();
//             //     }
//             //   },
//             // ),
//             // Display other attributes as desired
//           ],
//         ),
//       ),
//     );
//   }
// }