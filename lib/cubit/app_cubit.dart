import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_test_app/model/message.dart';
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
      GenerateContentResponse response;

      /// Add [Message] entered by user or by starting prompt
      messages.add(message);

      /// Emit new state with updated messages list and loading state
      emit(state.copyWith(items: messages, isLoading: true));

      /// Create [GenerativeModel], send user's prompt
      /// If there is an image, create ['gemini-pro-vision'] and send image data
      /// If there is only text prompt, create ['gemini-pro']
      if (state.image != null) {
        final model = GenerativeModel(
          model: 'gemini-pro-vision',
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );
        final prompt = TextPart(message.text.trim());
        final content = [
          Content.multi([prompt, state.image!])
        ];
        response = await model.generateContent(content);
      } else {
        final model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );
        final prompt = message.text.trim();
        final content = [Content.text(prompt)];
        response = await model.generateContent(content);
      }

      /// After receiving answer from Gemini, add it to messages list
      messages.add(Message(text: response.text!, isUser: false));

      /// Clear textField, animate list to scroll to the bottom
      textController?.clear();
      scroll?.animateTo(
        scroll.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );

      /// Emit new state with updated messages list, clear photo and set loading as false to rebuild tree
      emit(state.copyWith(
        items: messages,
        isLoading: false,
        image: null,
      ));
    } catch (e) {
      print(e);
    }
  }

  /// Method to set image
  void addImage(DataPart image) {
    emit(state.copyWith(image: image));
  }
}
