import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Lunch {
  LunchProvider provider = LunchProvider();
  String title = "Lunch"; //제목
  Widget card = LunchWidget(); //간략화된 위젯
  Widget page = LunchPage(); //페이지 위젯
}

class LunchPage extends StatelessWidget {
  /*
    값 읽기 : context.select((LunchProvider value) => value.count)
    값 변경 : context.read<LunchProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((LunchProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(
            fontSize: 100.0,
            backgroundColor: Colors.amber,
            color: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<LunchProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<LunchProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class LunchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((LunchProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 40.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<LunchProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<LunchProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class LunchProvider with ChangeNotifier {
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