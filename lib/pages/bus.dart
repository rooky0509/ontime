import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/providers.dart';


class Bus extends StatelessWidget {
  ChangeNotifier provider = BusProvider();

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
                child: BusWidget(),
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

class BusProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void add() {
    _count++;
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }
}
//Navigator.pop(context);