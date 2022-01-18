import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/Screens/archived.dart';
import 'package:todo_app/modules/Screens/done_task.dart';
import 'package:todo_app/modules/Screens/new_task.dart';
import 'package:todo_app/modules/Shared/state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitStates());

  static AppCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  int currentindex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedScreen(),
  ];
  Database? database;

  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeScreen(index) {
    currentindex = index;
    emit(ChangeScreens());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // When creating the db, create the table
        print("database created");
        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,status TEXT)")
            .then((value) {
          print('Table is created!');
        }).catchError((error) {
          print("the error creating table ${error.toString()}");
        });
      },
      onOpen: (database) {
        print("database opened");
        readFromData(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDataBase());
    });
  }

  void insertDatabase({required String title}) {
    database?.transaction((txn) {
      return txn
          .rawInsert(
              "INSERT INTO tasks(title, status) VALUES( '$title',  'new')")
          .then((value) {
        print("inserted Seccessfully ");
        emit(InsertToDataBase());
        readFromData(database);
      }).catchError((error) {
        print("Error While inserting ${error.toString()}");
      });
    });
  }

  void readFromData(database) {
    tasks = [];
    doneTasks = [];
    archivedTasks = [];
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['status'] == 'new') {
          tasks.add(e);
        } else if (e['status'] == 'done') {
          doneTasks.add(e);
        } else if (e['status'] == 'archived') {
          archivedTasks.add(e);
        }
      });
      emit(ReadFromDataBase());
    });
  }

  void updateDatabaseState({required String state, required int id}) {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      state,
      id,
    ]).then((value) {
      readFromData(database);
      emit(UpdateDatabaseStatus());
    }).catchError((error) {
      print(error);
    });
  }

  void deletefromdata({required int id}) {
    database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      readFromData(database);
      emit(DeleteFromDatabase());
    }).catchError((error) {
      print(error);
    });
  }

  bool bottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetStatus({
    required bool isShow,
    required IconData icon,
  }) {
    bottomSheetShown = isShow;
    fabIcon = icon;
    emit(BottomSheetStatus());
  }
}
