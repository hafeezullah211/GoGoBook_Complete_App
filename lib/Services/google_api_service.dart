import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Screens/home_screens/search_screen.dart';
import '../models/books.dart';

const String apiKey = 'AIzaSyDY6Ws3XfSsumutEn3bdFlu5fl9US31h9M';

Future<BooksResponse> searchBooks(String query) async {
  final url = Uri.https('www.googleapis.com', '/books/v1/volumes', {
    'q': query,
    'key': apiKey,
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return BooksResponse.fromJson(jsonData);
  } else {
    throw Exception('Failed to search for books');
  }
}

class BooksResponse {
  final List<Book> books;

  BooksResponse({required this.books});

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = json['items'];
    final List<Book> books = items.map((item) {
      final String id = item['id']; // Unique ID for the book
      return Book.fromJson(item['volumeInfo'], id: id);
    }).toList();

    return BooksResponse(books: books);
  }
}
