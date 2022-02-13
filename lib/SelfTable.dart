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
                child: SizedBox(
                height: double.infinity,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    'https://placeimg.com/640/480/any', 
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}