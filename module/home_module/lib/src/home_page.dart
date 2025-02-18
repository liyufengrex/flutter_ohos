import 'package:flutter/material.dart';
import 'package:home_module/src/components/bloc_button.dart';
import 'package:home_module/src/components/dio_button.dart';
import 'package:home_module/src/components/toast_button.dart';

/// 模仿一个公共页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('1. 演示纯 Dart 实现的三方状态管理库'),
        SizedBox(height: 5),
        BlocButton(),
        SizedBox(height: 15),
        Text('2. 演示纯 Dart 实现的三方网络库   '),
        DioButton(),
        SizedBox(height: 15),
        Text('3. 演示依赖系统底层实现的三方库    '),
        ToastButton(),
      ],
    );
  }
}
