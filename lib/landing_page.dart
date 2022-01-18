import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/Shared/bloc.dart';
import 'package:todo_app/modules/Shared/state.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.15),
            child: AppBar(
              flexibleSpace: Container(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18, bottom: 20),
                    child: Text(
                      DateFormat("dd.MM.yyyy").format(
                        DateTime.now(),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/coverimage.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'New Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Done Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_rounded),
                label: 'Archive',
              ),
            ],
            currentIndex: cubit.currentindex,
            onTap: (index) {
              cubit.changeScreen(index);
            },
          ),
          body: cubit.screens[cubit.currentindex],
        );
      },
    );
  }
}
