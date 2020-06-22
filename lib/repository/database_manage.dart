import 'dart:async';
import 'dart:io';

import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager _instance = new DatabaseManager.internal();
  factory DatabaseManager() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseManager.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onOpen: _onOpen);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    try {
      await db.execute('''
create table if not exists Cart (
  _id integer primary key autoincrement,
  category text,
  count integer,
  description text,
  id text,
  imageLink text,
  name text,
  service text,
  restockingAt text,
  price double
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists $merchantTable (
  _id integer primary key autoincrement,
  shopName text,
  displayPicture text,
  cardViewLine2 text,
  flag text,
  merchantID text,
  address1 text,
  address2 text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists Config (
  _id integer primary key autoincrement,
  id integer,
  name text,
  description text,
  image text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists User (
  _id integer primary key autoincrement,
  id integer,
  email text,
  first_name text,
  last_name text,
  last_login text,
  username text,
  date_joined text,
  avatar text,
  phone text,
  address text,
  user_type text,
  rating text
  )
''');
    } catch (e) {
      print(e);
    }
  }

  void _onOpen(Database db) async {
    try {
      await db.execute('''
create table if not exists User (
  _id integer primary key autoincrement,
  id integer,
  email text,
  first_name text,
  last_name text,
  last_login text,
  username text,
  date_joined text,
  avatar text,
  phone text,
  user_type text,
  rating text
  )
''');
    } catch (e) {
      print(e);
    }

    try {
      await db.execute('''
create table if not exists Config (
  _id integer primary key autoincrement,
  id integer,
  name text,
  description text,
  image text
  )
''');
    } catch (e) {
      print(e);
    }
  }
}
