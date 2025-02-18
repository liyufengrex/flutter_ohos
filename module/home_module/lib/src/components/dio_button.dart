import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 演示纯 Dart 实现的三方网络库
class DioButton extends StatelessWidget {
  const DioButton({super.key});

  void getHttp() async {
    final dio = Dio();
    final response = await dio.get('https://dart.cn');
    Fluttertoast.showToast(msg: response.data);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getHttp();
      },
      child: const Text('Dio Request'),
    );
  }
}
