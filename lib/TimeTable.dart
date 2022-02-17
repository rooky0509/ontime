import 'package:flutter/material.dart';
import 'dart:async';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}
//{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
class _TimeTableState extends State<TimeTable> {

  //#region Timer Definition
  Timer? _timer; // 타이머
  bool timerIsPlaying = false; // 시작/정지 상태값
  int timerTest = 100000000000;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _start() {//타이머 시작
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        timerTest++;                             //999999999999
        if (timerTest >= 999999999999) timerTest = 100000000000;
      });
    });
  }
  //#endregion
  
  //#region Widget Build
  @override
  Widget build(BuildContext context) {
    if(!timerIsPlaying) {
      timerIsPlaying = true;
      _start();
    }
    //https://www.youtube.com/watch?v=T4Uehk3_wlY
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: FittedBox(
            fit:BoxFit.scaleDown,
            child:
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "1교시",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "국어${timerTest%1000000000}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "김철수",
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
            flex: 3,
            child: FittedBox(
            fit:BoxFit.scaleDown,
            child:
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "1교시",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "국어${timerTest}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50, 
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0
                      ),
                    ),
                    Text(
                      "김철수",
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