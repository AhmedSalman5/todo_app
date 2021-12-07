import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/bloc/cubit.dart';
// عملنا Dismissible عشان ال Item  يتحرك يمين وشمال
Widget buildTaskItem (Map model,context) => Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children:  [
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            radius: 40.0,
            child: Text(
              '${model['time']}',
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: const  TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status :'done', id: model['id']);
            },
            icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id: model['id']);
            },
            icon: const Icon(Icons.archive),
            color: Colors.black45,
          ),
        ],
      ),
    ),
    onDismissed:(direction){
      AppCubit.get(context).deleteData(id: model['id']);
    } ,
);



Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String? value) validator,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  GestureTapCallback?  onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      onTap: onTap,
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.deepPurple,fontSize: 18),
        prefixIcon: Icon(
          prefix,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.purple ),
        ),
      ),
      validator: validator,
    );



  Widget tasksBuilder({
  required List<Map> tasks,

}) => ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context)=>ListView.separated(
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
    ),
    fallback: (context)=> Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );




