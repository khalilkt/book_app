class Book {
  final String title;
  final String id;
  final List<String> authors;
  final int? pageCount;
  final List<String> categories;
  final double? avRating;
  final int? ratingCount;
  final String langage;
  final String? thumbnail;
  // final  ImageProvider image;
  final String? description;

  const Book(
      {required this.title,
      required this.id,
      required this.authors,
      required this.pageCount,
      required this.categories,
      required this.avRating,
      required this.ratingCount,
      required this.langage,
      required this.thumbnail,
      required this.description})
      : assert((avRating == null && ratingCount == null) ||
            (avRating != null && ratingCount != null));
  static Book fromVolumeInfo(Map<String, dynamic> volumeInfo, String id) {
    return Book(
        id: id,
        title: volumeInfo['title'],
        authors: List.from(volumeInfo['authors'] ?? []),
        pageCount: volumeInfo['pageCount'],
        categories: List.from(volumeInfo['categories'] ?? []),
        avRating: volumeInfo['averageRating']?.toDouble(),
        ratingCount: volumeInfo['ratingsCount'],
        langage: volumeInfo["language"],
        description: volumeInfo['description'],
        thumbnail: volumeInfo['imageLinks']?['thumbnail']);
  }

  @override
  String toString() {
    return {
      'title': title,
      'authors': authors,
      'categories': categories,
      "avRating": avRating.toString() + '($ratingCount)',
      "pageCount": pageCount,
      'thumbnail': thumbnail,
      'description': description == null ? 'null' : '...',
      'langage': langage,
    }.toString();
  }
}
