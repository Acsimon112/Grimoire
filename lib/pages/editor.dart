import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimoire/pages/home.dart';

class EditorPage extends StatefulWidget{
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editor")),
    body: Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          ElevatedButton(//nav to home
                  style:ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[400],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Home"),
                )
        ]
      ),
    )
    );
  }

}