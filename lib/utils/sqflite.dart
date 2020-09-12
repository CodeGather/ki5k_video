// /* 
//  * @Author: 21克的爱情
//  * @Date: 2020-09-02 21:03:09
//  * @Email: raohong07@163.com
//  * @LastEditors: 21克的爱情
//  * @LastEditTime: 2020-09-03 12:58:21
//  * @Description: 
//  */
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class SQflite{
//   String dbPath;
//   static Database kI5KDB;

//   void getInstance() async {
//     print('getInstance');
//     if (kI5KDB == null) {

      
//     }
//   }

//   /// delete the db, create the folder and returnes its path
//   Future<String> initDeleteDb(String dbName) async {
//     final databasePath = await getDatabasesPath();
//     // print(databasePath);
//     final path = join(databasePath, dbName);

//     // make sure the folder exists
//     if (await Directory(dirname(path)).exists()) {
//       await deleteDatabase(path);
//     } else {
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (e) {
//         print(e);
//       }
//     }
//     return path;
//   }

//   // 插入数据
//   Future<int> createTable(String tableBook, String columnId, String columnName, String columnAuthor, String columnPrice, String columnPublishingHouse ) async {
//     // 获取数据库文件的存储路径
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'ki5k.db');
    
//     // 创建数据库表
//     kI5KDB = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
//       await db.execute('''
//         CREATE TABLE $tableBook (
//           $columnId INTEGER PRIMARY KEY, 
//           $columnName TEXT, 
//           $columnAuthor TEXT, 
//           $columnPrice REAL, 
//           $columnPublishingHouse TEXT)
//         ''');
//     });
//   }

//   // 插入数据
//   Future<int> rawInsert(String sql, [List<dynamic> arguments]){

//   }


//   Future<int> insert(String table, Map<String, dynamic> values, {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}){

//   }


//   // 查询数据
//   Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic> arguments]){
    
//   }

//   Future<List<Map<String, dynamic>>> query(String table, {bool distinct,
//     List<String> columns,
//     String where,
//     List<dynamic> whereArgs,
//     String groupBy,
//     String having,
//     String orderBy,
//     int limit,
//     int offset
//   }){
          
//   }

//   // 更新数据
//   Future<int> rawUpdate(String sql, [List<dynamic> arguments]){
    
//   }

//   Future<int> update(String table, Map<String, dynamic> values, {
//     String where,
//     List<dynamic> whereArgs,
//     ConflictAlgorithm conflictAlgorithm
//   }){
    
//   }

//   // 删除
//   Future<int> rawDelete(String sql, [List<dynamic> arguments]){
    
//   }

//   Future<int> delete(String table, {String where, List<dynamic> whereArgs}){
    
//   }

//   // 关闭数据库
//   Future close() async => kI5KDB.close();

// }