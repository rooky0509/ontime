import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting {
  SettingProvider provider = SettingProvider();
  String title = "Setting"; //제목
  Widget card = SettingWidget(); //간략화된 위젯
  Widget page = SettingPage(); //페이지 위젯
}

class SettingPage extends StatelessWidget {
  /*
    값 읽기 : context.select((SettingProvider value) => value.count)
    값 변경 : context.read<SettingProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((SettingProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(
            fontSize: 100.0,
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
    );
  }
}

class SettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((SettingProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 40.0),
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
    );
  }
}

class SettingProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;  

  void add() {
    _count++;
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }

  void save() { // →Shared
    _count--;
    notifyListeners();
  }

  void get() {  // ←Shared
    _count--;
    notifyListeners();
  }
}
//Navigator.pop(context);