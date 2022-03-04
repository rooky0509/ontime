import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontime/data/time.dart';
import 'package:ontime/data/saveData.dart';

import 'package:provider/provider.dart';


  /*
    값 읽기 : context.select((ScheduleProvider value) => value.count)
    값 변경 : context.read<ScheduleProvider>().add();
  */
class Schedule {
  ScheduleProvider provider = ScheduleProvider();
  String title = "Schedule"; //제목
  Widget card = ScheduleWidget(); //간략화된 위젯
  Widget page = SchedulePage(); //페이지 위젯
}

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> {
  @override
  void dispose(){
    print("Page Dispose");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("SchedulePage build");
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
  @override
  void dispose(){
    print("Widget Dispose");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print("ScheduleWidget build");
    return FutureBuilder(
      future: context.read<ScheduleProvider>().load(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }
        else {
          return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
/*P*/   Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center, 
            color: Colors.amber,
            child: Text(
              context.select((ScheduleProvider value){
                List datas = value.weekData;
                if(datas.isEmpty) return "x / 리스트가 비어있음";
                if(value.cellIndex==-1) return datas.last.toString();
                if(value.cellIndex==0) return "min / 이전 수업이 없음";
                return datas[value.cellIndex-1].toString();
              })
            )
          )
        ),
/*C*/   Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            child: context.select((ScheduleProvider value){
              int index = value.cellIndex;
              List datas = value.weekData;
              if(datas.isEmpty){ //등록된 데이터가 없음
                return Text("등록된 수업 없음 $index");
              }
              if(index == -1){ //뒤에있는 end가 없음
                return Text("수업 끝남 $index");
              }
              Map data = datas[index];
              DateTime now = value.now!;
              DateTime start = now.setTime(second: data['id']%86400);
              DateTime end = start.setTime(second: data['id']%86400 + data['len']);
              if(!value.onGoing){ //뒤에있는 end와 앞에있는 start가 같지 않음
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "다음수업은 ${data["title"]}입니다",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "${data["id"]%86400} / ${data["id"]~/86400}"
                    ),
                    Text(
                      "${start.format()} ~ ${end.format()}"
                    ),
                    Text(
                      "${now.setTime(second: end.difference(now).inSeconds).format(newPattern:"HH:mm:ss")}남음"
                    ),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    data["label"],
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Text(
                    data["title"],
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    data["detail"],
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),/* 
                  Text(
                    data["tag"],
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ), */
                  Text(
                    "${start.format()} ~ ${end.format()}"
                  ),
                  Text(
                    "${now.setTime(second: end.difference(now).inSeconds).format(newPattern:"HH:mm:ss")}남음" + now.format(newPattern: "HH:mm:ss.mmm")
                  ),
                ],
              );
            }),
            /*  */
          )
        ),
/*N*/   Expanded(
          flex: 1,
          child: Container(alignment: Alignment.center, color: Colors.amber,child: Text(
            context.select((ScheduleProvider value){ //"${(value.datas.isNotEmpty)&(value.datas.length>value.cellIndex)&(value.cellIndex>=-1)?value.datas[(value.cellIndex==-1?value.datas.length:value.cellIndex)-1]["id"]:''}"
              List datas = value.weekData;
              if(datas.isEmpty) return "x / 리스트가 비어있음";
              if(value.cellIndex==-1) return "- / 모든 수업이 끝남";
              if(!value.onGoing) return datas[value.cellIndex].toString();
              if(value.cellIndex+1==datas.length) return "MAX / 다음 수업이 없음";
              return datas[value.cellIndex+1].toString();
            }).toString()
          ),)
        ),
      ],
    );
        }
      }
    ); 
  }
}

class ScheduleProvider with ChangeNotifier {
  //#region SQLite
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
  //#endregion
  
  int _start = 0;//, week = 0;
  List datas = [], weekData = [];
  int cellIndex = -1, _weekIndex = 0, _selectWeekIndex = 0;
  bool onGoing = false;
  Timer? _timer;
  DateTime? now;

  Future<bool> load() async{
    datas = await get();
    timerOn();
    print(datas);
    return datas.isNotEmpty;
  }

  void timerOn() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) { 
      now = DateTime.now();
      _weekIndex = now!.weekday-1;

      weekData = datas.where((element) => ((86400*_weekIndex)<=element["id"]) & (element["id"]<(86400 * (_weekIndex+1))) ).toList();
      cellIndex = weekData.indexWhere((element)=>(now!.toSec() < element["id"]%86400+element["len"])); // next end
      onGoing = cellIndex==-1?false:(weekData[cellIndex]["id"]%86400 <= now!.toSec())&(now!.toSec() < weekData[cellIndex]["id"]%86400+weekData[cellIndex]["len"]);
      
      notifyListeners();
    });
  }

  void timerOff() {
    _timer!.cancel();
    notifyListeners();
  }
  
  void add() {
    print("[ScheduleProvider] add");
    notifyListeners();
  }

  void remove() {
    print("[ScheduleProvider] remove");
    notifyListeners();
  }

  Future<void> save() async{ // →DB( class => Map => save )
    print("[ScheduleProvider] ${now!.weekday}/$_start = ${now!.setTime(second: _start)}");
    print("[ScheduleProvider] save");
    _saveData.INSERT(data: {
      "id" : now!.setTime(second: _start).toSec(),//_id,
      "len" : 20,//_len,
      "label" : "label${now!.format()}",//_label,
      "title" : "label${now!.format()}",//_title,
      "detail" : "label${now!.format()}",//_detail,
      "tag" : "학교",//_tag,
    }).then((value) => print("[ScheduleProvider] ------save : FINISH"));
  }

  Future<List<Map<String, dynamic>>> get() async{ // ←DB( get => Map => calss )
    return await _saveData.SELECT(orderKey: "id");
  }

  Future<void> clear()async=>_saveData.DELETE();

}