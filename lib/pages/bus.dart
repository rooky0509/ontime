import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ontime/data/saveData.dart';

class Bus {
  BusProvider provider = BusProvider();
  String title = "Bus"; //제목
  Widget card = BusWidget(); //간략화된 위젯
  Widget page = BusPage(); //페이지 위젯
  void loading ()=> BusProvider().get();
}

class BusPage extends StatelessWidget {
  /*
    값 읽기 : context.select((BusProvider value) => value.count)
    값 변경 : context.read<BusProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BusPage!\n${context.select((BusProvider value) => value.str).toString()}", // count를 화면에 출력
            style: TextStyle(
              fontSize: 40.0,
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
      ),
    );
  }
}

class BusWidget extends StatefulWidget {
  @override
  _BusWidgetState createState() => _BusWidgetState();
}
class _BusWidgetState extends State<BusWidget> {
  bool load = false;
  @override
  Widget build(BuildContext context) {
    print("[BusWidget] load{$load}");
    if(!(load)) {
      print("[BusWidget] load is start");
      context.read<BusProvider>().get().then((value){
        print("[BusWidget] load is finish");
        setState(() {load = true;});
      });
    }
    print("[BusWidget] build{$load}");
    return load?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((BusProvider value) => "BusProvider\n${value.str}").toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 20.0),
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
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<BusProvider>().clear();
          },
          child: Icon(Icons.delete)
        ),
      ],
    ):CircularProgressIndicator();
  }
}

class BusProvider with ChangeNotifier {
  int start = 0;
  int len = 0;
  int week = 0;
  String title = "";
  String detail = "";

  String _str = "";
  String get str => _str;

  final SaveData _saveData = SaveData(tableName: "Bus", tableAttributede: {
    "start" : "INTEGER PRIMARY KEY",
    "len" : "INTEGER",
    "title" : "TEXT",
    "detail" : "TEXT",
  });
  
  void add() {
    print("[BusProvider] add");
    DateTime now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    week = now.weekday-1;
    start = (now.hour*3600 + now.minute*60 + now.second) + (86400 * week);// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    title = "Title : $start ~ ${start+len}";
    detail = "Detail : ${start%86400} ~ ${(start+len)%86400}";
    print("${now.weekday}/$start = ${DateTime(now.year,now.month,now.day).add(Duration(seconds: start))}");
    notifyListeners();
  }

  void remove() {
    print("[BusProvider] remove");
    len += 10;
    print("$len");
    notifyListeners();
  }

  Future<void> save() async{ // →DB
    print("[BusProvider] save");
    _saveData.INSERT(data: {
      "start" : start,
      "len" : len,
      "title" : title,
      "detail" : "$detail : $week",
    }).then((value) => print("------save : FINISH"));
  }


  Future<void> get() async{  // ←DB
    print("[BusProvider] get");
    print("------get : START");
    //_saveData.SELECT().then((value) => print("getAll : value = [\n  ${value.join(',\n  ')}\n]"));
    //_saveData.SELECT().then((value) => print("getAll : value = [  ${value.join(',  ')}  ]"));
    _saveData.SELECT(orderKey: "start").then((value){
      print("get : value =  : $value");
      if(value.isEmpty){
        _str = "value is Empty";
        notifyListeners();
        print("get : value is Empty");
      }else{
        int l = value.length-1;
        start = value[l]["start"]%86400;
        len = value[l]["len"];
        week = value[l]["start"]~/86400;
        title = value[l]["title"];
        detail = value[l]["detail"];
        _str = "${value[l]["start"]}=>\nstart : $start[$len] \n$title \n$detail";
        notifyListeners();
        print("------get : FINISH");
      }
    });
  }

  Future<void> clear() async{  // ←DB
    print("[ScheduleProvider] clear");
    print("------clear : START");
    _saveData.DELETE().then((value){
      print("------clear : FINISH");
    });
  }
}
//Navigator.pop(context);