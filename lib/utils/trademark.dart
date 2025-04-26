import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Trademark {
  final String trade_mark_name;
  final String path;

  Trademark({
    required this.trade_mark_name,
    required this.path
  });

  factory Trademark.fromJson(Map<String, dynamic> json) {
    return Trademark(
      trade_mark_name: json['trade_mark_name'],
      path: json['path'],
    );
  }
}

Future<List<Trademark>> loadTrademarks() async {
  final jsonString = await rootBundle.loadString('info.json');
  
  final List<dynamic> jsonData = json.decode(jsonString);
  
  return jsonData.map((item) => Trademark.fromJson(item)).toList();
}
class TrademarkCard extends StatelessWidget {
  final Trademark trademark;
  
  const TrademarkCard({super.key, required this.trademark});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 120,  
                height: 120,
                child: Image.asset(
                  trademark.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              trademark.trade_mark_name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
