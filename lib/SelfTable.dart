import 'package:flutter/material.dart';

class SelfTable extends StatefulWidget{
  @override
  _SelfTableState createState() => _SelfTableState();
}

class _SelfTableState extends State<SelfTable>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SelfTable'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                },
                child: Text('Self')
            ),
          ],
        ),
      ),
    );
  }
}