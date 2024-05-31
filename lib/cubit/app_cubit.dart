import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_test_app/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'app_states.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState.initial());

  final List<Message> messages = [];

  Future<void> addMessage({
    required Message message,
    ScrollController? scroll,
    TextEditingController? textController,
  }) async {
    try {
      messages.add(message);
      emit(state.copyWith(items: messages, isLoading: true));
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );
      final prompt = message.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      messages.add(Message(text: response.text!, isUser: false));
      textController?.clear();
      scroll?.animateTo(
        scroll.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
      emit(state.copyWith(items: messages, isLoading: false));
    } catch (e) {
      print(e);
    }
  }
}
