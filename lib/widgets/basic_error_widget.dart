


import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class BasicErrorWidget extends StatelessWidget {
  final String? error;
  const BasicErrorWidget(
      {Key? key,
      this.error = "Bağlantı Hatası! İnternet bağlantınız kopmuş olabilir."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Bubble(
        elevation: 10,
        margin: const BubbleEdges.all(10),
        alignment: Alignment.center,
        nip: BubbleNip.no,
        color: const Color(0xFF495355),
        shadowColor: Theme.of(context).shadowColor,
        child: Text(
          error ?? "Bilinmeyen Hata",
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
