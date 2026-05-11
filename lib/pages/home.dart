import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimoire/pages/editor.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grimoire',
      theme: ThemeData(
       
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<void> addNote() async {
  await FirebaseFirestore.instance.collection('notes').add({
    'title': 'Test Note',
    'content': "What's good nerd.",
    'createdAt': Timestamp.now(),
  });
}

Future<void> deleteNote(String id) async {
  await FirebaseFirestore.instance.collection('notes').doc(id).delete();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
        title: Text(widget.title),
      ),
       //sidebar for app
      drawer: Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("Menu")
            ),
            ListTile(
              title: Text("Create New Note"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditorPage())
                );
              },
            )
          ],
        )
      ),
      body: StreamBuilder(
        //pull documents from firestore
        stream: FirebaseFirestore.instance.collection('notes').orderBy('createdAt', descending: true).snapshots(), 
        builder: (context, snapshot) {
          //the funny loading circle
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          //data for our notes
          final notes = snapshot.data!.docs;

          if (notes.isEmpty) {
            return const Center(
              child: Text("No notes yet.")
            );
          }

          return GridView.builder(
            /* 
                The main grid view of documents in the docs, handled by a grid view and stream builder which takes documents
              from firestore and displays them in a grid for easy viewing. will be able to load and delete documents, 
              as well as make new ones
            */
            padding: const EdgeInsets.all(12),
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              ),
            
            itemCount: notes.length,
            itemBuilder: (context, i){
              //data is map <string, dynamic>
              final data = notes[i].data();

              return Card(
                //individual entries appear as cards
                elevation: 3,
                child: Column(
                  crossAxisAlignment: 
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ??  'untitled',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 8),
                      //preview text
                      Expanded(
                        child: Text(
                          data['content'] ?? ' ',
                          overflow: TextOverflow.fade,
                          maxLines:4
                        ),
                      ),
                      //delete button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteNote(notes[i].id);
                        })
                    ]
                )
              );
            },
          );
        }
      ),
      
    );
  }
}
