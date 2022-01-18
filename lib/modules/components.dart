import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget taskListView(
  Map model,
  cubit,
) =>
    Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green.shade400,
            foregroundColor: Colors.white,
            icon: Icons.done,
            label: 'Done',
            onPressed: (BuildContext context) {
              cubit.updateDatabaseState(
                state: 'done',
                id: model['id'],
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (BuildContext context) {
              cubit.deletefromdata(id: model['id']);
            },
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
              backgroundColor: Colors.orange.shade400,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archived',
              onPressed: (BuildContext context) {
                cubit.updateDatabaseState(
                  state: 'archived',
                  id: model['id'],
                );
              })
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                "${model['title']}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
