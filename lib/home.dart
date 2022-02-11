import 'package:flutter/material.dart';
import 'package:ontime/TimeTable.dart';
import 'package:ontime/MealTable.dart';
import 'package:ontime/SelfTable.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  final PageStorageBucket bucket = PageStorageBucket();
  final List<List> screens = [
    [TimeTable(),"시간표",Icons.access_alarm],        //0
    [TimeTable(),"시간표",Icons.access_alarm],        //1
    [TimeTable(),"시간표",Icons.access_alarm],        //2
    [MealTable(),"급식표",Icons.accessible_forward],  //3
    [SelfTable(),"자가진단",Icons.hail],              //4       //12
    //StudyTable(), //3
    //SettingsTable(), //4
  ];
  int currentTab = 0;
  Widget currentScreen = TimeTable();

  void setTab(int int){ //function
    setState(() {
      currentScreen = screens[int][0];
      currentTab = int;
    });
  }

  Widget CusTab(int indexTab){ //, {int indexTab = i++}
    String tab = screens[indexTab][1];
    IconData icon = screens[indexTab][2];

    MaterialColor Activate = Colors.blue;
    MaterialColor Disable = Colors.grey;
    MaterialColor color = currentTab == indexTab ? Activate : Disable;

    return Expanded(
      flex: 1,
      child: MaterialButton(
        //minWidth: 60,
        height: 60,
        onPressed: ()=>setTab(indexTab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color),
            Text("$indexTab", style: TextStyle(color: color))
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    /* 꺼질시 확인
    Future<bool> _onBackPressed(){
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Do you want to exit the app?"),
            actions: <Widget>[
              FlatButton(
                child: Text("NO"),
                onPressed: ()=>Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("yes"),
                onPressed: ()=>Navigator.pop(context, true),
              )
            ],
          )
      );
    }
    */
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          //height: 60,
          child: SingleChildScrollView(
            child: Row(children: List<Widget>.generate(screens.length, (i) => CusTab(i))),
          ),
        ),
      ),
    );
  }
}

/*

tab : https://here4you.tistory.com/125
  ㄴ가장 기본
Scroll : https://empering.tistory.com/entry/%EB%A7%A4%EC%9A%B0-%EA%B0%84%EB%8B%A8%ED%95%9C-%EB%AC%B4%ED%95%9C-%EC%8A%A4%ED%81%AC%EB%A1%A4-%EB%A7%8C%EB%93%A4%EA%B8%B0
  ㄴ스크롤 / List<Widget>.generate
Function parameters : https://flutterrdart.com/dart-optional-default-parameters-function/
  ㄴ 함수 파라미터 기본값
Nullish Coalescing : https://muhly.tistory.com/56
  ㄴ 삼항연산자 + null일때의 값
for/while : https://couldi.tistory.com/20
  ㄴ 반복문[ while, for, forEach, for (... in...) ]
Scrollable : https://stackoverflow.com/questions/46222788/how-to-create-a-row-of-scrollable-text-boxes-or-widgets-in-flutter-inside-a-list
  ㄴ Row()를 스크롤 가능한 ListView()로 대체
    -> 쓰는 방법을 모르겠음
    -> timetable에서 사용



/*
-----------------------------------------------------------------------------------------
[ 
  <name> : origin 
  <url> : https://github.com/rooky0509/ontime.git
  Present_branch : main
]
-----------------------------------------------------------------------------------------
1. git remote add <name> <url>                [ remote 추가 ]
  > error: remote <name> already exists.        ㄴ[ 이미 존재한다면 ]
    1. git remote set-url --add <name> <url>        ㄴ[ url추가 ]
    2. git remote get-url --all <name>              ㄴ[ 저장된 모든 url조회 ]
    3. git remote set-url --delete <name> <url>     ㄴ[ url삭제 ]
2. " + " 클릭                                       [ Changes -> Staged Changes ]
3. " ✓ " 클릭                                       [ Staged Changes => commit ]
4. git push -u <name> main                            [ commit => push => github ]
  > git config --global user.email "you@example.com"
  > git config --global user.name "Your Name"
  > git pull origin main --allow-unrelated-histories    ㄴ[Github => Local]
-----------------------------------------------------------------------------------------
  git branch                 [현재 브런치 확인]
  git branch -m master main    ㄴ[master -> main]
*/





//https://papabee.tistory.com/37
/*
Null Safety 가 지원이 되려면 가장 기본적으로
변수 선언시 Nullable 과 Non-Nullable 로 구분되어 선언해 주어야 한다.
이는 컴파일러에게 이 변수에 null 이 대입이 될수 있는지 될수 없는지를
명확하게 알려주자는 개념이고 이렇게 컴파일러에게 정보를 주면 컴파일러가 알아서
Non-Nullable 변수에 null 이 대입되는 상황의 에러를 발생시켜 주거나,
Nullable 변수를 NPE 를 고려하지 않고 작성하는 상황을 에러를 발생시켜 주게 된다.
Dart 언어의 변수는 기본이 Non-Nullable 로 선언되는 것이며
만악 Nullable 로 선언하고자 한다면 타입명 뒤에 ? 를 추가해 주어야 한다.

https://kkangsnote.tistory.com/98
*/







class CusTab extends StatelessWidget {
  final String Tabbar;
  final String subtitle;
  final Function onClick;
  final Color background;
  final Color highlight;
  final bool border;

  const TDBox(
      @required this.title,{
        Key? key,
        this.subtitle = "",
        required this.onClick,
        this.background = Colors.white,
        this.highlight = Colors.white38,
        this.border = false
      }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(background)),
      onPressed:onClick(),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          width: 70,
          //color: background,
          child:Center(
            child: Column(
              children: [
                Text(title, style: TextStyle(color:Colors.black,fontSize: 20),),
                Text(subtitle, style: TextStyle(color:Colors.black45,fontSize: 15),),
              ],
            )
          ),
        ),
      ),
    );
  }
}
*/