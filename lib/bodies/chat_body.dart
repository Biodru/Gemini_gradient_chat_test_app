import 'package:flutter/material.dart';
import 'package:gemini_test_app/message.dart';
import 'package:gemini_test_app/app_constants.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    super.key,
    required ScrollController scrollController,
    required this.messages,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) => index == messages.length - 1
            ? _SlideInMessageWidget(
                isUser: messages[index].isUser,
                child: _MessageTile(
                  message: messages[index],
                ),
              )
            : _MessageTile(
                message: messages[index],
              ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: message.isUser
                ? const Color(0x99C06C84)
                : Colors.white.withOpacity(0.4),
            borderRadius: message.isUser
                ? const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: message.isUser ? 18 : 16,
              foreground: Paint()..shader = AppConstants.appGradient,
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideInMessageWidget extends StatefulWidget {
  const _SlideInMessageWidget({
    super.key,
    required this.child,
    required this.isUser,
  });

  final Widget child;
  final bool isUser;

  @override
  State<_SlideInMessageWidget> createState() => _SlideInMessageWidgetState();
}

class _SlideInMessageWidgetState extends State<_SlideInMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(widget.isUser ? 1 : -1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
