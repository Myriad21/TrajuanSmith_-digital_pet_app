import 'package:flutter/material.dart';

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

  final TextEditingController _nameController = TextEditingController();


  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) {
        hungerLevel = 0;
      }
      _updateHappiness();
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

  //For controller
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
