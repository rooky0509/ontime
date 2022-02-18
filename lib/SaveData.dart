import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  SaveData();
  void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //counter = prefs.getInt(key) ?? 0;
    prefs.setString(key, value);
  }
  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(key) ?? "";
    return result;
  }
  void setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //counter = prefs.getInt(key) ?? 0;
    prefs.setStringList(key, value);
  }
  Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList(key) ?? [];
    return result;
  }
}

class Cell {  //1과목
  String label, subject, teacher;
  List<int> start, end;
  
  Cell({
    this.label = "1교시",
    this.subject = "국어",
    this.teacher = "ㅇㅇㅇ",
    this.start = const [8,30,0],
    this.end = const [9,20,0],
  });
  
  String toString() => jsonEncode({
    "label" : label,
    "subject" : subject,
    "teacher" : teacher,
    "start" : start,
    "end" : end,
  });

  Cell fromString(String jsonStr){
    Map<String,dynamic> json = jsonDecode(jsonStr);
    label = json["label"];
    subject = json["subject"];
    teacher = json["teacher"];
    start = json["start"];
    end = json["end"];
    return Cell(
      label : json["label"],
      subject : json["subject"],
      teacher : json["teacher"],
      start : json["start"] as List<int>,
      end : json["end"] as List<int>,
    );
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