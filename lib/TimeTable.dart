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
  int timerTest = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _start() {//타이머 시작
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        timerTest++;
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

    return Scaffold(
      appBar: AppBar(
        title: Text('TimeTable'),
      ),
      body: Container()
    );
  }
  //#endregion
}