import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: AspectRatio(
          aspectRatio: 16/9,
          child:  Card(
            color: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    "1교시 수학",
                    style: TextStyle(
                      fontSize: 30
                    ),
                  ),
                  Expanded(
                    child: Container(color: Colors.red.withOpacity(0.1),),
                  ),
                  Text(
                    "1교시 수학",
                    style: TextStyle(
                      fontSize: 30
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}
//Navigator.pop(context);