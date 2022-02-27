import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Schedule {
  ScheduleProvider provider = ScheduleProvider();
  String title = "Schedule"; //제목
  Widget card = ScheduleWidget(); //간략화된 위젯
  Widget page = SchedulePage(); //페이지 위젯
}

class SchedulePage extends StatelessWidget {
  /*
    값 읽기 : context.select((ScheduleProvider value) => value.count)
    값 변경 : context.read<ScheduleProvider>().add();
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((ScheduleProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(
            fontSize: 100.0,
            backgroundColor: Colors.amber,
            color: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class ScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.select((ScheduleProvider value) => value.count).toString(), // count를 화면에 출력
          style: TextStyle(fontSize: 40.0),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().add();
          },
          child: Icon(Icons.add,)
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ScheduleProvider>().remove();
          },
          child: Icon(Icons.remove)
        )
      ],
    );
  }
}

class ScheduleProvider with ChangeNotifier {
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