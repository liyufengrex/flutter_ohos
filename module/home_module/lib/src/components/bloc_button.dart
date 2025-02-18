import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 演示纯 Dart 实现的三方状态管理库
class BlocButton extends StatefulWidget {
  const BlocButton({super.key});

  @override
  State<BlocButton> createState() => _BlocButtonState();
}

class _BlocButtonState extends State<BlocButton> {
  late CounterCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CounterCubit();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<CounterCubit, int>(
          bloc: _bloc,
          builder: (context, state) {
            return Text("Bloc current state: "+ state.toString());
          },
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          mini: true,
          child: Icon(Icons.add, size: 15),
          onPressed: () => _bloc.increment(),
        ),
      ],
    );
  }
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
