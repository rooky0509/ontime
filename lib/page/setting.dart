import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';


class Setting extends StatelessWidget {
  ChangeNotifier provider = SettingProvider();

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
                child: SettingWidget(),
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