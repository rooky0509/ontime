import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'DataHub.dart';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}
//{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","detail":"ㅐㅐㅐ"},
class _TimeTableState extends State<TimeTable> {

  //#region value
  SaveData saveData = SaveData();
  GetData  getData  = GetData();
  Map<int,List<Cell>> data = {0:[],1:[],2:[],3:[],4:[],5:[],6:[],};  //{0:[Cell(),Cell()],1:[Cell(),Cell()],}
  
  DateTime today = DateTime.now();
  int weekActiveIndex = 0;
  int weekSelectIndex = -10;
  int cellActiveIndex = -1;

  List<String> weektoText = ["월","화","수","목","금","토","일","ㅗ"];

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
  void save(int weekIndex) {
    List<String> toSaveList = data[weekIndex]!.map((e) => e.toString()).toList();
    saveData.setStringList( keyStr(weekIndex) , toSaveList);
  }
  void clear(int weekIndex) {
    saveData.remove( keyStr(weekIndex) );
    load(weekIndex);
  }
  void add(int weekIndex, Cell cell) {
    data[weekIndex]!.add(cell);
    //save(weekIndex);
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
        weekActiveIndex = today.weekday-1;
        if(data[weekSelectIndex]==null) weekSelectIndex++;// = weekActiveIndex;
        int cellEndNextIndex = data[weekActiveIndex]!.indexWhere((element)=>element.remainDuration(today)["endYet"]);
        print("""
data[weekActiveIndex] : ${data[weekActiveIndex]}
data[weekActiveIndex]!.indexWhere((element)=>element.remainDuration(today)["endYet"] : ${data[weekActiveIndex]!.indexWhere((element)=>element.remainDuration(today)["endYet"])}
""");
        cellActiveIndex = cellEndNextIndex;
        timerTest++;
      });
    });
  }
  //#endregion
  
  //#region Top widget
  Widget topActive(Cell cell, {required Function(Cell e) func, bool isMainCell = false}){
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
    Widget text(String inputText, {Color color = Colors.black54,double fontSize = 15.0, Alignment alignment = Alignment.center}){
      return Container(
        alignment: alignment,
        //color:Colors.red.withOpacity(0.1),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            inputText,//cell.label,
            //textAlign: textAlign,//TextAlign.left,
            style: TextStyle(
              fontSize: fontSize,//15, 
              color: color, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2.0
            ),
          ),
        ),
      );
    }
    Widget widget = Row(// 4 : 3 : 5
      children: [
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              text(cell.label , alignment : Alignment.centerLeft),
              text(cell.subject , fontSize: 40),
              text(cell.label , alignment : Alignment.centerRight),
            ],
          )
        ),
        Expanded(flex: 2,child: Container(),),
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              text(
                isMainCell?(cell.start.map((e) => "$e".padLeft(2,"0")).join(":")+"~"):" ",//"~"+cell.end.map((e) => "$e".padLeft(2,"0")).join(":"),
                color: isStart ? Colors.blue : Colors.black54,
                 alignment : Alignment.centerRight
              ),
              text(
                isMainCell?( isStart ? start : end ):(cell.start.map((e) => "$e".padLeft(2,"0")).join(":")),
                fontSize: 50,
                 alignment : Alignment.centerRight
              ),
              text(
                "~"+cell.end.map((e) => "$e".padLeft(2,"0")).join(":"),
                color: isMainCell&!isStart ? Colors.blue : Colors.black54,
                 alignment : Alignment.centerRight
              ),
            ],
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
      data.forEach((k,v) => load(k));
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
            cellActiveIndex < 0?
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
              //Cell(label: "1교시$timerTest",subject: "과학",detail: "가나다",start: [08,30,00], end: [09,20,00]))
            ):
            Container(
              //color: Colors.amber, //특정색(타이머 배경색) ==> Scaffold색으로 사용
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.3,
              padding: EdgeInsets.fromLTRB(40, 70, 40, 40),
              child: topActive(
                data[weekActiveIndex]![cellActiveIndex],
                func: (e){},
                isMainCell: true)//Cell(label: "1교시$timerTest",subject: "과학",detail: "가나다",start: [08,30,00], end: [09,20,00]))
            ),
            Positioned(bottom: 0, child: Text("Time : ${DateFormat.Hms().format(today)} | Week : $weekActiveIndex | WeekS : $weekSelectIndex | Active : $cellActiveIndex ")),
          ],
        ),
        Expanded( 
          child : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amber.withOpacity(0.0),
                  Colors.amber.shade700,
                ],
              ),
            ),
            //color: Colors.amberAccent, //리스트 배경색 ==> BoxDecoration사용으로 필요가 없어짐
            child: 
            data[weekSelectIndex]==null?
            Center(
              child: CircularProgressIndicator(),
            )
            :ListView.builder(
              shrinkWrap: true,
              itemCount:  data[weekSelectIndex]!.length,
              itemBuilder: (context, index) => 
              Card(
                color: (index==cellActiveIndex)&(weekActiveIndex==weekSelectIndex)?Colors.amber:Colors.blue, //리스트카드 색
                child: Container(
                  padding: EdgeInsets.fromLTRB(50,20,50,20),
                  child: topActive(
                    data[weekSelectIndex]![index],
                    func: (e){
                      print(e);
                      /*
                      e.editDialog(context).then((value){
                        if(value){
                          print("[${DateFormat.Hms().format(today)}]Get!! value : $value");
                          save(weekSelectIndex);
                        }else{
                          print("GET!! but.. False!");
                        }
                      });
                      */
                      //save(weekSelectIndex);
                    }
                  ),
                )
              )
            ),
          )
        )
      ],
    ),
      drawer: SingleChildScrollView(
        child : Container(
          //alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(0, 75*4, 0, 75*4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(data.length, (index) => 
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    height: 65,
                    child: MaterialButton(
                      shape: weekActiveIndex==index ? CircleBorder(side: BorderSide(width: 3, color: Colors.amber, style: BorderStyle.solid)) : CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white),
                          Text(weektoText[index]),
                        ],
                      ),
                      color: index==5?Colors.blue:index==6?Colors.red:Colors.grey,
                      textColor: Colors.white,
                      onPressed: (){
                        setState((){weekSelectIndex = index;});
                        print('I:${index}_clicked');
                      },
                    ),
                  )
            )..addAll(
              [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    height: 70,
                    child: MaterialButton(
                      shape: CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          Text("Add"),
                        ],
                      ),
                      color: Colors.amber.shade600,
                      textColor: Colors.white,
                      onPressed: (){
                        Cell newCell = Cell();
                        add(weekSelectIndex, newCell);
                        save(weekSelectIndex);
                        /*
                        newCell.editDialog(context).then((value){
                          if(value){
                            print("[$newCell]Get!! value : $value");
                            add(weekSelectIndex, newCell);
                            save(weekSelectIndex);
                          }else{
                            print("GET!! but.. False! => add close");
                          }
                        });
                        */
                        print('Add_clicked');
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    height: 70,
                    child: MaterialButton(
                      shape: CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          Text("Clear"),
                        ],
                      ),
                      color: Colors.amber.shade900,
                      textColor: Colors.white,
                      onPressed: (){
                        clear(weekSelectIndex);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    height: 70,
                    child: MaterialButton(
                      shape: CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: Colors.white),
                          Text("Setting"),
                        ],
                      ),
                      color: Colors.grey.shade600,
                      textColor: Colors.white,
                      onPressed: (){
                        //getData.setTimeDialog(context);
                        print('Setting_clicked');
                      },
                    ),
                  ),
              ]
            )
          ),
        )
      ),
    
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