import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_test_app/bodies/chat_body.dart';
import 'package:gemini_test_app/bodies/initial_body.dart';
import 'package:gemini_test_app/cubit/app_cubit.dart';
import 'package:gemini_test_app/message.dart';
import 'package:gemini_test_app/app_constants.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff355C7D),
                  Color(0xff6C5B7B),
                  Color(0xffC06C84),
                ],
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AppCubit(),
            child: BlocBuilder<AppCubit, AppState>(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  final isInitialScreen = state.items?.isEmpty ?? true;
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        isInitialScreen
                            ? const Spacer()
                            : const SizedBox.shrink(),
                        Text(
                          isInitialScreen
                              ? 'Dzień dobry człowieku\nOd czego zaczynamy?'
                              : 'Rozmawiajmy!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = AppConstants.appGradient,
                          ),
                        ),
                        isInitialScreen
                            ? const Spacer()
                            : const SizedBox.shrink(),
                        isInitialScreen
                            ? InitialBody(prompts: state.prompts)
                            : ChatBody(
                                scrollController: _scrollController,
                                messages: state.items ?? [],
                              ),
                        isInitialScreen
                            ? const Spacer()
                            : const SizedBox.shrink(),
                        _ChatTextField(
                          controller: _textController,
                          onPressed: () async {
                            await context.read<AppCubit>().addMessage(
                                  message: Message(
                                    text: _textController.text,
                                    isUser: true,
                                  ),
                                  textController: _textController,
                                  scroll: _scrollController,
                                );
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _ChatTextField extends StatelessWidget {
  const _ChatTextField({
    super.key,
    required TextEditingController controller,
    required this.onPressed,
  }) : _controller = controller;

  final Function() onPressed;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  foreground: Paint()..shader = AppConstants.appGradient,
                ),
                decoration: InputDecoration(
                  hintText: 'Napisz mi coś',
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        foreground: Paint()..shader = AppConstants.appGradient,
                      ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color(0xffee9ca7),
                  Color(0xffffdde1),
                ],
              ).createShader(
                bounds,
              ),
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
