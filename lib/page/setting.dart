import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Text("SettingPage")
      )
    );
  }
}

class SettingWidget extends StatelessWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SettingPageCounter');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          "SettingProvider : ${context.watch<SettingProvider>().count.toString()}",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              context.read<SettingProvider>().add();
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<SettingProvider>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
//Navigator.pop(context);