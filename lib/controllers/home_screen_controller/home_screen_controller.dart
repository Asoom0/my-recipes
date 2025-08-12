import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenCubit extends Cubit<int> {
  HomeScreenCubit() : super(0); // Start at index 0

  void goTo(int index) => emit(index);
}
