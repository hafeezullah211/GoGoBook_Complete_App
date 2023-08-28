// import 'dart:js';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class Book {
//   final String id;
//   final String title;
//   final List<String> authors;
//   final String description;
//   final String imageUrl;
//   final String publisher;
//   final DateTime publishedDate;
//   final int pageCount;
//   final String language;
//   final String isbn;
//   final double averageRating;
//   final int ratingsCount;
//   bool isBookmarked;
//   late final String selfLink;
//
//   Book({
//     required this.id,
//     required this.title,
//     required this.authors,
//     required this.description,
//     required this.imageUrl,
//     required this.publisher,
//     required this.publishedDate,
//     required this.pageCount,
//     required this.language,
//     required this.isbn,
//     required this.averageRating,
//     required this.ratingsCount,
//     this.isBookmarked = false,
//   }) {
//     selfLink = 'https://books.google.com/books?id=$id';
//   }
// }
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String apiKey = 'AIzaSyDY6Ws3XfSsumutEn3bdFlu5fl9US31h9M';
//   final String chatGptApiKey = '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';
//   final String chatGptEndpoint = 'YOUR_CHATGPT_API_ENDPOINT';
//
//   Future<void> generateRecommendedBooks() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       final querySnapshot = await _firestore
//           .collection('BooksAlreadyRead')
//           .doc(userId)
//           .collection('books')
//           .limit(1)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Please add at least one book to the Books Already Read collection.'),
//               actions: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//
//       final bookDoc = querySnapshot.docs.first;
//       final bookName = bookDoc['title'];
//
//       final chatGptResponse = await _getChatGptRecommendations(bookName);
//       final recommendedBookNames = chatGptResponse['suggested_books'].cast<String>();
//
//       await _saveRecommendedBooksDetails(recommendedBookNames, userId);
//     }
//   }
//
//   Future<Map<String, dynamic>> _getChatGptRecommendations(String bookName) async {
//     final url = '$chatGptEndpoint?book_name=$bookName';
//     final response = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $chatGptApiKey'});
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load data from ChatGPT API');
//     }
//   }
//
//   Future<void> _saveRecommendedBooksDetails(List<String> bookNames, String userId) async {
//     for (final bookName in bookNames) {
//       final googleBooksResponse = await _searchGoogleBooks(bookName);
//       final volumeInfo = googleBooksResponse['items'][0]['volumeInfo'];
//
//       final book = Book(
//         id: googleBooksResponse['items'][0]['id'],
//         title: volumeInfo['title'],
//         authors: List<String>.from(volumeInfo['authors'] ?? []),
//         description: volumeInfo['description'] ?? '',
//         imageUrl: volumeInfo['imageLinks']['thumbnail'] ?? '',
//         publisher: volumeInfo['publisher'] ?? '',
//         publishedDate: DateTime.parse(volumeInfo['publishedDate'] ?? ''),
//         pageCount: volumeInfo['pageCount'] ?? 0,
//         language: volumeInfo['language'] ?? '',
//         isbn: volumeInfo['industryIdentifiers'][0]['identifier'] ?? '',
//         averageRating: volumeInfo['averageRating'] ?? 0.0,
//         ratingsCount: volumeInfo['ratingsCount'] ?? 0,
//       );
//
//       await _firestore
//           .collection('RecommendedBooks')
//           .doc(userId)
//           .collection('books')
//           .doc(book.id)
//           .set(book.toJson());
//     }
//   }
//
//   Future<Map<String, dynamic>> _searchGoogleBooks(String query) async {
//     final url = 'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to search Google Books API');
//     }
//   }
// }
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               final firestoreService = FirestoreService();
//               await firestoreService.generateRecommendedBooks();
//             },
//             child: Text('Recommend me a Book'),
//           ),
//         ),
//       ),
//     );
//   }
// }
