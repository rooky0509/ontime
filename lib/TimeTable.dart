import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'SaveData.dart';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}
//{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
class _TimeTableState extends State<TimeTable> {

  //#region value
  //double height = MediaQuery.of(context).size.height
  
  SaveData saveData = SaveData();
  Map<int,List<Cell>> data = {0:[],1:[],2:[],3:[],4:[],5:[],6:[],};  //{0:[Cell(),Cell()],1:[Cell(),Cell()],}
  
  DateTime today = DateTime.now();
  int weekActiveIndex = 0;
  int cellActiveIndex = -1;

  String keyStr(int weekIndex){
    return "cellList_$weekIndex";
  }
  void load(int weekIndex) async{
    List<String> fromeSaveList= await saveData.getStringList( keyStr(weekIndex) );
    data[weekIndex] = fromeSaveList.map((e){
      Cell loadCell = Cell().fromString(e);
      return loadCell;
    }).toList()..sort((a,b)=> a.remainDuration(b.toDateTime(today,type: true))["startYet"]?1:-1 );
  }
  void save(int weekIndex) async{
    List<String> toSaveList = data[weekIndex]!.map((e) => e.toString()).toList();
    saveData.setStringList( keyStr(weekIndex) , toSaveList);
  }
  void add(int weekIndex, Cell cell) {
    data[weekIndex]!.add(cell);
    save(weekIndex);
  }
  void clear(int weekIndex) {
    saveData.remove('cellList_$weekIndex');
    load(weekIndex);
  }
  
  //#endregion

