import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/bloc/states.dart';
import 'package:todo_app/widgets.dart';

import 'bloc/bloc_observer.dart';

void main() {


  BlocOverrides.runZoned(
        () {
          runApp( MaterialApp(
              debugShowCheckedModeBanner: false,
              home:  MyApp()));
    },
    blocObserver: MyBlocObserver(),
  );


}

class  MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);




  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context ) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              backgroundColor: Colors.deepPurple[200],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
              fallback: (BuildContext context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.deepPurple[100],
              elevation: 15.0,
              // showSelectedLabels: false,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if(formKey.currentState!.validate()){

                   cubit.insertToDatabase(
                       title: titleController.text,
                       time: timeController.text,
                       date: dateController.text,
                   );
                 }

                } else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      padding:const EdgeInsets.all(20),
                      color: Colors.white,
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextFormField(
                                controller: titleController,
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultTextFormField(
                                controller: timeController,
                                inputType: TextInputType.datetime,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultTextFormField(
                                controller: dateController,
                                inputType: TextInputType.datetime,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2050-05-03'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value!);
                                    print(DateFormat.yMMMd().format(value));
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                  );
                }
              },
            ),
            drawer: const Drawer(),
          );
        }),
    );
}








}


