import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontime/data/time.dart';
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
            width: 40
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
          SizedBox(
            width: 40,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ScheduleProvider>().clear();
            },
            child: Icon(Icons.delete)
          ),
        ],
      ),
    );
  }
}

class ScheduleWidget extends StatefulWidget {
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}
class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool load = false;
  @override
  Widget build(BuildContext context) {
    if(!(load)) context.read<ScheduleProvider>().timerOn().then((value)=>setState(()=>load = true));
    return load?Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Container(alignment: Alignment.center, color: Colors.amber,child: Text(
            context.select((ScheduleProvider value) => "${value.datas}교시").toString()
          ),)
        ),
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            child: context.select((ScheduleProvider value){
              int index = value.cellIndex;
              if(value.datas.isEmpty){
                return Text("등록된 수업 없음");
              }
              if(index == -1){
                return Text("수업 끝남");
              }
              Map data = value.datas[index];
              return Column(
                children: <Widget>[
                  Text(
                    data["label"]
                  ),
                  Text(
                    data["title"]
                  ),
                  Text(
                    data["detail"]
                  ),
                  Text(
                    data["tag"]
                  ),
                  Text(
                    "${DateTime.now().setTime(second: data['id']%86400).format()} ~ ${DateTime.now().setTime(second: data['id']%86400+data['len']).format()}"
                  ),
                ],
              );
            }),
            /*  */
          )
        ),
        Expanded(
          flex: 1,
          child: Container(alignment: Alignment.center, color: Colors.blue,child: Text(
            context.select((ScheduleProvider value) => "${value.now}").toString()
          ),)
        ),
      ],
    ):CircularProgressIndicator();
  }
}

class ScheduleProvider with ChangeNotifier {
  final SaveData _saveData = SaveData(tableName: "schedule", tableAttributede: {
    "id" : "INTEGER PRIMARY KEY",
    "len" : "INTEGER",
    "label" : "TEXT",
    "title" : "TEXT",
    "detail" : "TEXT",
    "tag" : "TEXT",
  });
  int _id = 0;
  int _len = 0;
  String _label = "";
  String _title = "";
  String _detail = "";
  String _tag = "";

  int _start = 0;//, week = 0;
  List datas = [];
  int cellIndex = -1, _weekIndex = 0, _selectWeekIndex = 0;
  Timer? _timer;
  DateTime? now;

  String _str = ""; //테슽트용 텍스트
  String get str => _str;


  Future<void> timerOn() async{
    print("timer on");
    await get();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) { 
      //add();
      now = DateTime.now();
      print(now!.toSec());
      _weekIndex = now!.weekday-1;
      _start = now!.toSec();
      cellIndex = datas.indexWhere((element) => (element["id"]%86400 < now!.toSec())&(element["id"]%86400+element["len"] > now!.toSec()));
      _str = "$cellIndex[${cellIndex!=-1?(datas[cellIndex]["id"]+datas[cellIndex]["len"]):"none"}]\n[${_start + (86400 * _weekIndex)}//$_id//$_len]\n[$_title//$_detail]\n[$_start//$_weekIndex]\n";
      //id = 0;
      //len = 0;
      //title = "";
      //detail = "";
      notifyListeners();
    });
    print("timer on end");
  }

  void timerOff() {
    _timer!.cancel();
    notifyListeners();
  }
  
  void add() {
    print("[ScheduleProvider] add");
    DateTime now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    _start = now.toSec();
    _weekIndex = now.weekday-1;

    _id = _start + (86400 * _weekIndex);// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    _label = "1교시";
    _title = "Title";
    _detail = "Detail";
    _tag = "학교";

    print("${now.weekday}/$_start = ${now.set(second: _start)}");
    notifyListeners();
  }

  void remove() {
    print("[ScheduleProvider] remove");
    _len += 10;
    print("$_len");
    notifyListeners();
  }

  Future<void> save() async{ // →DB( class => Map => save )
    print("[ScheduleProvider] save");
    _saveData.INSERT(data: {
      "id" : _id+60,
      "len" : _len,
      "label" : "${_len/10}교시",
      "title" : _title,
      "detail" : "$_detail : $_weekIndex",
      "tag" : _tag,
    }).then((value) => print("------save : FINISH"));
  }

  Future<void> get() async{ // ←DB( get => Map => calss )
    _saveData.SELECT(orderKey: "id").then((value){
      datas = value;
      notifyListeners(); 
      print("getAll : value = [\n${value.join(',\n')}\n]");
    });
  }

  Future<void> clear()async=>_saveData.DELETE();
}