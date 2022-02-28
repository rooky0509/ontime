import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ontime/data/saveData.dart';

class Schedule {
  ScheduleProvider provider = ScheduleProvider();
  String title = "Schedule"; //제목
  Widget card = ScheduleWidget(); //간략화된 위젯
  Widget page = SchedulePage(); //페이지 위젯
}

class SchedulePage extends StatelessWidget {
  /*
    값 읽기 : context.select((ScheduleProvider value) => value.count)
    값 변경 : context.read<ScheduleProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SchedulePage!\n${context.select((ScheduleProvider value) => value.str).toString()}", // count를 화면에 출력
            style: TextStyle(
              fontSize: 40.0,
              backgroundColor: Colors.amber,
              color: Colors.blue,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ScheduleProvider>().add();
            },
            child: Icon(Icons.add,)
          ),
          SizedBox(
            width: 40,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ScheduleProvider>().remove();
            },
            child: Icon(Icons.remove)
          )
        ],
      ),
    );
  }
}

class ScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((ScheduleProvider value) => value.str).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 20.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().remove();
          },
          child: Icon(Icons.remove)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().save();
          },
          child: Icon(Icons.save)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().get();
          },
          child: Icon(Icons.get_app)
        ),
      ],
    );
  }
}

class ScheduleProvider with ChangeNotifier {
  int start = 0;
  int len = 0;
  int week = 0;
  String title = "";
  String detail = "";

  String _str = "";
  String get str => _str;  
  final SaveData _saveData = SaveData(tableName: "sabvbe", tableAttributede: {
    "start" : "INTEGER PRIMARY KEY",
    "len" : "INTEGER",
    "title" : "TEXT",
    "detail" : "TEXT",
  });

  void add() {
    DateTime now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    week = now.weekday-1;
    start = (now.hour*3600 + now.minute*60 + now.second) + (86400 * week);// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    title = "Title : $start ~ ${start+len}";
    detail = "Detail : ${start%86400} ~ ${(start+len)%86400}";
    print("${now.weekday}/$start = ${DateTime(now.year,now.month,now.day).add(Duration(seconds: start))}");
    notifyListeners();
  }

  void remove() {
    len += 10;
    print("$len");
    notifyListeners();
  }

  void save() async{ // →DB
    print("\n\n------save : START");
    _saveData.INSERT(data: {
      "start" : start,
      "len" : len,
      "title" : title,
      "detail" : "$detail : $week",
    }).then((value) => print("------save : FINISH"));
  }


  void get() async{  // ←DB
    print("\n\n------get : START");
    //_saveData.SELECT().then((value) => print("getAll : value = [\n  ${value.join(',\n  ')}\n]"));
    _saveData.SELECT(orderKey: "start").then((value){
      print("get : value =  : $value");
      if(value.isEmpty){
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
}
//Navigator.pop(context);