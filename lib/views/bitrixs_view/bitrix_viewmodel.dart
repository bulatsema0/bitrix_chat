import 'dart:async';

import 'package:bitrix_chat/app/blueprints/base_viewmodel.dart';
import 'package:bitrix_chat/services/bitrixs_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BitrixViewModel extends BaseViewModel {
  final TextEditingController messageController = TextEditingController();
  final StreamController<List<dynamic>> _messageStreamController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get messageStream => _messageStreamController.stream;
  BitrixViewModel();

  @override
  void disposeModel() {}

  @override
  Future<void> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    super.setViewDidLoad(true);
  }

  final BitrixApiService _bitrixApiService = BitrixApiService();
  BitrixApiService get bitrixApiService => _bitrixApiService;

  List<dynamic> messageList = [];
  String message = '';
  String dateStart = '';

  void setMessage(String value) {
    message = value;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    try {
      await bitrixApiService.sendMessage('chat1', message).then((response) {
        final responseData = response as Map<String, dynamic>;
        dateStart = responseData['time']['date_start'];
        final sentMessage = ChatMessage(
          message: message,
          isSentByUser: true,
          messageSentTime: '',
        );
        messageList.insert(0, sentMessage);
        _messageStreamController.add(messageList);
      }).catchError((error) {});
    } catch (e) {
      print('Error: $e');
    }

    message = '';
    notifyListeners();
  }

  Future<void> getDialogMessages(String dialogId) async {
    try {
      final response = await bitrixApiService.getDialogMessages(dialogId);
      final messages = response['result']['messages'] as List<dynamic>;
      final chatMessages = messages.map<ChatMessage>((message) {
        final messageDate = DateTime.parse(message['date']);
        final formattedDate =
            DateFormat('dd.MM.yyyy HH:mm', 'tr_TR').format(messageDate);
        return ChatMessage(
          message: message['text'],
          isSentByUser: message['author_id'] == 724,
          messageSentTime: formattedDate,
        );
      }).toList();

      messageList = chatMessages; // Assign the chatMessages to messageList

      _messageStreamController
          .add(chatMessages); // Add chatMessages to the stream
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }
}

class ChatMessage {
  final String message;
  final bool isSentByUser;
  final String messageSentTime;
  ChatMessage(
      {required this.message,
      required this.isSentByUser,
      required this.messageSentTime});
}
