import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontime/data/time.dart';
import 'package:ontime/data/saveData.dart';

import 'package:provider/provider.dart';


class Schedule {
  ScheduleProvider provider = ScheduleProvider();
  String title = "Schedule"; //제목
  Widget card = ScheduleWidget(); //간략화된 위젯
  Widget page = SchedulePage(); //페이지 위젯
}

/* class SchedulePage extends StatelessWidget {
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
} */
class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> {
  bool load = false;
  Widget build(BuildContext context) {
    if(!(load)) context.read<ScheduleProvider>().timerOn(build:true,text: "빌드(_SchedulePageState):위젯생성 => 값을 넣음 => 타이머 최초실행").then((value)=>setState(()=>load = true));
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: load?Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center, 
                color: Colors.amber,
                child: Text(
                  context.select((ScheduleProvider value){ //"${(value.datas.isNotEmpty)&(value.datas.length>value.cellIndex)&(value.cellIndex>=-1)?value.datas[(value.cellIndex==-1?value.datas.length:value.cellIndex)-1]["id"]:''}"
                    if(value.datas.isEmpty) return "x";
                    if(value.cellIndex==-1) return value.datas.last.toString();
                    if(value.cellIndex==0) return "min";
                    return value.datas[value.cellIndex-1].toString();
                  })
                )
              )
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: context.select((ScheduleProvider value){
                  int index = value.cellIndex;
                  if(value.datas.isEmpty){ //등록된 데이터가 없음
                    return Text("등록된 수업 없음 $index");
                  }
                  if(index == -1){ //뒤에있는 end가 없음
                    return Text("수업 끝남 $index");
                  }
                  Map data = value.datas[index];
                  if(!value.onGoing){ //뒤에있는 end와 앞에있는 start가 같지 않음
                    return Text("다음수업 : $index\n::${DateTime.now().setTime(second: data['id']%86400).format()} ~ ${DateTime.now().setTime(second: data['id']%86400+data['len']).format()}");
                  }
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
              child: Container(alignment: Alignment.center, color: Colors.amber,child: Text(
                context.select((ScheduleProvider value){ //"${(value.datas.isNotEmpty)&(value.datas.length>value.cellIndex)&(value.cellIndex>=-1)?value.datas[(value.cellIndex==-1?value.datas.length:value.cellIndex)-1]["id"]:''}"
                  if(value.datas.isEmpty) return "x";
                  if(value.cellIndex==-1) return "-";
                  if(value.cellIndex+1==value.datas.length) return "MAX";
                  return value.datas[value.cellIndex+1].toString();
                }).toString()
              ),)
            ),
            Expanded(
              flex: 1,
              child: Container(alignment: Alignment.center, color: Colors.blue,child: Text(
                context.select((ScheduleProvider value) => (value.now as DateTime).format(newPattern: "HH:mm:ss.mmm"))
              ),)
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
        ):CircularProgressIndicator(),
      
      )
    );
  }
}
class ScheduleWidget extends StatefulWidget {
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}
class _ScheduleWidgetState extends State<ScheduleWidget> {

