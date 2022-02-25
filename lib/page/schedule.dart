import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';


class Schedule extends StatelessWidget {
  ChangeNotifier provider = ScheduleProvider();
  Schedule({provider});

  Widget setProvider(ChangeNotifier provider){
    this.provider = provider;
    return this;
  }

  @override
  Widget build(BuildContext context) {  
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
              create: (BuildContext context) => provider,
              child: Container(
                color: Colors.teal.withOpacity(0.03),
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: ScheduleWidget(),
              )
            ),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            minWidth: double.infinity,
            height: 100,
            //color: (cols[index%cols.length]).shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(100))),
            child: Text("Open[$key]"),
          ),
        ],
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
            child: Icon(Icons.add,size: 40,)),
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