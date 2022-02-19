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


  void remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

class Cell {  //1과목
  String label, subject, teacher;
  List<int> start, end;
  //bool isActive;
  
  Cell({
    this.label = "1교시",
    this.subject = "국어",
    this.teacher = "ㅇㅇㅇ",
    this.start = const [8,30,0],
    this.end = const [9,20,0],
    //this.isActive = false,
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
    start = json["start"].cast<int>();
    end = json["end"].cast<int>();
    //isActive = false;
    return Cell(
      label : label,
      subject : subject,
      teacher : teacher,
      start : start,
      end : end,
      //isActive : false,
    );
  }

  DateTime toDateTime(DateTime today, {bool type = true}){
    today = today.subtract(Duration(milliseconds: today.millisecond));
    List<int> target = type?start:end;
    int targetHour = target[0];
    int targetMin = target[1];
    int targetSec = target[2];
    DateTime targetTime = DateTime(today.year, today.month, today.day, targetHour, targetMin, targetSec);
    return targetTime;
  }

  Map<String,dynamic> remainDuration(DateTime today){
    today = today.subtract(Duration(milliseconds: today.millisecond));
    /*
    int startHour = start[0];
    int startMin = start[1];
    int startSec = start[2];
    DateTime startTime = DateTime(today.year, today.month, today.day, startHour, startMin, startSec);
    */
    Duration remainToStartDuration = toDateTime(today,type:true).difference(today);
    //DateFormat.Hms().format(remainToStartDuration);
    String startRemainText = "${remainToStartDuration.inHours.abs().toString().padLeft(2, "0")}:${remainToStartDuration.inMinutes.remainder(60).abs().toString().padLeft(2, "0")}:${remainToStartDuration.inSeconds.remainder(60).abs().toString().padLeft(2, "0")}";
    /*
    int endHour = end[0];
    int endMin = end[1];
    int endSec = end[2];
    DateTime endTime = DateTime(today.year, today.month, today.day, endHour, endMin, endSec);
    */
    Duration remainToEndDuration = toDateTime(today,type:false).difference(today);
    String endRemainText = "${remainToEndDuration.inHours.abs().toString().padLeft(2, "0")}:${remainToEndDuration.inMinutes.remainder(60).abs().toString().padLeft(2, "0")}:${remainToEndDuration.inSeconds.remainder(60).abs().toString().padLeft(2, "0")}";
    
    bool startYet = (remainToStartDuration.inMicroseconds > 0);
    bool endYet = (remainToEndDuration.inMicroseconds > 0);
    bool isStart = startYet & endYet;

    //print("[$label]$subject : 0$remainToStartDuration -- 0$remainToEndDuration -- $startYet:$endYet");
    //print("[$label]$subject : $startRemainText        -- $endRemainText        -- ${today.millisecond}");
    
    return {
      "start" : startRemainText,
      "end" : endRemainText,
      "startYet" : startYet, //ture : 넣은값이 아직 더 작음 / false : 넣은값이 더 커짐
      "endYet" : endYet, //ture : 넣은값이 아직 더 작음 / false : 넣은값이 더 커짐
      "isStart" : isStart, //ture : start< 값 <end
    };
  }

  Future<bool> editDialog(BuildContext context) async{
    final formKey = GlobalKey<FormState>();
    String? resultLabel, resultSubject, resultTeacher;
    List<int>? resultStart, resultEnd;
    //bool validateState = formKey.currentState==null?true:formKey.currentState!.validate(); //yesButton에서만 사용
    Widget tff({required String label,required initial ,required FormFieldSetter onSaved,required FormFieldValidator validator,}) {
      Widget widget = TextFormField(
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.always,
        onSaved: onSaved,  //함수
        validator: validator,  //함수
        initialValue: initial,  //박스 안 내용
        decoration: InputDecoration(  //박스 스타일
          contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),  //내용패딩
          
          labelText: label,  // 라벨
          helperText: initial,  //박스 밑 내용
          helperStyle: TextStyle(height: 0.5),
          errorStyle: TextStyle(height: 0.5),
          border: OutlineInputBorder(),  //박스 형태
        ),
      );
      return  ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: double.infinity),
          child:Container(color: Colors.blue.withOpacity(0.5), padding: EdgeInsets.all(10),child: widget,),
      );
    } 
    Widget yesButton() {
      bool validateState = formKey.currentState==null?true:formKey.currentState!.validate();
      print("yesButton() : formKey.currentState==null : ${formKey.currentState==null}");
      Widget widget = RaisedButton(
        color: validateState ? Colors.blue : Colors.grey,
        onPressed: () async {
          if (validateState){
            formKey.currentState!.save();
            print("formKey.currentState!.validate() == true");
            label = resultLabel??"LLL";
            subject = resultSubject??"SSS";
            teacher = resultTeacher??"TTT";
            start = resultStart??[0,0,0];
            end = resultEnd??[9,9,9];
            print("""
            label = ${resultLabel!};
            subject = ${resultSubject!};
  edit!!    teacher = ${resultTeacher!};
            start = ${resultStart}!;
            end = ${resultEnd!};
            """);
            print("Navigator.pop(context, true);");
            Navigator.pop(context, true);
          }
        },// validation 이 성공하면 true 가 리턴돼요!  //validation 이 성공하면 폼 저장하기
        child: Text(
          '\n저장하기!\n',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ); 
      return  ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: double.infinity),
        child:Container(color: Colors.amber.withOpacity(0.5), padding: EdgeInsets.all(10),child: widget,),
      );
    }
    Widget noButton() {
      Widget widget = RaisedButton(
        color: Colors.red,
        onPressed: () => Navigator.pop(context, false),
        child: Text(
          '\n끄기\n',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ); 
      return  ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: double.infinity),
        child:Container(color: Colors.red.withOpacity(0.5), padding: EdgeInsets.all(10),child: widget,),
      );
    }
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  tff(
                    label : "Label",
                    initial : label,
                    onSaved : (val) => resultLabel = val,
                    validator : (val) {
                      if(val.length < 1) return '필수사항입니다.';
                      return null;
                    },
                  ),
                  tff(
                    label : "Subject",
                    initial : subject,
                    onSaved : (val) => resultSubject = val,
                    validator : (val) {
                      if(val.length < 1) return '필수사항입니다.';
                      return null;
                    },
                  ),
                  tff(
                    label : "Teacher",
                    initial : teacher,
                    onSaved : (val) => resultTeacher = val,
                    validator : (val) {
                      if(val.length < 1) return '필수사항입니다.';
                      return null;
                    },
                  ),
                  Row(
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      
                      Expanded(child: tff(
                        label : "Start",
                        initial : start.map((e) => e.toString().padLeft(2,"0")).join(":"),
                        onSaved : (val) => resultStart = val.split(":").map((e)=>int.parse(e)).toList().cast<int>(),
                        validator : (val) { //^\d\d:\d\d:\d\d$
                          if(!RegExp(r"^\d\d:\d\d:\d\d$").hasMatch(val)) return "00:00:00 형식이 아닙니다.";
                          else print("00:00:00 형식");
                          return null;
                        },
                      )),
                  
                      Expanded(child: tff(
                        label : "End",
                        initial : end.map((e) => e.toString().padLeft(2,"0")).join(":"),
                        onSaved : (val) => resultEnd = val.split(":").map((e)=>int.parse(e)).toList().cast<int>(),
                        validator : (val) {
                          if(!RegExp(r"^\d\d:\d\d:\d\d$").hasMatch(val)) return "00:00:00 형식이 아닙니다.";
                          else print("00:00:00 형식");
                          return null;
                        },
                      )),
                    ],
                  ),
                  Row(
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(child: yesButton()),
                      Expanded(child: noButton()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    ).then((exit){
      print("Finish!! exxit : $exit");
      return exit??false;// user pressed Yes button return true
    });
    return result;
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