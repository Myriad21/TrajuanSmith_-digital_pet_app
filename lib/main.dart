import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  bool _gameOver = false;
  DateTime? _winStartTime;
  int energyLevel = 100;

  final TextEditingController _nameController = TextEditingController();

  Timer? _hungerTimer;

  // Every 30 second increase hunger and decreases happiness
  @override
  void initState() {
    super.initState();

    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateHunger(); 
    });
  }

  //For controller
  @override
  void dispose() {
    _nameController.dispose();
    _hungerTimer?.cancel();
    super.dispose();
  }


  void _playWithPet() {
    setState(() {
      if (energyLevel>=15) {
        happinessLevel += 10;
        _updateHunger();
        _checkGameState();
        _updateEnergy(energy: -5);
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Not enough Enegry"),
            content: Text("Feed your dog to restore energy"),
          ),
        );
      }
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) {
        hungerLevel = 0;
      }
      _updateHappiness();
      _checkGameState();
      _updateEnergy(energy: 5);
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
      if (happinessLevel < 0){
        happinessLevel = 0;
      }
    } else {
      happinessLevel += 10;
    }
    _checkGameState();
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
      if (happinessLevel < 0){
        happinessLevel = 0;
      }
      _checkGameState();
    });
  }

  void _updateEnergy({required int energy}) {
    setState(() {
      energyLevel += energy;
      if (energyLevel > 100) energyLevel = 100;
      if (energyLevel < 0) energyLevel = 0;
    });
  }


  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return const Color.fromARGB(255, 96, 255, 101);
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _moodLabel(int happinessLevel) {
    if (happinessLevel >= 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  void _checkGameState() {
    if (_gameOver) return;

    // LOSS condition
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _endGame("Game Over", "Your pet is too hungry and unhappy 😭");
      return;
    }

    // WIN condition: happiness > 80 for 3 minutes
    // reset streak if drops to 80 or below
    if (happinessLevel > 80) {
      _winStartTime ??= DateTime.now();
      final elapsed = DateTime.now().difference(_winStartTime!);
      if (elapsed >= const Duration(minutes: 3)) {
        _endGame("You Win!", "Your pet stayed very happy for 3 minutes 🎉");
      }
    } else {
      _winStartTime = null;
    }
  }

  void _endGame(String title, String message) {
    _gameOver = true;
    _hungerTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            // Text Mood indicator
            Text(
              'Mood: ${_moodLabel(happinessLevel)}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Image and Mood color
            SizedBox(height: 20),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/pet_image.png',
                height: 150,
              ),
            ),


            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),

            // Name input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter pet name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_nameController.text.trim().isNotEmpty) {
                    petName = _nameController.text.trim();
                  }
                });
              },
              child: Text('Set Name'),
            ),

            SizedBox(height: 20),

            
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            
            // Hunger level
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),

            // Energy Bar
            SizedBox(height: 16.0),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LinearProgressIndicator(
                value: energyLevel / 100,
                minHeight: 10,
              ),
            ),
            SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _gameOver ? null : _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _gameOver ? null : _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
