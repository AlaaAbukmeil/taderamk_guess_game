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
class TrademarkCard extends StatefulWidget {
  final Trademark trademark;
  final Function(int, int) onPointsChange;
  final int numberOfTrademarks;
  
  const TrademarkCard({super.key, required this.trademark, required this.onPointsChange, required this.numberOfTrademarks});

  @override
  State<TrademarkCard> createState() => _TrademarkCardState();
  
  
}
class _TrademarkCardState extends State<TrademarkCard> {
  final TextEditingController _controller = TextEditingController();
  String? _feedbackMessage;
  bool? _isCorrect;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _checkAnswer() {
    final userInput = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.trademark.trade_mark_name.toLowerCase();
    
    setState(() {
      if (userInput == correctAnswer) {
        _isCorrect = true;
        _feedbackMessage = "Correct!";
        widget.onPointsChange(10, widget.numberOfTrademarks); 
        _animateCorrectAnswer();
      } else {
        _isCorrect = false;
        _feedbackMessage = "Incorrect! The answer was: ${widget.trademark.trade_mark_name}";
        widget.onPointsChange(-5, widget.numberOfTrademarks); 
        _animateIncorrectAnswer();
      }

    });
    
    _controller.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
                child: AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                    color: _isCorrect == null 
                        ? Colors.grey.shade200 
                        : _isCorrect! 
                            ? Colors.green 
                            : Colors.red,
                    width: _isCorrect == null ? 1 : 2,
                    ),
                    boxShadow: [
                    BoxShadow(
                        color: _glowColor,
                        blurRadius: 12,
                        spreadRadius: 4,
                    ),
                    ],
                ),
                child: Center(
                    child: AnimatedRotation(
                    turns: _rotation,
                    duration: const Duration(milliseconds: 100),
                    child: AnimatedScale(
                        scale: _scale,
                        duration: _animationDuration,
                        child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                            widget.trademark.path,
                            fit: BoxFit.contain,
                        ),
                        ),
                    ),
                    ),
                ),
                ),
            ),
            ),
        
          
          
          
          if (_feedbackMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _feedbackMessage!,
                style: TextStyle(
                  color: _isCorrect == true ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter the trademark name',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _checkAnswer,
                ),
              ),
              onSubmitted: (_) => _checkAnswer(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

double _scale = 1.0;
double _rotation = 0.0;
Color _glowColor = Colors.transparent;
final _animationDuration = const Duration(milliseconds: 500);

void _animateCorrectAnswer() {
  setState(() {
    _scale = 1.2;
    _glowColor = Colors.green.withOpacity(0.5);
  });
  
  Future.delayed(_animationDuration, () {
    if (mounted) {
      setState(() {
        _scale = 1.0;
      });
      
      Future.delayed(_animationDuration, () {
        if (mounted) {
          setState(() {
            _glowColor = Colors.green.withOpacity(0.2);
          });
        }
      });
    }
  });
}

void _animateIncorrectAnswer() {
  setState(() {
    _rotation = 0.05;
    _glowColor = Colors.red.withOpacity(0.5);
  });
  
  Future.delayed(const Duration(milliseconds: 100), () {
    if (mounted) {
      setState(() {
        _rotation = -0.05;
      });
      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _rotation = 0.05;
          });
          
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() {
                _rotation = 0.0;
              });
              
              Future.delayed(_animationDuration, () {
                if (mounted) {
                  setState(() {
                    _glowColor = Colors.red.withOpacity(0.2);
                  });
                }
              });
            }
          });
        }
      });
    }
  });
}

}