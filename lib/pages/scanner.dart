import 'package:flutter/material.dart';
import 'package:grimoire/pages/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:grimoire/pages/editor.dart';


class ScanPage extends StatefulWidget {
  final String? noteId;
  const ScanPage({super.key, this.noteId});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  void initState(){
    super.initState();
  }

  bool handled = false;
  final MobileScannerController controller = MobileScannerController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan document')
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
      body: MobileScanner(
            controller: controller,
        //now only runs once and not 800 times
            onDetect:(result) async {
                if (handled == true) {
                  return;
                }
                final id = result.barcodes.first.rawValue;
                if ( id == null) {
                  return;
                }

                handled = true;
                final navigator = Navigator.of(context);
                await controller.stop();
                if (mounted == false) {
                  return;
                }
                await navigator.push(
                  MaterialPageRoute(builder: (context) => EditorPage(noteId: id))
                );

                handled = false;
                await controller.start();
            },
          )
        );
  }
}