  bool load = false;
  Widget build(BuildContext context) {
    if(!(load)) context.read<ScheduleProvider>().timerOn(build:true,text: "빌드(_ScheduleWidgetState):위젯생성 => 값을 넣음 => 타이머 최초실행").then((value)=>setState(()=>load = true));
    return load?Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center, 
            color: Colors.amber,
            child: Text(
              context.select((ScheduleProvider value){ //"${(value.datas.isNotEmpty)&(value.datas.length>value.cellIndex)&(value.cellIndex>=-1)?value.datas[(value.cellIndex==-1?value.datas.length:value.cellIndex)-1]["id"]:''}"
                if(value.datas.isEmpty) return "x / 리스트가 비어있음";
                if(value.cellIndex==-1) return value.datas.last.toString();
                if(value.cellIndex==0) return "min / 이전 수업이 없음";
                return value.datas[value.cellIndex-1].toString();
              })
            )
          )
        ),
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            child: context.select((ScheduleProvider value){
              int index = value.cellIndex;
              if(value.datas.isEmpty){ //등록된 데이터가 없음
                return Text("등록된 수업 없음 $index");
              }
              if(index == -1){ //뒤에있는 end가 없음
                return Text("수업 끝남 $index");
              }
              Map data = value.datas[index];
              DateTime now = DateTime.now();
              DateTime start = now.setTime(second: data['id']%86400);
              DateTime end = start.setTime(second: data['id']%86400 + data['len']);
              if(!value.onGoing){ //뒤에있는 end와 앞에있는 start가 같지 않음
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "다음수업은 "+data["title"]+"입니다",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
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
                    "${now.setTime(second: end.difference(now).inSeconds).format(newPattern:"HH:mm:ss")}남음"
                  ),
                ],
              );
            }),
            /*  */
          )
        ),
        Expanded(
          flex: 1,
          child: Container(alignment: Alignment.center, color: Colors.amber,child: Text(
            context.select((ScheduleProvider value){ //"${(value.datas.isNotEmpty)&(value.datas.length>value.cellIndex)&(value.cellIndex>=-1)?value.datas[(value.cellIndex==-1?value.datas.length:value.cellIndex)-1]["id"]:''}"
              if(value.datas.isEmpty) return "x / 리스트가 비어있음";
              if(value.cellIndex==-1) return "- / 모든 수업이 끝남";
              if(!value.onGoing) return value.datas[value.cellIndex].toString();
              if(value.cellIndex+1==value.datas.length) return "MAX / 다음 수업이 없음";
              return value.datas[value.cellIndex+1].toString();
            }).toString()
          ),)
        ),/* 
        Expanded(
          flex: 1,
          child: Container(alignment: Alignment.center, color: Colors.blue,child: Text(
            context.select((ScheduleProvider value) => (value.now as DateTime).format(newPattern: "HH:mm:ss.mmm"))
          ),)
        ), */
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
  bool onGoing = false;
  Timer? _timer;
  DateTime? now;

  String _str = ""; //테슽트용 텍스트
  String get str => _str;

  Future<void> timerOn({String text = "정보없음", bool? build}) async{
    print("[ScheduleProvider] [[$text]] => 타이머 실행");
    if(build??false) {
      await get();
    }
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) { 
      print("[ScheduleProvider] 타이머 실행중");
      now = DateTime.now();
      _weekIndex = now!.weekday-1;
      cellIndex = datas.indexWhere((element)=>(element["id"]%86400+element["len"] > now!.toSec())); // next end
      onGoing = cellIndex==-1?false:(datas[cellIndex]["id"]%86400 < now!.toSec())&(datas[cellIndex]["id"]%86400+datas[cellIndex]["len"] > now!.toSec());
      if(datas.isEmpty) {
        timerOff(text : "데이터가 비어있음 => 타이머종료");
      }else if(cellIndex == -1) {
        timerOff(text : "인덱스가 -1임 == 모든수업끝시간보다 늦음 => 타이머종료");
      }


      _start = now!.toSec(); //test


      notifyListeners();
    });
  }

  void timerOff({String text = "정보없음"}) {
    print("[ScheduleProvider] [[$text]] => 타이머 종료");
    _timer!.cancel();
    notifyListeners();
  }
  
  void add() {
    print("[ScheduleProvider] add");
    now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    _start = now!.toSec();
    _weekIndex = now!.weekday-1;

    _id = _start + (86400 * _weekIndex);// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    _label = "1교시";
    _title = "Title";
    _detail = "Detail";
    _tag = "학교";

    print("[ScheduleProvider] ${now!.weekday}/$_start = ${now!.setTime(second: _start)}");
    notifyListeners();
  }

  void remove() {
    print("[ScheduleProvider] remove");
    _len += 10;
    print("[ScheduleProvider] $_len");
    notifyListeners();
  }

  Future<void> save() async{ // →DB( class => Map => save )

    now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    _start = now!.toSec();
    _weekIndex = now!.weekday-1;

    _id = _start + (86400 * _weekIndex) + _len;// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    _label = "1교시";
    _title = "T [$_id]";
    _detail = "Detail";
    _tag = "학교";

    print("[ScheduleProvider] ${now!.weekday}/$_start = ${now!.setTime(second: _start)}");


    print("[ScheduleProvider] save");
    _saveData.INSERT(data: {
      "id" : _id,
      "len" : _len,
      "label" : "${_len/10}교시",
      "title" : _title,
      "detail" : "$_detail : $_weekIndex",
      "tag" : _tag,
    }).then((value) => print("[ScheduleProvider] ------save : FINISH"));
  }

  Future<void> get() async{ // ←DB( get => Map => calss )
    _saveData.SELECT(orderKey: "id").then((value){
      datas = value;
      timerOn(text:"데이터를 받음 => 타이머실행");
      notifyListeners(); 
      print("[ScheduleProvider] getAll[${value.length}]"); //test
    });
  }

  Future<void> clear()async=>_saveData.DELETE();

}