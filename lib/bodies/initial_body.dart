import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_test_app/cubit/app_cubit.dart';
import 'package:gemini_test_app/model/message.dart';
import 'package:gemini_test_app/utility/app_constants.dart';

/// Displays InitialApp state with:
///
/// * welcome message
///
/// * basic prompts for user
class InitialBody extends StatelessWidget {
  const InitialBody({
    super.key,
    required this.prompts,
  });

  final List<String> prompts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prompts
            .map(
              (prompt) => _StartingPromptTile(prompt: prompt),
            )
            .toList(),
      ),
    );
  }
}

class _StartingPromptTile extends StatelessWidget {
  const _StartingPromptTile({
    super.key,
    required this.prompt,
  });

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          await context.read<AppCubit>().addMessage(
                message: Message(
                  text: prompt,
                  isUser: true,
                ),
              );
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
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
                    child: const Icon(
                      Icons.auto_awesome,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  16,
                ),
                child: Text(
                  prompt,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  maxLines: 4,
                  style: TextStyle(
                    fontSize: 18,
                    foreground: Paint()..shader = AppConstants.appGradient,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
