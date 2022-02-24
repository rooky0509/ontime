import 'package:flutter/material.dart';

class Lunch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 10, //1 개의 행에 보여줄 item 개수
        childAspectRatio: 1 / 4, //item 의 가로 1, 세로 2 의 비율
        mainAxisSpacing: 10, //수평 Padding
        crossAxisSpacing: 10, //수직 Padding
        children: [
          InkWell(
            child:Hero(
              tag: "Lunch_heroTag",
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              )
            ),
            onTap: () {
                Navigator.pop(context);
            },
          )
        ]
      ),
    );
  }
}