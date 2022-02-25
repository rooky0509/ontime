import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Counter');

    return Text(
      context.watch<Providerr>().count.toString(),
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              context.read<Providerr>().add();
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<Providerr>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}