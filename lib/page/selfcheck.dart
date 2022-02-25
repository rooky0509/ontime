import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';

class Selfcheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Text("SelfcheckPage")
      )
    );
  }
}

class SelfcheckWidget extends StatelessWidget {
  const SelfcheckWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SelfcheckPageCounter');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          "SelfcheckProvider : ${context.watch<SelfcheckProvider>().count.toString()}",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              context.read<SelfcheckProvider>().add();
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<SelfcheckProvider>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
//Navigator.pop(context);