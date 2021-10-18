import 'package:bloc/bloc.dart';
import 'package:books_app/logg.dart';
import 'package:books_app/models/book.dart';
import 'package:books_app/models/user.dart';
import 'package:books_app/repository/books_repo.dart';
import 'package:equatable/equatable.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final User user;
  BooksRepo booksRepo = BooksRepo();

  BooksCubit(this.user) : super(const RecommendedState([])) {
    updateRecommendation();
  }

  void cancelSearch() {
    if (state is! RecommendedState) {
      emit(RecommendedState(booksRepo.recommendation));
    }
  }

  Future<void> updateRecommendation() async {
    try {
      List<Book> result = await booksRepo.getRecommended(user.favCategories);
      loggList(result, from: BOOK_CUBIT, header: 'recommendeedd books : ');
      emit(RecommendedState(result));
    } catch (e) {
      logg("exception cautgh updating the recommentdation : $e ");

      emit(const DefaultBookExcpetion());
    }
  }

  Future<void> searchFor(String name) async {
    try {
      List<Book> result = await booksRepo.seachForBooks(name);
      emit(SearchState(result));
    } catch (e) {
      logg("exception cautgh while searching for  '$name' : $e ");
      emit(const DefaultBookExcpetion());
    }
  }
}
