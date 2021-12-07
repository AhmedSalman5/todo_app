import 'package:flutter/material.dart';
import 'package:todo_app/bloc/cubit.dart';

Widget buildTaskItem (Map model,context) => Padding(
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




