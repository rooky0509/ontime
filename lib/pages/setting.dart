import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ontime/data/saveData.dart';

class Setting {
  SettingProvider provider = SettingProvider();
  String title = "Setting"; //제목
  Widget card = SettingWidget(); //간략화된 위젯
  Widget page = SettingPage(); //페이지 위젯
  void loading ()=> SettingProvider().get();
}

class SettingPage extends StatelessWidget {
  /*
    값 읽기 : context.select((SettingProvider value) => value.count)
    값 변경 : context.read<SettingProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SettingPage!\n${context.select((SettingProvider value) => value.str).toString()}", // count를 화면에 출력
            style: TextStyle(
              fontSize: 40.0,
              backgroundColor: Colors.amber,
              color: Colors.blue,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingProvider>().add();
            },
            child: Icon(Icons.add,)
          ),
          SizedBox(
            width: 40,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingProvider>().remove();
            },
            child: Icon(Icons.remove)
          )
        ],
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}
class _SettingWidgetState extends State<SettingWidget> {
  bool load = false;
  @override
  Widget build(BuildContext context) {
    print("[SettingWidget] load{$load}");
    if(!(load)) {
      print("[SettingWidget] load is start");
      context.read<SettingProvider>().get().then((value){
        print("[SettingWidget] load is finish");
        setState(() {load = true;});
      });
    }
    print("[SettingWidget] build{$load}");
    return load?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((SettingProvider value) => "SettingProvider\n${value.str}").toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 20.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingProvider>().remove();
          },
          child: Icon(Icons.remove)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingProvider>().save();
          },
          child: Icon(Icons.save)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingProvider>().get();
          },
          child: Icon(Icons.get_app)
        ),
      ],
    ):CircularProgressIndicator();
  }
}

class SettingProvider with ChangeNotifier {
  int start = 0;
  int len = 0;
  int week = 0;
  String title = "";
  String detail = "";

  String _str = "";
  String get str => _str;

  final SaveData _saveData = SaveData(tableName: "Setting", tableAttributede: {
    "start" : "INTEGER PRIMARY KEY",
    "len" : "INTEGER",
    "title" : "TEXT",
    "detail" : "TEXT",
  });
  
  void add() {
    print("[SettingProvider] add");
    DateTime now = DateTime.now(); //now.hour*3600 + now.minute*60 + now.second
    week = now.weekday-1;
    start = (now.hour*3600 + now.minute*60 + now.second) + (86400 * week);// [0~86399] + [0, 86400, 86400*2, ...] = [0~86399,86400~172,799]
    title = "Title : $start ~ ${start+len}";
    detail = "Detail : ${start%86400} ~ ${(start+len)%86400}";
    print("${now.weekday}/$start = ${DateTime(now.year,now.month,now.day).add(Duration(seconds: start))}");
    notifyListeners();
  }

  void remove() {
    print("[SettingProvider] remove");
    len += 10;
    print("$len");
    notifyListeners();
  }

  Future<void> save() async{ // →DB
    print("[SettingProvider] save");
    _saveData.INSERT(data: {
      "start" : start,
      "len" : len,
      "title" : title,
      "detail" : "$detail : $week",
    }).then((value) => print("------save : FINISH"));
  }


  Future<void> get() async{  // ←DB
    print("[SettingProvider] get");
    print("------get : START");
    //_saveData.SELECT().then((value) => print("getAll : value = [\n  ${value.join(',\n  ')}\n]"));
    //_saveData.SELECT().then((value) => print("getAll : value = [  ${value.join(',  ')}  ]"));
    _saveData.SELECT(orderKey: "start").then((value){
      print("get : value =  : $value");
      if(value.isEmpty){
        _str = "value is Empty";
        notifyListeners();
        print("get : value is Empty");
      }else{
        int l = value.length-1;
        start = value[l]["start"]%86400;
        len = value[l]["len"];
        week = value[l]["start"]~/86400;
        title = value[l]["title"];
        detail = value[l]["detail"];
        _str = "${value[l]["start"]}=>\nstart : $start[$len] \n$title \n$detail";
        notifyListeners();
        print("------get : FINISH");
      }
    });
  }

  Future<void> clear() async{  // ←DB
    print("[ScheduleProvider] clear");
    print("------clear : START");
    _saveData.DELETE().then((value){
      print("------clear : FINISH");
    });
  }
}
//Navigator.pop(context);