import 'package:flutter/material.dart';
import 'dart:math';

class Roller extends StatefulWidget {
  const Roller({super.key});
  @override
  State<Roller> createState() => _RollerState();
}

class _RollerState extends State<Roller> {
  @override
  void initState(){
    super.initState();
  }

    int rolledVal = 0;

    int rollNum(int dice){
      int result;
      var random = Random();

      //generate a random number with minimum value 1 and max value == dice
      result = random.nextInt(dice) + 1;
      return result;
    }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Dice Roller")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "$rolledVal",
            style: TextStyle(
              fontSize: 250
            )
            ),
          Row(
            // d4, d6, d8
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(
                // roll 1d4
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(4);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.purple[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d4"),
              ),
              ElevatedButton(
                // roll 1d6
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(6);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.indigo[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d6"),
              ),
              ElevatedButton(
                // roll 1d8
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(8);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d8"),
              )
            ]
          ),
          Row(// d10, d12, d20
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(// roll 1d10
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(10);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.green[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d10"),
              ),
              ElevatedButton( // roll 1d12
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(12);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.yellow[800],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d12"),
              ),
              ElevatedButton(// roll 1d20
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(20);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.orange[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d20"),
              ),
              
            ]
          ),
          Row(// d10, d12, d20
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              ElevatedButton(// roll 1d100
                onPressed: () {
                  setState(() {
                      rolledVal = rollNum(100);
                    }
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
                ),
                child: Text("d100"),
              ),
            ])
        ]
      )
    );
  }
}