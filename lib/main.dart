import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ontime/page/schedule.dart';
import 'package:ontime/page/selfcheck.dart';
import 'package:ontime/page/bus.dart';
import 'package:ontime/page/lunch.dart';
import 'package:ontime/page/setting.dart';

import 'package:ontime/providers/time.dart';

import 'package:ontime/widgets/time.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
	  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double tapWidth = width*0.9;

    void _scroll(double offset) {
      _controller.animateTo(
        offset,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    Widget Pos({required int index, required Color color, required Function onPressed}){
      
      return Positioned(
        top: 0,
        left: (tapWidth-50)*index,
        width: tapWidth,
        height: height,
        child: GestureDetector(
          onTap: (){
            onPressed();
            print("Tap:$index");
          },
          child:Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
            ),
            child: Text("index:$index"),
          ),
        )
      );
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      body : SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Stack(
          children:[
            Container(
              width: (tapWidth-50)*9,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.orange]
                )
              ),
            ),
            Pos(index: 8, color: Colors.blue.shade900 ,onPressed: (){_scroll(_controller.position.minScrollExtent);}),
            Pos(index: 7, color: Colors.blue.shade800 ,onPressed: (){}),
            Pos(index: 6, color: Colors.blue.shade700 ,onPressed: (){}),
            Pos(index: 5, color: Colors.blue.shade600 ,onPressed: (){}),
            Pos(index: 4, color: Colors.blue.shade500 ,onPressed: (){}),
            Pos(index: 3, color: Colors.blue.shade400 ,onPressed: (){}),
            Pos(index: 2, color: Colors.blue.shade300 ,onPressed: (){}),
            Pos(index: 1, color: Colors.blue.shade200 ,onPressed: (){}),
            Pos(index: 0, color: Colors.blue.shade100 ,onPressed: (){}),
            Builder(builder: (context) {
              return Pos(index: -1, color: Colors.blue.shade50 ,onPressed: (){Scaffold.of(context).openDrawer();});
            }),
            
          ]
        )
      ),
      drawer: Drawer(
        child: Center(
          child: Text('Drawer'),
        ),
      ),
    );
  }
}

/* 

Container(
  width: width*0.5,
  decoration: BoxDecoration(
    color: Colors.blue[100]
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  child: Text("index:${100*(9-index)}/${100*(index-9)}"),
)

            Positioned(
              left: 100,
              width: 1000,
              height: height,
              child: Container(color: Colors.red),
            )
Container(
              width: 5000,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.orange]
                )
              ),
            ),
ListView(
        scrollDirection: Axis.horizontal,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(19, (index) => 
          Container(
            width: width*0.5,
            decoration: BoxDecoration(
              color: index<9?Colors.lightBlue[100*(9-index)]:Colors.amber[100*(index-9)],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text("index:${100*(9-index)}/${100*(index-9)}"),
          )),
      )

<Widget>[
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          )
        ],


Column(
        children: <Widget>[
          ChangeNotifierProvider(
            create: (BuildContext context) => Providerr(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Counter(),
                  Counter(),
                  Buttons(),
                ],
              ),
            ),
          ),
        ],
      )

GridView.count(
  crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
  childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
  mainAxisSpacing: 10, //수평 Padding
  crossAxisSpacing: 10, //수직 Padding
  children: List.generate(4, (index) {  //item 의 반목문 항목 형성
    return MaterialButton(
      color: Colors.lightGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(' Item : $index'),
      onHighlightChanged: (val){
        print("[onHighlightChanged] val : $val");
      },
      onPressed: (){
        print("[onPressed]");
      },
    );
  }),
),





 */