  //#region Timer Definition
  Timer? _timer; // 타이머
  bool timerIsPlaying = false; // 시작/정지 상태값
  int timerTest = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void start() {//타이머 시작
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        today = DateTime.now();
        weekActiveIndex = 0;//today.weekday-1;
        /*
        int cellStartNextIndex = data[weekActiveIndex]!.indexWhere((element){
          DateTime targetTime = DateTime(today.year, today.month, today.day, element.start[0], element.start[1], element.start[2]);
          Duration remainDuration = targetTime.difference(today);
          bool isNext = remainDuration.inMicroseconds > 0;
          print(isNext);
          return isNext;
        });
        */
        int cellEndNextIndex = data[weekActiveIndex]!.indexWhere((element)=>element.remainDuration(today)["endYet"]);
        cellActiveIndex = cellEndNextIndex;
        //cellProgress = cellStartNextIndex == cellEndNextIndex;
        //print("cellActiveIndex=$cellActiveIndex // weekActiveIndex=$weekActiveIndex // data[$weekActiveIndex].length=${data[weekActiveIndex]!.length}");
        timerTest++;
        //print("${timerTest} --> ${timerTest%(1*20)} ==> ${timerTest%(1*20) == 0}:${data[0]!.length <= 60}");
        
        if (timerTest%(1*20) == 0 & data[0]!.length <= 60){
          //data[0]!.add(Cell());
          //print("saved");
          //save(0);
          //data[0]!.add(Cell(label: "$timerTest교시",subject: "기술가정",start: [today.hour,today.minute,today.second+10],end: [today.hour,today.minute,today.second+20]));
          //save(0);
        }
      });
    });
  }
  //#endregion
  
  //#region Top widget
  Widget topActive(Cell cell, Function(Cell e) func, {bool isMainCell = false}){
    Map<String,dynamic>? remainTime;
    bool isStart = false;
    String start = "--:--:--";
    String end = "--:--:--";
    if(isMainCell) {
      remainTime = cell.remainDuration(today);
      isStart = remainTime["isStart"];
      start = remainTime["start"];
      end = remainTime["end"];
    }
    //bool isActive = cell.start

    Widget widget = Row(// 4 : 3 : 5
      children: [
        Expanded(
          flex: 4,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit:BoxFit.scaleDown,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    cell.label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15, 
                      color: Colors.black54, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                  Text(
                    cell.subject,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40, 
                      color: Colors.black54, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                  Text(
                    cell.teacher,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15, 
                      color: Colors.black54, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                ],
              )
            )
          )
        ),
        Spacer(flex: 3,),
        Expanded(
          flex: 5,
          child: FittedBox(
            alignment: Alignment.centerRight,
            fit:BoxFit.scaleDown,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text( //isMainCell?특정값:기본값
                    isMainCell?(cell.start.map((e) => "$e".padLeft(2,"0")).join(":")+"~"):"",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20, // 시작값
                      color: isStart ? Colors.blue : Colors.black54, //mainCell이 아니면 안보여질 텍스트 -> mainCell을 조건에 넣을 필요가 없음
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                  Text( //isMainCell?특정값:기본값//remainTime["isStart"]?끝나기까지남은시간:시작하기까지남은시간
                    isMainCell?( isStart ? start : end ):(cell.start.map((e) => "$e".padLeft(2,"0")).join(":")),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50, 
                      color: Colors.black54, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                  Text(
                    "~"+cell.end.map((e) => "$e".padLeft(2,"0")).join(":"),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20, // 끝값
                      color: isMainCell&!isStart ? Colors.blue : Colors.black54, //mainCell이 아니면 isStart=false -> mainCell이 아니면 무조건 거짓 -> mainCell을 조건에 넣어야함
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                ],
              )
            )
          )
        ),
      ],
    );
    return GestureDetector(
      onDoubleTap: (){
        func(cell);
        print("${cell.label} is Tapped");
      },
      child: widget,
    );
  }
  //#endregion

  //#region Widget Build
  @override
  Widget build(BuildContext context) {
    if(!timerIsPlaying) {
      timerIsPlaying = true;
      load(0);
      start();
    }
    //https://www.youtube.com/watch?v=T4Uehk3_wlY
    return Scaffold(
      backgroundColor: Colors.amber, // widget과 widget사이의 공간 매우기
      body: Column(
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            cellActiveIndex == -1?
            Container(
              //color: Colors.amber, //특정색(남은시간 배경색) ==> Scaffold색으로 사용
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.3,
              padding: EdgeInsets.fromLTRB(40, 70, 40, 40),
              child: FittedBox(
                child:Text(
                  "남은 수업이 없습니다!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54, 
                  ),
                )
              )
              //Cell(label: "1교시$timerTest",subject: "과학",teacher: "가나다",start: [08,30,00], end: [09,20,00]))
            ):
            Container(
              //color: Colors.amber, //특정색(타이머 배경색) ==> Scaffold색으로 사용
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.3,
              padding: EdgeInsets.fromLTRB(40, 70, 40, 40),
              child: topActive(
                data[weekActiveIndex]![cellActiveIndex], 
                (e){

                },
                isMainCell: true)//Cell(label: "1교시$timerTest",subject: "과학",teacher: "가나다",start: [08,30,00], end: [09,20,00]))
            ),
            Positioned(bottom: 0, child: Text(DateFormat.Hms().format(today))),
          ],
        ),
        Expanded( 
          child : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amber.withOpacity(0),
                  Colors.amber.shade700,
                ],
              ),
            ),
            //color: Colors.amberAccent, //리스트 배경색 ==> BoxDecoration사용으로 필요가 없어짐
            //padding: EdgeInsets.all(40),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:  data[0]!.length,
              itemBuilder: (context, index) => 
              Card(
                color: index==cellActiveIndex?Colors.amber:Colors.blue, //리스트카드 색
                child: Container(
                  padding: EdgeInsets.fromLTRB(50,20,50,20),
                  child: topActive(
                    data[0]![index],
                    (e){
                      print(e);
                      e.editDialog(context).then((value){
                        if(value){
                          print("[${DateFormat.Hms().format(today)}]Get!! value : $value");
                          save(0);
                        }else{
                          print("GET!! but.. False!");
                        }
                      });
                      //save(0);
                    }
                  ),//topActive(Cell(label: "$index교시")),
                )
              )/*
              Container(
                color: index==cellActiveIndex?Colors.green:Colors.blue,
                padding: EdgeInsets.fromLTRB(50,20,50,10),
                child: topActive(data[0]![index]),//topActive(Cell(label: "$index교시")),
              )*/
            ),
          )
        )
      ],
    ),
    floatingActionButton: Column(
      children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            //saveData.remove('cellList_0');
            add(0, Cell(
              label: "$timerTest교시",
              subject: "기술가정",
              start: [today.hour,today.minute,today.second+10],
              end: [today.hour,today.minute,today.second+20]
            ));
            print("addaddadd");
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () async{
            clear(0);


            /*
            
            Cell(
              label: "$timerTest교시",
              subject: "기술가정",
              start: [today.hour,today.minute,today.second+10],
              end: [today.hour,today.minute,today.second+20]
            ).editDialog(context).then((value){
              print("[${DateFormat.Hms().format(today)}]Get!! value : $value");
              save(0);
            });
            
            EditDialog(context, Cell(
              label: "$timerTest교시",
              subject: "기술가정",
              start: [today.hour,today.minute,today.second+10],
              end: [today.hour,today.minute,today.second+20]
            ));*/
          },
        ),
      ],
    )
    );
    
  }
  //#endregion
}

/*
  1. 색: 색상 관련 용어, 기본기, 색채 심리학
  2. 균형: 대칭과 비대칭
  3. 대비: 대비 효과를 이용한 정보 구조화, 계층구조 만들기, 포커스 만들기
  4. 타이포그래피: 폰트를 선택하고 웹에서 읽기 쉬운 텍스트 만들기
  5. 일관성: 가장 중요한 원칙. 직관적이고 유용한 디자인은 여기서 시작됩니다.


  SFW은 다음과 같이 정리할 수 있다.

    SFW은 화면의 구성이 상태 변화에 따라 재구성되어야 할 때 사용된다.
    SFW의 상태 변경은 setState 메서드를 이용해서 변경해야 한다.
    플랫폼은 setState 메서드가 호출될 때마다 build 메서드를 재호출하여 화면을 다시 그린다.

*/