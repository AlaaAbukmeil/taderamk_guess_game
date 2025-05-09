import 'package:flutter/material.dart';
import '../utils/trademark.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tadreamk',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: 'Tadreamk Guess Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Trademark>> _trademarksFuture;
  int _points = 0;
  final random = Random();
  int _randomIndex = 0;

  @override
    void initState(){
      super.initState();
      _trademarksFuture = loadTrademarks();
  }

  void _calculatePoints(int amount, int arrayLength){
    _getRandomIndex(arrayLength);
    setState((){
      _points += amount;
    });
  }
   void _getRandomIndex(int arrayLength){
    int nextRandom = random.nextInt(arrayLength);
    while(nextRandom == _randomIndex){
      nextRandom = random.nextInt(arrayLength);
    }
    setState((){
      _randomIndex = nextRandom;
    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
           
          ),
        ]
      ),

      body: FutureBuilder<List<Trademark>>(
        future:_trademarksFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trademarks found'));
          } else {
            final trademarks = snapshot.data!;
            final randomTrademark = trademarks[_randomIndex];
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Current Score: $_points',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    height: 350,
                    child: TrademarkCard(trademark: randomTrademark, onPointsChange: _calculatePoints, numberOfTrademarks:trademarks.length ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        _getRandomIndex(trademarks.length);
                        // setState(() {});
                      },
                      child: const Text('Next Trademark'),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
        
      
  }
}
