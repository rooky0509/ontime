import 'package:flutter/material.dart';
import 'dart:math';

class TimeTable extends StatefulWidget{
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>{
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
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(9*4+1, (int index) {
                return Card(
                  color: Colors.blue[((index-9*2).abs()-9).abs() * 100],
                  child: Container(
                    height: 70,
                    child: Text("${((index-9*2).abs()-9).abs()}"),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(9*4+1, (int index) {
                return Card(
                  color: Colors.blue[((index-9*2).abs()-9).abs() * 100],
                  child: Container(
                    height: 70,
                    child: Text("${((index-9*2).abs()-9).abs()}"),
                  ),
                );
              }),
            ),
          ),
        ],
      )
    );
  }
}