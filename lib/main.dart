import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ontime/widgets/mainCell.dart';

import 'package:provider/provider.dart';
import 'package:ontime/data/saveData.dart'; 

import 'package:ontime/pages/schedule.dart';
import 'package:ontime/pages/selfcheck.dart';
import 'package:ontime/pages/bus.dart';
import 'package:ontime/pages/lunch.dart';
import 'package:ontime/pages/setting.dart';

Color backgroundColor = Colors.grey.shade300;

void main() {
  runApp(   //<- runApp에 추가하여 MaterialApp 전체에 적용되게 수정한다.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),//pages[0]["provider"] as ChangeNotifier
        ChangeNotifierProvider(create: (_) => SelfcheckProvider()),
        ChangeNotifierProvider(create: (_) => BusProvider()),
        ChangeNotifierProvider(create: (_) => LunchProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
      ],
      child: MyApp()
    )
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor, // navigation bar color
      statusBarColor: backgroundColor, // status bar color
      statusBarIconBrightness: Brightness.dark
    ));
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(
    initialPage: 0, //먼저 보여주는 페이지
    viewportFraction: 1 //뷰가 채우는 값 [ ex) 1:1화면에 1개 , 1/2:1화면에 2개 ]
  );
  final List _classes = [
    Schedule(),
    Selfcheck(),
    Bus(),
    Lunch(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: _classes.length,
                itemBuilder: (context, index) => mainCell(
                  pageController : _pageController,
                  index : index,
                  page : _classes[index],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
}
/* 
PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: _classes.length,
                itemBuilder: (context, index) => mainCell(
                  pageController : _pageController,
                  index : index,
                  page : _classes[index],
                ),
              ),
PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                children: _classes.map((_class) => mainCell(
                  pageController : _pageController,
                  index : 0,
                  page : _class,
                )).toList(),
              )
PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: 1,
                itemBuilder: (context, index) => mainCell(
                  pageController : _pageController,
                  index : index,
                  page : Schedule(),
                ),
              ),
.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: 50,
                itemBuilder: (context, index) => pageInner(index),
              ),
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double tapWidth = width*0.85;
    double tapRadius = 33;

    void _scroll(double offset) {
      _controller.animateTo(
        offset,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    Widget stackContainer({required int index, required Function onPressed, required Color color, required Widget child}){
      String tag = index==0?"Schedule_heroTag":"$index}qwe";
      return Positioned(
        top: 0, left: (tapWidth-tapRadius)*index,
        width: tapWidth, height: height,
        child: GestureDetector(
          onTap: (){onPressed();print("Tap:${tapRadius/2}");},
          child:Container(
            padding: EdgeInsets.fromLTRB(tapRadius+10, tapRadius/3+statusBarHeight, tapRadius/3+10, tapRadius/3+10),
            decoration: BoxDecoration(color: color,borderRadius: BorderRadius.horizontal(right: Radius.circular(tapRadius)),),
            child: child,
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
              width: (tapWidth-tapRadius)*9,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.orange]
                )
              ),
            ),
            stackContainer(
              index: 8, onPressed: (){_scroll(_controller.position.minScrollExtent);},color: Colors.blue.shade900,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 7, onPressed: (){},color: Colors.blue.shade800,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 6, onPressed: (){},color: Colors.blue.shade700,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 5, onPressed: (){},color: Colors.blue.shade600,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 4, onPressed: (){},color: Colors.blue.shade500,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 3, onPressed: (){},color: Colors.blue.shade400,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 2, onPressed: (){},color: Colors.blue.shade300,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 1, onPressed: (){},color: Colors.blue.shade200,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: 0, onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Schedule()));},color: Colors.blue.shade100,
              child:Container(
                color: Colors.red.withOpacity(0.05),
                child:Text("132"),
              )
            ),
            stackContainer(
              index: -1, onPressed: (){_scroll(_controller.position.maxScrollExtent);},color: Colors.blue.shade900,
              child:Container(
                color: Colors.red.withOpacity(0.5),
                child:Text("132"),
              )
            ),
            
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