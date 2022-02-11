import 'package:flutter/material.dart';

class MealTable extends StatefulWidget{
  @override
  _MealTableState createState() => _MealTableState();
}

class _MealTableState extends State<MealTable>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MealTable'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                },
                child: Text('Meal')
            ),
          ],
        ),
      ),
    );
  }
}