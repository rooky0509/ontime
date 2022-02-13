import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'dart:math';import 'dart:async';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>{

  Widget CardView(int index, int pos){ //, {int indexTab = i++}
    //                          True   :     false

    int activeIndex = (pos+1) ~/ 2;
    bool active = activeIndex == index;
    bool isstart = pos.isEven;
    int getTimeIndex = index*2+(isstart?1:0);
    // pos자체 => 자신보다 큰것의 인덱스 값
    // pos결과 => 자신보다 작은것들중 제일 큰 값
    // pos = -2   : 모든것이 자신보다 작음 => 수업이 모두 끝남
    // pos = -1   : 모든것이 자신보다 큼 => 아직 모든 수업이 시작하지 않음
    // pos%2 = 1  : 수업이 수업의 사이시간임
    // pos%2 = 0  : 수업과 진행중임

    Color background = active ? Colors.white : Colors.white60;
    Color title_color = active ? Colors.blueAccent : Colors.grey;
    Color time_color = isstart ? Colors.grey : Colors.blueAccent;
    Color border_color = active ? Colors.blue : Colors.grey;
    double elevation = active ? 20.0 : 1.0;
    String timeTable = "$index교시";
    if(active){
      List<int> tisp = time[getTimeIndex].split(":").toList().map((e) => int.parse(e)).toList();
      int h = tisp[0]-int.parse(hour);
      int m = tisp[1]-int.parse(min);
      int s = tisp[2]-int.parse(sec);
      print(tisp);
      print("${hour}:${min}:${sec}");
      if(m<0){
        h -= 1;
        m += 60;
      }
      print("2:::${h}:${m}:${s}>>${getTimeIndex}:${pos}");
      if(s<0){
        m -= 1;
        s += 60;
      }
      print("3:::${h}:${m}:${s}>>${index*2+1}:${pos}");
      timeTable = "${h}:".padLeft(3,"0")+"${m}:".padLeft(3,"0")+"${s}".padLeft(2,"0");
    }

    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: border_color, width: 2.0),
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
                    "수학Ⅱ[$index]",
                    style: TextStyle(
                      fontSize: 30, 
                      color: title_color, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0),
                    textAlign: TextAlign.start,
                    ),
                  Text(timeTable,style: TextStyle(fontSize: 25, color: title_color),textAlign: TextAlign.end)
                ]),

                TableRow(children: [
                  Text("$active",style: TextStyle(fontSize: 10, color: border_color),textAlign: TextAlign.start),
                  Text("${time[index*2]}~${time[index*2+1]}",style: TextStyle(fontSize: 10, color: border_color),textAlign: TextAlign.end),
                ])
              ],
            ),
            active?Container(
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
                      side: new BorderSide(color: border_color, width: 2.0),
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
    );
  }
  
  Timer? _timer; // 타이머
  bool _isPlaying = false; // 시작/정지 상태값

  var _icon = Icons.play_arrow;
  var _color = Colors.amber;
  String hour="19",min="30",sec="30",time_string="193000", week="월";
  int pos = 0, activeIndex = 10;
  List<String> time_tag = [

  ];
  List<String> time = List.generate(58, (int index){
    return "00:"+"${index+1}:00".padLeft(5,"0");
  });
  /*[
    "00:01:00","00:02:00",
    "00:03:00","00:04:00",
    
    "00:05:00","00:08:00",
    "00:09:00","00:15:00",
    
    "00:17:00","00:20:00",
    "08:30:00","08:40:00",

    "08:40:00","08:50:00",
    "19:40:00","19:50:00",

    "20:00:00","20:50:00",
    "21:00:00","21:30:00",
    
    "21:33:00","21:40:00",
    "21:43:00","21:50:00",

    "21:57:00","21:58:00",
    "21:59:00","22:10:00",

    "22:36:00","22:40:00",
    "22:42:00","22:45:00",

    "22:46:00","22:50:00",
    "23:00:00","23:45:00",

    "23:47:00","23:50:00",
    "23:55:00","23:59:00",
    //  짝         홀
  ];
  */
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {//타이머 시작
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        hour = DateFormat("HH").format(DateTime.now());
        min = DateFormat("mm").format(DateTime.now());
        sec = DateFormat("ss").format(DateTime.now());
        time_string = hour+min+sec;
        week = ['월','화','수','목','금','토','일'][DateTime.now().weekday-1];//DateTime.now().weekday
        //                                  saved  >  now
        pos = time.indexWhere((element) => int.parse(element.replaceAll(":", "")) > int.parse(hour+min+sec))-1;//int("$hour$min")
        // pos자체 => 자신보다 큰것의 인덱스 값
        // pos = -2   : 모든것이 자신보다 작음 => 수업이 모두 끝남
        // pos = -1   : 모든것이 자신보다 큼 => 아직 모든 수업이 시작하지 않음
        // pos%2 = 1  : 수업이 수업의 사이시간임
        // pos%2 = 0  : 수업과 진행중임

        //print("$pos,$activeIndex,$sec,${time[pos]}");
        /*
            0845 -> 1 -> time[index+1]=time
        [0840,0850,1940,1950,2000,2050]
        */
      });
    });
  }
  
  void _pause() {// 타이머 중지
    _timer?.cancel();
  }
  
  @override
  Widget build(BuildContext context) {

    if(!_isPlaying) {
      _isPlaying = true;
      _icon = Icons.pause;
      _color = Colors.grey;
      _start();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _isPlaying = false;
          _icon = Icons.play_arrow;
          _color = Colors.amber;
          _pause();
        }),
        child: Icon(_icon),
        backgroundColor: _color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: Text("$time_string:${DateTime.now().weekday}"),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 75, //margin값 + size값
            //height: 70, -> 리스트뷰 전체의 길이 조절
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(10, (int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  width: 70,
                  height: 70,
                  child: Card(
                    color: Colors.blue,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("${index+20}\n${week}",style: TextStyle(fontSize: 20, color: Colors.black)
                    ))
                  ),
                );
              }),
            ),
          ), //Text("${index+20}\n월",style: TextStyle(fontSize: 20, color: Colors.black)),
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(time.length~/2, (int index) {
                return CardView(index, pos);
              }),//                      pos-1의 절반
            ),
          ),
        ],
      )
    );
  }
}