import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/home_page_screen.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:gogobook/models/books.dart';

class HorizontalRecommendedBooksList extends StatefulWidget {
  final List<Book> books;
  final String categoryName;
  final bool showBookmarkIcon;

  HorizontalRecommendedBooksList({
    required this.books,
    required this.categoryName,
    this.showBookmarkIcon = false,
  });

  @override
  _HorizontalBooksListState createState() => _HorizontalBooksListState();
}

class _HorizontalBooksListState extends State<HorizontalRecommendedBooksList> {
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
              (book) => BookCard(
                book: book,
                showBookmarkIcon: widget.showBookmarkIcon,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
