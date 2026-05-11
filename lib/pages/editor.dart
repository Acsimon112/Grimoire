import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimoire/pages/home.dart';

class EditorPage extends StatefulWidget{
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

Future<void> saveNote(TextEditingController title, TextEditingController content) async {
  await FirebaseFirestore.instance.collection('notes').add({
    'title': title.text,
    'content': content.text,
    'createdAt': Timestamp.now(),
  });
}

class _EditorPageState extends State<EditorPage> {
  @override
  void initState(){
    super.initState();
  }
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
    
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //---TITLE IN APP BAR BECAUSE ITS COOL---
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: "Untitled",
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),

    drawer: Drawer(
      //---NAVIGATION SIDEBAR---
      child:ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Menu")
          ),
          ListTile(
            title: Text("Home"),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: "Grimoire"))
                );
            },
          ),
          ListTile(
            title: Text("Save"),
            onTap: () {saveNote(titleController, noteController);}
          ),
        ],
      )
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
            Expanded(
              //---Note editor proper---
              child:TextField(
                controller: noteController,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Write your notes here..."
                
                  
                ),
              )
                
            )
          ]
        ),
      )
      
    );
  }

}