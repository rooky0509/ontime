import 'package:flutter/material.dart';
import 'package:ontime/data/saveData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Selfcheck {
  SelfcheckProvider provider = SelfcheckProvider();
  String title = "Selfcheck"; //제목
  Widget card = SelfcheckWidget(); //간략화된 위젯
  Widget page = SelfcheckPage(); //페이지 위젯
}

class SelfcheckPage extends StatelessWidget {
  /*
    값 읽기 : context.select((SelfcheckProvider value) => value.count)
    값 변경 : context.read<SelfcheckProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((SelfcheckProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(
            fontSize: 100.0,
            backgroundColor: Colors.amber,
            color: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class SelfcheckWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((SelfcheckProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 40.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().remove();
          },
          child: Icon(Icons.remove)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().save();
          },
          child: Icon(Icons.save)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SelfcheckProvider>().get();
          },
          child: Icon(Icons.get_app)
        ),
      ],
    );
  }
}

class SelfcheckProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;  
  final SaveData _saveData = SaveData.instance..set(tableName: "Schedule", tableAttributede: {
    "iddd" : "INTEGER PRIMARY KEY",
    "numA" : "INTEGER",
    "numB" : "INTEGER",
    "numC" : "INTEGER",
  });

  void add() {
    _count++;
    print("$_count");
    notifyListeners();
  }

  void remove() {
    _count--;
    print("$_count");
    notifyListeners();
  }

  void save() async{ // →DB
    _saveData.UPDATE(data: {
      "iddd" : 1,
      "numA" : _count*1,
      "numB" : _count*2,
      "numC" : _count*3,
    });
    print("setInt!!@");
  }

  void get() async{  // ←DB
    print("getInt!START!!!!");
    _saveData.SELECT(whereKey: "iddd", whereArg: 1).then((value){
      _count = value[0]["numC"];
      notifyListeners();
      print("getInt!! END----------");
    });
  }
}
//Navigator.pop(context);