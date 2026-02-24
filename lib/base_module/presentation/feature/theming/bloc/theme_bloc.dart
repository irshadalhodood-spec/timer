import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/app_theme_singleton.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(appTheme.themeState) {
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<ThemeState> emit) async {
    await appTheme.setThemeType(themeType: event.themeType);
    emit(appTheme.themeState);
  }
}
