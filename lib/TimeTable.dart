import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'SaveData.dart';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}
//{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
class _TimeTableState extends State<TimeTable> {

  //#region value
  SaveData saveData = SaveData();
  Map<int,List<Cell>> data = {0:[],1:[],2:[],3:[],4:[],5:[],6:[],};
  /*
  {
    0:[Cell(),Cell()],
    1:[Cell(),Cell()],
  }
  */
  int weekActiveIndex = 0;
  load(int index) async{
    data[index] = (await saveData.getStringList("cellList_$index")).map((e) => Cell().fromString(e)).toList();
  }
  save(int index) async{
    saveData.setStringList("cellList_$index", data[index]!.map((e) => e.toString()).toList());
  }
  //#endregion

  //#region Timer Definition
  Timer? _timer; // 타이머
  bool timerIsPlaying = false; // 시작/정지 상태값
  int timerTest = 0;

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
  start() {//타이머 시작
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        timerTest++;
        if (timerTest%20 == 0){
          data[0]!.add(Cell());
          print("${(data[0]??[]).length} =>> saved");
          save(0);
        }
      });
    });
  }
  //#endregion
  
  //#region Top widget
  Widget topActive(Cell cell){
    return Row(
        children: [
          Expanded(
            flex: 5,
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
                        fontSize: 60, 
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
          Spacer(flex: 1,),
          Expanded(
            flex: 5,
            child: FittedBox(
              alignment: Alignment.centerRight,
              fit:BoxFit.scaleDown,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      cell.start.map((e) => "$e".padLeft(2,"0")).join(":")+"~",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      cell.start.map((e) => "$e".padLeft(2,"0")).join(":"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "~"+cell.end.map((e) => "$e".padLeft(2,"0")).join(":"),
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
        ],
      );
  }
  //#endregion

  //#region Widget Build
  @override
  Widget build(BuildContext context) {
    if(!timerIsPlaying) {
      load(0);
      timerIsPlaying = true;
      start();
    }
    //https://www.youtube.com/watch?v=T4Uehk3_wlY
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.amber,
          padding: EdgeInsets.all(40),
          child: topActive(Cell(label: "1교시$timerTest",subject: "과학",teacher: "가나다",start: [08,30,00], end: [09,20,00]))
        ),
        Expanded( 
          child : Container(
            color: Colors.blue,
            padding: EdgeInsets.all(40),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:  data[0]!.length,
              itemBuilder: (context, index) => topActive(Cell(label: "$index교시")),
            ),
          )
        )
      ],
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