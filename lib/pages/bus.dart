import 'package:flutter/material.dart';
import 'package:ontime/data/saveData.dart';
import 'package:provider/provider.dart';

class Bus {
  BusProvider provider = BusProvider();
  String title = "Bus"; //제목
  Widget card = BusWidget(); //간략화된 위젯
  Widget page = BusPage(); //페이지 위젯
}

class BusPage extends StatelessWidget {
  /*
    값 읽기 : context.select((BusProvider value) => value.count)
    값 변경 : context.read<BusProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((BusProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(
            fontSize: 100.0,
            backgroundColor: Colors.amber,
            color: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class BusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((BusProvider value) => value.str).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 40.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().remove();
          },
          child: Icon(Icons.remove)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().save();
          },
          child: Icon(Icons.save)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().get();
          },
          child: Icon(Icons.get_app)
        ),
      ],
    );
  }
}

class BusProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;  
  String _str = "123123";
  String get str => _str;  
  final SaveData _saveData = SaveData(tableName: "SCtest", tableAttributede: {
    "str" : "INTEGER PRIMARY KEY",
  });

  void add() {
    DateTime now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    _str = now.toIso8601String(); //DateTime.now().difference(DateTime(2022,02,28,0,0,0)).inSeconds
    // now.hour*3600 + now.minute*60 + now.second
    // DateTime get = DateTime(now.year,now.month,now.day);
    // print(get.add(Duration(seconds: _count)));
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }

  void save() async{ // →DB
    print("\n\n------save : START");
    _saveData.INSERT(data: {
      "str" : count,//start,
    }).then((value) => print("------save : FINISH"));
  }

  void get() async{  // ←DB
    print("\n\n------get : START");
    //_saveData.SELECT().then((value) => print("getAll : value = [\n  ${value.join(',\n  ')}\n]"));
    _saveData.SELECT().then((value){
      print("get : value =  : $value");
      if(value.isEmpty){
        print("get : value is Empty");
      }else{
        _str = value[0]["str"];
        notifyListeners();
        print("------get : FINISH");
      }
    });
  }
}
//Navigator.pop(context);