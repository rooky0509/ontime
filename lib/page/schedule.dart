import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';


class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Text("SchedulePage")
      )
    );
  }
}

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SchedulePageCounter');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          "ScheduleProvider : ${context.watch<ScheduleProvider>().count.toString()}",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              context.read<ScheduleProvider>().add();
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<ScheduleProvider>().remove();
            },
            child: Icon(Icons.remove))
      ],
    );
  }
}
//Navigator.pop(context);