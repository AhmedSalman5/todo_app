import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/bloc/states.dart';
import 'package:todo_app/widgets.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).newTasks;
          return ListView.separated(
            itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length,
          );
        },
    );
  }
}