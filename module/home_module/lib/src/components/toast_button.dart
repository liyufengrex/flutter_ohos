import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 演示依赖系统底层实现的三方库
class ToastButton extends StatelessWidget {
  const ToastButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Fluttertoast.showToast(msg: 'HELLO WORLD ~');
      },
      child: const Text('Flutter Toast'),
    );
  }
}
