class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String imageUrl;
  final String publisher;
  final DateTime? publishedDate;
  final int? pageCount;
  final String language;
  final String isbn;
  final double? averageRating;
  final int? ratingsCount;
  bool isBookmarked;
  late final String selfLink;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.imageUrl,
    required this.publisher,
    required this.publishedDate,
    required this.pageCount,
    required this.language,
    required this.isbn,
    required this.averageRating,
    required this.ratingsCount,
    this.isBookmarked = false,
  }) {
    selfLink = 'https://books.google.com/books?id=$id';
  }

  factory Book.fromJson(Map<String, dynamic> json, {required String id}) {
    final List<dynamic>? authorList = json['authors'];
    final List<String> authors =
        authorList?.map((author) => author.toString()).toList() ?? ['Unknown'];
    final String description =
        json['description'] ?? 'No description available';
    final String imageUrl = _getImageUrl(json) ?? 'No Image';
    final String publisher = json['publisher'] ?? 'Unknown';
    final DateTime publishedDate =
        DateTime.tryParse(json['publishedDate']) ?? DateTime.now();
    final int pageCount = json['pageCount'] ?? 0;
    final String language = json['language'] ?? 'Unknown';
    final String isbn =
        json['industryIdentifiers'][0]['identifier'] ?? 'Unknown';
    final double averageRating = json['averageRating']?.toDouble() ?? 0.0;
    final int ratingsCount = json['ratingsCount'] ?? 0;

    return Book(
      id: id,
      title: json['title'] ?? 'Unknown',
      authors: authors,
      description: description,
      imageUrl: imageUrl,
      publisher: publisher,
      publishedDate: publishedDate,
      pageCount: pageCount,
      language: language,
      isbn: isbn,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
    );
  }

  static String? _getImageUrl(Map<String, dynamic> json) {
    final Map<String, dynamic>? imageLinks = json['imageLinks'];
    if (imageLinks != null) {
      return imageLinks['thumbnail'];
    }
    return null;
  }
}

