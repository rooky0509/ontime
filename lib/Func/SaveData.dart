import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

  SaveData saveData = SaveData(); //저장관리Class 생성
  CellTable cellTable = CellTable([]).fromJsonStr(saveData().get("cellTable_0")); //월요일의 시간표


 */

class SaveData {
  SaveData();
  void save(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //counter = prefs.getInt(key) ?? 0;
    prefs.setString(key, value);
  }
  Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(key) ?? "";
    return result;
  }
}

class Cell {  //1과목
  String? label, subject, teacher;
  List<int>? start, end;
  
  Cell({
    this.label,
    this.subject,
    this.teacher,
    this.start,
    this.end,
  });

  Widget toWidget(){ //Widget으로 보여주기
    return Container();
  }

  String toJsonStr(){ //현재값을 String화 해서 return
    Map<String,dynamic> json = {
      "label":label,
      "subject":subject,
      "teacher":teacher,
      "start":start,
      "end":end
    };
    String jsonStr = jsonEncode(json);
    return jsonStr;
  }
  Cell fromJsonStr(String jsonStr){ //불러와서 덮어쓰기
    Map<String,dynamic> json = jsonDecode(jsonStr);
    label = json["label"];
    subject = json["subject"];
    teacher = json["teacher"];
    start = json["start"];
    end = json["end"];
    return Cell(
      label:label,
      subject:subject,
      teacher:teacher,
      start:start,
      end:end,
    );
  }

}

class CellTable { //1일
  List<Cell> cells = [];
  
  CellTable({
    required this.cells
  });

  void add(Cell addCell)  //셀 테이블레 셀 추가
    => cells.add(addCell);
  void addAll(List<Cell> addCells) //셀 테이블에 셀들을 추가
    => cells.addAll(addCells);
  void edit(int index, Cell editCell) //셀 테이블의 Index칸의 셀 덮어쓰기
    => cells[index] = editCell;
  void sort() => cells.sort((a, b)  //셀 Start순으로 정렬
    => (a.start![0]*360+a.start![1]*60+a.start![2])-(b.start![0]*360+b.start![1]*60+b.start![2]));
  
  Widget toWidget(){ //Widget으로 보여주기
    return Container();
  }

  String toJsonStr(){ //현재값을 String화 해서 return
    Map<String,dynamic> json = {
      "cells":cells.map((e) => e.toJsonStr()).toList() // CellTable->Cell => CellTable->Str(Cell)
    };
    String jsonStr = jsonEncode(json); // CellTable->Str(Cell) => Str(CellTable->Str(Cell))
    return jsonStr;
  }
  CellTable fromJsonStr(String jsonStr){ //불러와서 덮어쓰기
    Map<String,dynamic> json = jsonDecode(jsonStr); // Str(CellTable->Str(Cell)) => CellTable->Str(Cell)
    cells = json["cells"].map((e)=>Cell().fromJsonStr(e)).toList(); // CellTable->Str(Cell) => CellTable->Cell
    return CellTable(cells:cells);
  }
}

/*

Class만들기
  ㄴ https://duzi077.tistory.com/294
    : Class 기본
  ㄴ https://duzi077.tistory.com/295?category=788936
    : Parameter optional
  ㄴ https://eunjin3786.tistory.com/273
    : Getter

Shared Preferences
  ㄴ https://flutter-ko.dev/docs/cookbook/persistence/key-value
    : Shared 기본
  ㄴ https://dev-yakuza.posstree.com/ko/flutter/shared-preferences/
    : Shared 기본
  ㄴ https://betterprogramming.pub/flutter-how-to-save-objects-in-sharedpreferences-b7880d0ee2e4
    : Custom Object
*/

/*
{
  0:{ weekend
    0:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"}, 
    1:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"}
  },
  1:{
    0:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
    1:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"}
  },
  2:{
    0:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"},
    1:{"tag":"1교시","start":[08,40,00],"end":[09,30,00],"name":"국어","teacher":"ㅐㅐㅐ"}
  },
}
TextEdit({
  required String label,
  required String hint,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
}) {
  assert(hint != null);
  assert(onSaved != null);
  assert(validator != null);
 */