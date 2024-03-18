import 'package:flutter/material.dart';
import 'package:strife/models/message_content.dart';

Widget ChatRightItems(MessageContent item) {
  return Container(
    padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 230,
            // maxHeight: 40
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 10, top: 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromARGB(255, 176, 106, 231),
              //     Color.fromARGB(255, 166, 112, 231),
              //     Color.fromARGB(255, 131, 123, 231),
              //     Color.fromARGB(255, 104, 132, 231),
              //   ],
              //   transform: GradientRotation(90),
              // ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(item.content),
          ),
        )
      ],
    ),
  );
}