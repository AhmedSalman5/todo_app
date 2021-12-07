import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/bloc/states.dart';
import 'package:todo_app/screens/archived_tasks.dart';
import 'package:todo_app/screens/done_tasks.dart';
import 'package:todo_app/screens/new_tasks.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }



  void createDatabase()  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // ignore: avoid_print
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT, status TEXT) ')
            .then((value) {
          // ignore: avoid_print
          print('table created');
        }).catchError((error) {
          // ignore: avoid_print
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
       getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async{
    await database?.transaction((txn) => txn.rawInsert(
      'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
    ).then((value) {
      // ignore: avoid_print
      print('$value inserted successfully');
      emit(AppInsertDatabaseState());

      getDataFromDatabase(database);

    }).catchError((error) {
      // ignore: avoid_print
      print('Error when Inserting New Record ${error.toString()}');
    }));
  }

  void getDataFromDatabase (database) {
    // بنصفر عشان ميضيفش علي الي وجود لكل get جديده 
    newTasks =[];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
     database!.rawQuery(
        'SELECT * FROM tasks'
    ).then((value) {
       value.forEach((element){
        if(element['status'] == 'new'){
          newTasks.add(element);
        }else if(element['status'] == 'done'){
          doneTasks.add(element);
        }else {
          archivedTasks.add(element);
        }
       });

       emit(AppGetDatabaseState());
     });
  }

  
  
  void updateData({
  required String status,
  required int id,
}) async{
    database!.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        [status,id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  
  


  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required isShow,
  required icon,
}){
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
}

}