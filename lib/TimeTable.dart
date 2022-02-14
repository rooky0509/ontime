import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>{



  List saved = [
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
      {"tag":"3교시","start":[20,00,00],"end":[21,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
      {"tag":"4교시","start":[21,40,00],"end":[22,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
  ];

  DateTime today = DateTime.now();
  int startClassIndex = -1;
  int endClassIndex = -1;
  int activeDayindex = 0;     //active => 사용자의 선택과 상관없이 날짜에 따라 지정된 값
  int activeWeekindex = 0;    // activeDayIndex != today.days()
  int selectDayIndex = 0;     //select => 사용자가 임의로 선택한 값
  int selectWeekIndex = 0;
  //값 지정
  //값 지정

  //타이머 생성
    Timer? _timer; // 타이머
    bool _isPlaying = false; // 시작/정지 상태값
    int timetest = 0;
    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }
    void _start() {//타이머 시작
      _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        setState(() {
          today = DateTime.now();
          //weekindex = today.weekday-1;
          activeWeekindex = today.weekday-1;
          selectWeekIndex = today.add(Duration(days: selectDayIndex)).weekday-1;
          startClassIndex = saved[selectWeekIndex].indexWhere( (e)=>Myfunc().diffDuration(today,e["start"])["isNext"]==true );
          endClassIndex = saved[selectWeekIndex].indexWhere(  (e)=>Myfunc().diffDuration(today,e["end"])["isNext"]==true );
          print("$startClassIndex : $endClassIndex :: ${saved[selectWeekIndex].indexWhere( (e)=> Myfunc().diffDuration(today,e["start"])["isNext"]==true )}");
          timetest++;
        });
      });
    }
  

  //값 지정
  //값 지정

  @override
  Widget build(BuildContext context) {
    
    if(!_isPlaying) {
      _isPlaying = true;
      _start();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('TimeTable'),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 70,
            //height: 70, -> 리스트뷰 전체의 길이 조절
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(10, (int index) {
                return Card(
                  color: Colors.blue[((index-9*2).abs()-9).abs() * 100],
                  child: Container(
                    //width: 100.0, -> 상관없음
                    height: 70.0,
                    child : Center(
                      child: Text("${index+20}\n월",style: TextStyle(fontSize: 20, color: Colors.black)),
                    )
                  )
                );
              }),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(saved[selectWeekIndex].length, (int index) {
                Map selectMap = saved[selectWeekIndex][index];
                return ClassCard(
                  name : selectMap["name"]+"$timetest",
                  teacher : selectMap["teacher"],
                  tag : selectMap["tag"],
                  start : selectMap["start"],
                  end: selectMap["end"],
                  today : today,
                  startClassIndex : startClassIndex,
                  endClassIndex : endClassIndex,
                  isActive : index == endClassIndex,
                  onTap : (){},
                );
              }),
            ),
          ),
        ],
      )
    );
  }
}

class Myfunc{
  Map diffDuration(DateTime now, List<int> target) {
    //DateTime now = DateTime.now();
    int hour = target[0];
    int min = target[1];
    int sec = target[2];
    DateTime targetTime = DateTime(now.year, now.month, now.day, hour, min, sec);
    Duration remainDuration = targetTime.difference(now);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(remainDuration.inHours.abs());
    String twoDigitMinutes = twoDigits(remainDuration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(remainDuration.inSeconds.remainder(60).abs());
    // +  : 앞으로 있을 내용
    // -0 : 지나간 내용
    bool isNext = remainDuration.inMicroseconds > 0;
    return {
      "text" : "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds",
      "isNext" : isNext
    };
  }
}

class ClassCard extends StatelessWidget {
  const ClassCard({
    Key? key,
    this.name,
    this.teacher,
    this.tag,
    this.start,
    this.end,
    this.today,
    this.startClassIndex,
    this.endClassIndex,
    this.isActive,
    this.onTap,
  }) : super(key: key);
  
  final String? name;
  final String? teacher;
  final String? tag;
  final List<int>? start;
  final List<int>? end;
  final DateTime? today;
  
  final int? startClassIndex;
  final int? endClassIndex;
  final bool? isActive;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {

    bool isStart = startClassIndex==endClassIndex;

    double elevation = isActive!?2:0;
    String timeText = isActive!?Myfunc().diffDuration(today!,isStart?start!:end!)["text"]:tag;
    Color background = isActive!?Colors.grey[200]!:Colors.grey[300]!;
    Color borderColor = isActive!?Colors.blue:Colors.grey;
    Color nameColor = isActive!?Colors.blue:Colors.grey;
    Color timeColor = isActive!?(isStart?Colors.amber:Colors.blue):Colors.grey;

    print(today);
    return GestureDetector(
      onTap: (){
        onTap;
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
        ),
        elevation: elevation,
        color: background,
        margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: <Widget>[
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(style: BorderStyle.none),
                children: [
                  TableRow(children: [
                    Text(
                      name!,
                      style: TextStyle(
                        fontSize: 30, 
                        color: nameColor, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 2.0),
                      textAlign: TextAlign.start,
                      ),
                    Text(timeText,style: TextStyle(fontSize: 25, color: timeColor),textAlign: TextAlign.end)
                  ]),

                  TableRow(children: [
                    Text("${teacher}",style: TextStyle(fontSize: 10, color: borderColor),textAlign: TextAlign.start),
                    Text("${tag} : ${start!.join(":")}~${end!.join(":")}",style: TextStyle(fontSize: 10, color: borderColor),textAlign: TextAlign.end),
                  ])
                ],
              ),
              isActive!?Container(
              height: 60, //margin값 + size값
              //height: 70, -> 리스트뷰 전체의 길이 조절
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(10, (int index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: 50,
                    height: 50,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(color: borderColor, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      color: Colors.greenAccent,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("월\n${index}",style: TextStyle(fontSize: 15, color: Colors.black),textAlign: TextAlign.center,
                      ))
                    ),
                  );
                }),
              ),
            ):Text("")
            ],
          )
        ),
      ),
    );
  }
}