import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SaveData {
  //#region Database
  SaveData._privateConstructor();
  static final SaveData instance = SaveData._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();//
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  //#endregion
  //#region Table
  String? tableName;
  Map<String,dynamic>? tableAttributede; 
  void set({required String tableName, required Map<String,dynamic> tableAttributede}){
    this.tableName = tableName;
    this.tableAttributede = tableAttributede; //id INTEGER PRIMARY KEY, name TEXT
  }
  Future _onCreate(Database db, int version) async {
    print("run!! : CREATE TABLE ${tableName!}(${tableAttributede!.entries.map((e) => '${e.key} ${e.value}').join(', ')})");
    await db.execute("CREATE TABLE ${tableName!}(${tableAttributede!.entries.map((e) => '${e.key} ${e.value}').join(', ')})");
  }

  //#endregion
  //#region DML(Data Manipulation Language)
  /*
    SELECT : Table에서 WhereKey가 whereArg인 튜플을 찾은 후 출력 => List<Map>
    INSERT : Table에 Map을 넣음
    DELETE : Table에서 WhereKey가 whereArg인 튜플을 삭제
    UPDATE : Table에서 WhereKey가 whereArg인 튜플을 수정 (flutter에선 덮어쓰기)
  */

  Future<List<Map<String, dynamic>>> SELECT({String? whereKey, dynamic whereArg, String? orderKey, bool ASC = true}) async {
    Database db = await instance.database;
    //(await db.query('assetportfolio', where: 'kind = ?', whereArgs: [kind])) await db.query(tableName!) await db.rawQuery("SELECT ${tableAttributede!.keys.join(', ')} FROM ${tableName!} $other") //db.query(tableName!, where: '$key = ?', whereArgs: [value]); // db.rawQuery( "SELECT id, name, age FROM dogs" );
    List<Map<String, Object?>> selected = await db.query(
      tableName!, 
      where: (whereKey==null)&(whereArg==null)?null:'$whereKey = ?',
      whereArgs: (whereKey==null)&(whereArg==null)?null:[whereArg!],
      orderBy: (orderKey==null)?null:'$orderKey ${ASC?"ASC":"DESC"}',
    );
    return selected;
  }
  Future<void> INSERT({required Map<String,dynamic> data}) async {
    Database db = await instance.database;
    await db.insert(tableName!, data);
  }
  Future<void> DELETE({required String whereKey, required String whereArg}) async {
    Database db = await instance.database;
    await db.delete(
      tableName!,
      where: whereKey, whereArgs: [whereArg]
    );
  }
  Future<void> UPDATE({required Map<String,dynamic> data}) async {
    Database db = await instance.database;
    await db.update(
      tableName!, data
      //where: whereKey, whereArgs: [whereArg]
    );
  }
  //#endregion

}
/* 
class SaveData {
  Database? database;
  String? table;
  Map? attributes;

  SaveData() async{};

  Future<void> openDB(String table, Map attributes) async {
    this.table = table;
    this.attributes = attributes;
    database = await openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'), // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      onCreate: (db, version) { // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
        return db.execute(
          "CREATE TABLE $table(${attributes.entries.map((e) => "${e.key} ${e.value}").join(', ')})",
          //"CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1, // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를 수행하기 위한 경로를 제공합니다.
    );
  }

  Future<void> insertDog(Dog dog) async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database!;

    // Dog를 올바른 테이블에 추가하세요. 또한  
    // `conflictAlgorithm`을 명시할 것입니다. 본 예제에서는
    // 만약 동일한 dog가 여러번 추가되면, 이전 데이터를 덮어쓸 것입니다.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database!;

    // 모든 Dog를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // List<Map<String, dynamic>를 List<Dog>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database!;

    // 주어진 Dog를 수정합니다.
    await db.update(
      'dogs',
      dog.toMap(),
      // Dog의 id가 일치하는 지 확인합니다.
      where: "id = ?",
      // Dog의 id를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // 데이터베이스 reference를 얻습니다.
    final db = await database!;

    // 데이터베이스에서 Dog를 삭제합니다.
    await db.delete(
      'dogs',
      // 특정 dog를 제거하기 위해 `where` 절을 사용하세요
      where: "id = ?",
      // Dog의 id를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [id],
    );
  }

  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );
}
 */
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // 각 dog 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}