import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimoire/pages/home.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:grimoire/pages/qr_page.dart';

class EditorPage extends StatefulWidget{
  final String? noteId;
  const EditorPage({super.key, this.noteId});

  @override
  State<EditorPage> createState() => _EditorPageState();
}



class _EditorPageState extends State<EditorPage> {
  @override
  void initState(){
    super.initState();
    loadNote();
  }
  final TextEditingController titleController = TextEditingController();
  final QuillController noteController = QuillController.basic();

  

  Future<void> saveNote(TextEditingController title, QuillController content) async {
  //store data in a map, check if you can update first, then check if you need to save it as a new document
  final data = {
    'title': title.text,
    'content': content.document.toDelta().toJson(),
    'updatedAt': Timestamp.now(),
    'ownerID': FirebaseAuth.instance.currentUser!.uid
  };

  if (widget.noteId != null) {
    //id will be null if it hasn't been saved before
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .update(data);
  }
  else {
    data['createdAt'] = Timestamp.now();
    await FirebaseFirestore.instance.collection('notes').add(data);
  }
}
  
  Future<void> loadNote() async {

    if (widget.noteId == null) {
      //if no id, nothing to load
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).get();
    final data = doc.data();

    final document = Document.fromJson(data?['content']);
    if (data != null) {
      //load data
      titleController.text = data['title'];
      final user = FirebaseAuth.instance.currentUser!.uid;
      final owner = data['ownerID'];

      setState(() {
        noteController.document = document;

        if(user != owner){
          //used for shared docs, should make it so users cannot edit shared documents.
          //(it does not do that)
          noteController.readOnly = true;
        }
      });
    }

    
  }
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
          ListTile(
            title: Text("Share"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrGen(noteId: widget.noteId))
                );
            }
            )
        ],
      )
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
            
            QuillSimpleToolbar(controller: noteController, config: QuillSimpleToolbarConfig(),),
            Expanded(
              //---Note editor proper---
              child: QuillEditor.basic(controller: noteController, config: const QuillEditorConfig()),
            )
          ]
        ),
      )
      
    );

  }
  @override
    void dispose() {
      titleController.dispose();
      noteController.dispose();
      super.dispose();
  }

}