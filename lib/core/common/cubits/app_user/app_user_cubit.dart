import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserCubitInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserCubitInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}
