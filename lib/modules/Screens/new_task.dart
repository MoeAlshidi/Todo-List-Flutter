import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/Shared/bloc.dart';
import 'package:todo_app/modules/Shared/state.dart';

import 'package:todo_app/modules/components.dart';

class NewTaskScreen extends StatelessWidget {
  dynamic scafKey = GlobalKey<ScaffoldState>();
  dynamic formKey = GlobalKey<FormState>();
  dynamic taskController = TextEditingController();

  NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        AppCubit tasksCubit = AppCubit.get(context);
        var taskMap = tasksCubit.tasks;

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Scaffold(
            key: scafKey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (tasksCubit.bottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    tasksCubit.insertDatabase(title: taskController.text);
                    tasksCubit.changeBottomSheetStatus(
                        isShow: false, icon: Icons.edit);
                    taskController.clear();
                  }
                } else {
                  tasksCubit.changeBottomSheetStatus(
                      isShow: true, icon: Icons.add);
                  scafKey.currentState!.showBottomSheet(
                    (context) => SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Container(
                          color: Colors.grey[200],
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: taskController,
                              autofocus: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter The Task';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Icon(tasksCubit.fabIcon),
            ),
            body: ListView.separated(
              itemBuilder: (
                context,
                index,
              ) {
                return taskListView(taskMap[index], tasksCubit);
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 20,
                ),
              ),
              itemCount: tasksCubit.tasks.length,
            ),
          ),
        );
      },
    );
  }
}
