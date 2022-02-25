import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';

class Bus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Text("BusPage")
      )
    );
  }
}

class BusWidget extends StatelessWidget {
  const BusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('BusPageCounter');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          "BusProvider : ${context.watch<BusProvider>().count.toString()}",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              context.read<BusProvider>().add();
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<BusProvider>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
//Navigator.pop(context);