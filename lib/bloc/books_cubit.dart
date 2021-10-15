import 'package:bloc/bloc.dart';
import 'package:books_app/models/book.dart';
import 'package:books_app/models/user.dart';
import 'package:books_app/repository/books_repo.dart';
import 'package:equatable/equatable.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  List<Book> recommended = [
    thinkAndGrowRichBook,
    richDadPoorDadBook,
    sellAnythingToAnyBody,
    thinkAndGrowRichBook,
    richDadPoorDadBook,
    sellAnythingToAnyBody
  ];

  final User user;
  BooksRepo booksRepo = BooksRepo();

  BooksCubit(this.user) : super(const RecommendedState([]));

  void cancelSearch() {
    // emit(recommendedState(booksRepo.recommendations))
  }

  Future<List<Book>> searchFor(String name) async {
    // emit(seachState(seatch_result))
    try {
      List<Book> result = await booksRepo.seachForBooks(name);
      // emit searhc state
      return result;
    } catch (e) {
      print("error  : $e");

      rethrow;
    }
  }
}
