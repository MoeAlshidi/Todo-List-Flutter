import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/Shared/bloc.dart';
import 'package:todo_app/modules/Shared/state.dart';
import 'package:todo_app/modules/components.dart';

class DoneTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        AppCubit tasksCubit = AppCubit.get(context);
        var taskMap = tasksCubit.doneTasks;

        return ListView.separated(
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
          itemCount: tasksCubit.doneTasks.length,
        );
      },
    );
  }
}
