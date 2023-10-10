import 'dart:convert';
//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,
  this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController =TextEditingController();
   TextEditingController descriptionController =TextEditingController();
   bool isEdit=false;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;
    if(widget.todo !=null){
      isEdit=true;
      final title=todo?['title'];
      final description=todo?['description'];
      titleController.text =title;
      descriptionController.text=description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit page' :'Add page')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration:InputDecoration( hintText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration:InputDecoration( hintText: "Description"),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Center(child: ElevatedButton(
                onPressed: isEdit? updateData : submitData , child: Text(
                isEdit? 'UPDATE': "Submit"))),
            )
          ]
        ),
      )
    );
  }
  Future<void> updateData() async{
    final todo=widget.todo;
    if(todo ==null){
      print("can't call");
      return;
    }
    final id=todo['_id'];
    //final isComplited= todo['is_completed'];
         final title = titleController.text;
    final decription = descriptionController.text;
    final body ={ 
  "title": title,
  "description": decription,
  "is_completed": false,
 } ;
 final url= 'https://api.nstack.in/v1/todos/$id';
 final uri =Uri.parse(url);
 final response = await http.put(
  uri,
  body:jsonEncode(body),
  headers: {'Content-Type' :'application/json'}
  );

    if(response.statusCode ==200){
  
 print('Updation Success'); 
 showSuccessMessage('Updation Success');}
 else{
  print('Updation FAiled');
  showErrorMessage('Updation FAiled');
  print(response.body);
 }
  }
  Future<void> submitData() async{
    final title = titleController.text;
    final decription = descriptionController.text;
    final body ={ 
  "title": title,
  "description": decription,
  "is_completed": false,
 } ;
 const url= 'https://api.nstack.in/v1/todos';
 final uri =Uri.parse(url);
 final response = await http.post(
  uri,
  body:jsonEncode(body),
  headers: {'Content-Type' :'application/json'}
  );
 //print(response.statusCode);
 if(response.statusCode ==201){
  titleController.text='';
  descriptionController.text='';
 print('Creation Success'); 
 showSuccessMessage('Creation Success');}
 else{
  print('Creation FAiled');
  showErrorMessage('Creation FAiled');
  print(response.body);
 }
 
  }
  void showSuccessMessage(String message){
    final snackBar =SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar =SnackBar(content: Text(message),
    backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}