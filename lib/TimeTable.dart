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
      {"tag":"5교시","start":[22,40,00],"end":[23,30,00],"name":"과학","teacher":"ㅇㅇㅇ"},
      {"tag":"4교시","start":[23,40,00],"end":[23,50,00],"name":"수학","teacher":"ㅇㅇㅇ"},
    ],
    [
      {"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
      {"tag":"2교시","start":[09,40,00],"end":[10,30,00],"name":"과학","teacher":"ㅇㅇㅇ"},
      {"tag":"3교시","start":[13,40,00],"end":[15,30,00],"name":"수학","teacher":"ㅇㅇㅇ"},
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
  List<String> weeks = ["월","화","수","목","금","토","일",];
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
          //print("$startClassIndex : $endClassIndex :: ${saved[selectWeekIndex].indexWhere( (e)=> Myfunc().diffDuration(today,e["start"])["isNext"]==true )}");
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
          /*
          Container(
            width: 75, //margin값 + size값
            //height: 70, -> 리스트뷰 전체의 길이 조절
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(14, (int index) {
                var time = new DateTime.now().subtract(Duration(days: 2));
                return Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  width: 70,
                  height: 70,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selectDayIndex = index;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(color: index == 2 ? Colors.blue : (selectDayIndex == index ? Colors.amber : Colors.grey), width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      color: index == 2 ? Colors.blue[300]: (selectDayIndex == index ? Colors.amber[300] : Colors.grey[300]),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("${time.add(Duration(days:index)).day}\n${weeks[time.add(Duration(days:index)).weekday-1]}",style: TextStyle(fontSize: 20, color: Colors.black)
                        )
                      )
                    ),
                  )
                );
              })
            ),
          ),*/
          Container(
            width: 75,
            //height: 70, -> 리스트뷰 전체의 길이 조절
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(14, (int generateIndex) {
                int index = generateIndex-2;
                int day = today.add(Duration(days: index)).day;
                int weekIndex = today.add(Duration(days: index)).weekday-1;
                return Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  width: 70,
                  height: 70,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selectDayIndex=index;
                      });;
                    },
                    onLongPress: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Container(
                              height: 500,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  "${weeks[weekIndex]}요일\n",
                                  style: TextStyle(
                                    fontSize: 30, 
                                    color: Colors.black87, 
                                    fontWeight: FontWeight.bold, 
                                    letterSpacing: 2.0
                                  )),
                                  Text("Tag:"),
                                  TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'What do you want to remember?'),
                                  ),
                                ],
                              )
                            )
                          );
                        });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(color: activeDayindex==index?Colors.blue:(selectDayIndex==index?Colors.amber:Colors.grey), width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      color: activeDayindex==index?Colors.blue[300]:(selectDayIndex==index?Colors.amber[300]:Colors.grey[300]),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("${day}\n${weeks[weekIndex]}",style: TextStyle(fontSize: 20, color: Colors.black)
                        )
                      )
                    ),
                  )
                );
              }),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(saved[selectWeekIndex].length, (int generateClassIndex) {
                Map selectMap = saved[selectWeekIndex][generateClassIndex];
                ClassCard classCard = ClassCard(
                    name : selectMap["name"],//+"$timetest",
                    teacher : selectMap["teacher"],
                    tag : selectMap["tag"],
                    start : selectMap["start"],
                    end: selectMap["end"],
                    today : today,
                    otherClass : saved.asMap().entries.map((entry){
                      final result = entry.value.where((e)=>e["name"]==selectMap["name"]).map((e)=>{"week":"${weeks[entry.key]}","tag":e["tag"]}).toList();
                      return result;
                    }).toList().expand((element) => element).toList(),
                    startClassIndex : startClassIndex,
                    endClassIndex : endClassIndex,
                    isActive : (generateClassIndex == endClassIndex)&(activeWeekindex == selectWeekIndex),
                    onTap : (){
                      
                    },
                  );
                bool accepted = false;
                return LongPressDraggable(
                  childWhenDragging: Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        
                        Expanded(
                          child: DragTarget(
                            builder: (BuildContext context, List<dynamic> candidateData, rejectedData) {
                              return Container(
                                  margin: EdgeInsets.fromLTRB(17,0,0,0),
                                  color: Colors.red,
                                  child: Text("del", style: TextStyle(color: Colors.white, fontSize: 22.0),
                                )
                              );
                            },
                            onAccept: (data) {
                              print("del");
                            },
                          ),
                        ),
                        Expanded(
                          child: DragTarget(
                            builder: (BuildContext context, List<dynamic> candidateData, rejectedData) {
                              return Container(
                                  margin: EdgeInsets.fromLTRB(0,0,17,0),
                                  color: Colors.green,
                                  child: Text("edit", style: TextStyle(color: Colors.white, fontSize: 22.0),
                                )
                              );
                            },
                            onAccept: (data) {
                              print("edit");
                            },
                          ),
                        ),


                     /*   
                DragTarget(
                    onAccept: (LottieBuilder animation) {
                      setState(() {
                        caughtAnimations[2] = animation;
                      });
                    },
                    builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
                      return Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400.withOpacity(0.5), borderRadius: BorderRadius.circular(20.0)),
                          child: caughtAnimations[2],
                        ),
                      );
                    },
                  ),
*/

                      ],
                    ),
                  ),
                  child : classCard,
                  feedback: classCard,
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
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String timeToStr(List<int> timeList){
    return "${twoDigits(timeList[0])}:${twoDigits(timeList[1])}:${twoDigits(timeList[2])}";
  }
  Map diffDuration(DateTime now, List<int> target) {
    //DateTime now = DateTime.now();
    int hour = target[0];
    int min = target[1];
    int sec = target[2];
    DateTime targetTime = DateTime(now.year, now.month, now.day, hour, min, sec);
    Duration remainDuration = targetTime.difference(now);
    String text = timeToStr([remainDuration.inHours.abs(),remainDuration.inMinutes.remainder(60).abs(),remainDuration.inSeconds.remainder(60).abs()]);
    //String twoDigitHours = twoDigits();
    //String twoDigitMinutes = twoDigits();
    //String twoDigitSeconds = twoDigits();
    // +  : 앞으로 있을 내용
    // -0 : 지나간 내용
    bool isNext = remainDuration.inMicroseconds > 0;
    //print(text);
    return {
      "text" : text,
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
    this.otherClass,
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
  final List? otherClass;
  
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
    Color timeColor = isActive!?(isStart?Colors.blueGrey:Colors.blue):Colors.grey;

    //print("${otherClass![0].runtimeType} : ${otherClass!}");
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
          width: 200,
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
                        letterSpacing: 2.0
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(timeText,style: TextStyle(fontSize: 25, color: timeColor),textAlign: TextAlign.end)
                  ]),

                  TableRow(children: [
                    Text("${teacher}",style: TextStyle(fontSize: 10, color: borderColor),textAlign: TextAlign.start),
                    Text("${tag} : ${Myfunc().timeToStr(start!)}~${Myfunc().timeToStr(end!)}",style: TextStyle(fontSize: 10, color: borderColor),textAlign: TextAlign.end),
                  ])
                ],
              ),
              isActive!?Container(
              height: 65, //margin값 + size값
              //height: 70, -> 리스트뷰 전체의 길이 조절
              child: ListView(
                scrollDirection: Axis.horizontal,


                children: otherClass!.map((e) => 
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: 55,
                    height: 55,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(color: borderColor, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)
                      ),
                      color: Colors.greenAccent,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("${e["week"]}\n${e["tag"]}",style: TextStyle(fontSize: 15, color: Colors.black),textAlign: TextAlign.center,
                      ))
                    ),
                  ),
                ).toList(),


              ),
            ):Text("")
            ],
          )
        ),
      ),
    );
  }
}