import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/translation.dart';

part 'translation_event.dart';
part 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc()
      : super(LanguageChanged(locale: translation.selectedLocale)) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<TranslationState> emit) async {
    await translation.setLanguage(
      language: event.language,
      save: event.save,
    );
    emit(LanguageChanged(locale: translation.selectedLocale));
  }
}