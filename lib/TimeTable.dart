import 'package:flutter/material.dart';
import 'dart:math';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>{

  Widget CardView(int index, bool active){ //, {int indexTab = i++}
    //                                      True   :     false
    Color background = active ? Colors.grey : Colors.grey;
    Color title_color = active ? Colors.grey : Colors.blue;
    Color time_color = active ? Colors.grey : Colors.blue;
    Color border_color = active ? Colors.grey : Colors.blue;

    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Table(
              border: TableBorder.all(style: BorderStyle.none),
              children: [
                TableRow(children: [
                  Text("수학Ⅱ[$index]",style: TextStyle(fontSize: 25, color: title_color),textAlign: TextAlign.start),
                  Text("13:30",style: TextStyle(fontSize: 25, color: title_color),textAlign: TextAlign.end),
                ]),
                TableRow(children: [
                  Text("김철수",style: TextStyle(fontSize: 25, color: border_color),textAlign: TextAlign.start),
                  Text("08:20~09:30",style: TextStyle(fontSize: 25, color: border_color),textAlign: TextAlign.end),
                ])
              ],
            ),
            active?ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 80.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(100, (int index) {
                      return Card(
                        color: Colors.blue[index * 100],
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          child: Text("$index"),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ):Text("")
          ],
        )
      ),
    );
/*
ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height: 80.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(100, (int index) {
                        return Card(
                          color: Colors.blue[index * 100],
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            child: Text("$index"),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              )


*/
      //color: Colors.blue[((index-9*2).abs()-9).abs() * 100],
      /*
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: <Widget>[
          Row(
            children: [
              Expanded(child: Text("미적분",style: TextStyle(fontSize: 25, color: title_color))),
              Expanded(child: Text("9:10",style: TextStyle(fontSize: 25, color: Colors.blue))) //Colors.blue <-> Colors.grey
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("김민수",style: TextStyle(fontSize: 10, color: Colors.grey))),
              Expanded(child: Text("08:40~09:25",style: TextStyle(fontSize: 10, color: Colors.grey))),
            ],
          ),


          /*
          Container(
            margin : EdgeInsets.fromLTRB(15, 10, 0, 0),
            child : Text(
            '물리I',
            style: TextStyle(fontSize: 30, color: Colors.black),
          )),
          Container(
            margin : EdgeInsets.fromLTRB(20, 2, 0, 0),
            child : Text(
            'ㅇㅇㅇ',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          )),
          */

          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: 80.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(100, (int index) {
                    return Card(
                      color: Colors.blue[index * 100],
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        child: Text("$index"),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

        ],
      )
    */

  }


  @override
  Widget build(BuildContext context) {
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
              children: List.generate(30, (int index) {
                return CardView(index, index%20==1);
              }),
            ),
          ),
        ],
      )
    );
  }
}