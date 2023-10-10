import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State <TodoListPage> createState() =>  _TodoListPageState();
}

class  _TodoListPageState extends State <TodoListPage> {
  bool isLoading=true;
  List items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount:items.length,
            
            itemBuilder : (context,index){
              final item =items[index] as Map;
              final id=item['_id'] as String;
      
            return ListTile(
              leading :CircleAvatar(child: Text('${index +1}')),
              title : Text(item['title']),
              subtitle : Text(item['description']),
              trailing :PopupMenuButton(
                onSelected: (value){
                  if(value=='edit'){
                    navigateToEditPage(item);
                  }
                  else if(value=='delete'){
                      deleteById(id);
                  }
                },
                itemBuilder: (context){
                return[
                  PopupMenuItem(child: 
                  Text("edit"),
                  value: 'edit'),
                   PopupMenuItem(child: 
                   Text("delete"),
                  value: 'delete'
                  ),
                ];
              },)
            );
          }),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddPage, 
      
      heroTag :'uniqueTag',
      label : Row(
        children: [Icon(Icons.add),Text('add')],
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
   Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context)=> AddTodoPage(todo:item), );
     await Navigator.push(context,route);
     setState(() {
       isLoading =true;
     });
     fetchTodo();
  }
  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context)=> AddTodoPage(), );
     await Navigator.push(context,route);
     setState(() {
       isLoading =true;
     });
     fetchTodo();
  }
   Future<void> deleteById(String id) async{
      final url='https://api.nstack.in/v1/todos/$id';
      final uri=Uri.parse(url);
      final response = await http.delete(uri);
      if(response.statusCode ==200){

        final filtered =items.where((element)=> element['_id']!=id).toList();
        setState(() {
          items=filtered;
        });
      }
      else{
        showErrorMessage('Deletion Failed');
      }
  }
  Future<void> fetchTodo()async{
    setState(() {
      
      isLoading=false;
    });
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri =Uri.parse(url);
    final response = await http.get(uri);
    if( response.statusCode ==200){
  //final json =jsonDecode(response.body) as Map;
      final json =jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items=result;
      });
    } setState(() {
      
      isLoading=false;
    });
    
    //print(response.statusCode);
   // print(response.body);
  }
  void showErrorMessage(String message){
    final snackBar =SnackBar(content: Text(message),
    backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}