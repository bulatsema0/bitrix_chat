import 'package:auto_route/annotations.dart';
import 'package:bitrix_chat/app/blueprints/base_page_view.dart';
import 'package:bitrix_chat/views/bitrixs_view/bitrix_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BitrixView extends StatelessWidget {
  const BitrixView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BitrixViewModel(),
      builder: (context, child) {
        return BasePageView<BitrixViewModel>(
          appBar: AppBar(
            title: const Text('Bitrixs Chat'),
          ),
          content: const _ViewContent(),
        );
      },
    );
  }
}

String? tryParseDateString(String str) {
  try {
    return DateFormat('dd.MM.yyyy HH:mm', 'tr_TR').format(DateTime.parse(str));
  } catch (_) {
    return null;
  }
}

class _ViewContent extends StatefulWidget {
  const _ViewContent();

  @override
  __ViewContentState createState() => __ViewContentState();
}

class __ViewContentState extends State<_ViewContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<BitrixViewModel>(
            builder: (context, viewModel, child) {
              viewModel.getDialogMessages('chat1');
              return ListView.builder(
                controller: _scrollController,
                itemCount: viewModel.messageList.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = viewModel.messageList[index];
                  String? date = tryParseDateString(viewModel.dateStart);
                  String messageSentTime;
                  if (date != null) {
                    messageSentTime = date;
                  } else {
                    messageSentTime = 'Invalid date';
                  }
                  return _MessageBubble(
                    message: message.message,
                    messageSentTime: messageSentTime,
                    isSentByUser: message.isSentByUser,
                  );
                },
              );
            },
          ),
        ),
        _MessageInput(scrollController: _scrollController),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByUser;
  final String messageSentTime;

  const _MessageBubble({
    Key? key,
    required this.message,
    required this.isSentByUser,
    required this.messageSentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isSentByUser ? 2 : 1,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: isSentByUser ? const SizedBox.shrink() : _buildImage(),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isSentByUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: isSentByUser ? Colors.white : Colors.black,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: isSentByUser ? 1 : 2,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: isSentByUser ? _buildImage() : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            messageSentTime,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey, fontSize: 10),
          ),
        )
      ],
    );
  }

  Widget _buildImage() {
    return isSentByUser
        ? Image.asset(
            'assets/images/chatbot.png',
            width: 30.0,
            height: 20.0,
          )
        : Image.asset(
            'assets/images/chatbot.png',
            width: 30.0,
            height: 20.0,
          );
  }
}

class _MessageInput extends StatelessWidget {
  final ScrollController scrollController;

  const _MessageInput({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BitrixViewModel>();
    final textEditingController =
        context.read<BitrixViewModel>().messageController;

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: textEditingController,
              onChanged: (value) {
                viewModel.setMessage(value);
              },
              decoration: const InputDecoration(
                hintText: 'Mesajınızı girin',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (textEditingController.text.isNotEmpty) {
                await viewModel.sendMessage();
                textEditingController.clear();
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
