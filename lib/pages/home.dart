import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimoire/pages/editor.dart';
import 'package:flutter_quill/flutter_quill.dart'; //rich text editor base
import 'package:flutter_localizations/flutter_localizations.dart'; //for flutter quill to work
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grimoire/pages/roller.dart';
import 'package:grimoire/pages/scanner.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grimoire',
      localizationsDelegates: const [
        //flutter quill requires localizations, but I'm not bilingual so it's just English
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
       
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Grimoire: Home'),
    );
  }
}

Future<void> deleteNote(String id) async {
  await FirebaseFirestore.instance.collection('notes').doc(id).delete();
}

String _getPlainText (dynamic content) {
  //converts json contents into plaintext for card previews, otherwise they just show ugly formatting code
  try{
    final doc = Document.fromJson(content);
    return doc.toPlainText();
  } catch(_) {
    return ' ';
  }

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
            ),
            ListTile(
              title: Text("Scan Code"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage())
                );
              }),
              ListTile(
              title: Text("Roll Dice"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Roller())
                );
              })
          ],
        )
      ),
      body: StreamBuilder(
        //pull documents from firestore according to user ID
        stream: FirebaseFirestore.instance.collection('notes')
                .where('ownerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(), 
        builder: (context, snapshot) {
          //the funny loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading notes"));
          }

          final notes = snapshot.data?.docs ?? [];

          if (notes.isEmpty) {
            return const Center(
              child: Text("No notes yet. Create one through the sidebar.")
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
                          _getPlainText(data['content']),
                          overflow: TextOverflow.fade,
                          maxLines:4
                        ),
                      ),
                      Row(
                        children: [
                          //delete button
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteNote(notes[i].id);
                            }),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditorPage(noteId: notes[i].id))
                              );
                            }
                          ),
                        ],)
                      
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
