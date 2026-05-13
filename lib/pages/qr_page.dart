import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:grimoire/pages/home.dart';

class QrGen extends StatefulWidget {
  final String? noteId;
  const QrGen({super.key, this.noteId});
  @override
  State<QrGen> createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share document')
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
        ]
      )
    ),
      body: Column(children: [
        Center(
          //build a QR code based on the 
          child: QrImageView(
            data: widget.noteId ?? ' ',
            size: 250
          )
        )
      ],)
    );
  }
}