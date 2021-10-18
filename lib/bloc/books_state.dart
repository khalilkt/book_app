part of 'books_cubit.dart';

class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

abstract class GoodBookState extends BooksState {
  final List<Book> books;

  const GoodBookState(this.books);
  @override
  List<Object> get props => [books];
}

class RecommendedState extends GoodBookState {
  @override
  const RecommendedState(List<Book> books) : super(books);
}

class SearchState extends GoodBookState {
  const SearchState(List<Book> result) : super(result);
}

abstract class BooksException {
  String message;
  BooksException(this.message);
}

abstract class ExceptionState extends BooksState {
  final String message;
  final String? subMessage;
  @override
  List<Object> get props =>
      subMessage == null ? [message] : [message, subMessage!];
  const ExceptionState(this.message, [this.subMessage]);
}

class DefaultBookExcpetion extends ExceptionState {
  const DefaultBookExcpetion()
      : super("Something whent wrong",
            'Make sure wifi or cellular data is turned on and try again');
}
