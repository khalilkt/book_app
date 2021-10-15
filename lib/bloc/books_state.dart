part of 'books_cubit.dart';

class BooksState extends Equatable {
  final List<Book> books;
  const BooksState(this.books);

  @override
  List<Object> get props => [books];
}

class RecommendedState extends BooksState {
  const RecommendedState(List<Book> books) : super(books);
}

class SearchState extends BooksState {
  const SearchState(List<Book> result) : super(result);
}
