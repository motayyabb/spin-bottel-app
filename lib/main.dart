import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleGame());
}

class SpinBottleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpinBottleHome(),
    );
  }
}

class SpinBottleHome extends StatefulWidget {
  @override
  _SpinBottleHomeState createState() => _SpinBottleHomeState();
}

class _SpinBottleHomeState extends State<SpinBottleHome>
    with SingleTickerProviderStateMixin {
  final List<Color> playerColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
  ];

  List<String> playerNames = List.generate(6, (index) => "Player ${index + 1}");
  bool spinning = false;
  String selectedPlayer = "";

  AnimationController? _controller;
  double _currentRotation = 0;
  double _targetRotation = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        _currentRotation = _controller!.value * _targetRotation;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void spinBottle() {
    setState(() {
      spinning = true;
      Random random = Random();
      double randomAngle = random.nextDouble() * 2 * pi;
      _targetRotation = _currentRotation + 4 * pi + randomAngle;

      _controller?.reset();
      _controller?.forward().then((value) {
        setState(() {
          spinning = false;
          double stopAngle = _targetRotation % (2 * pi);
          int selectedPlayerIndex = ((stopAngle - pi / 12) / (2 * pi) * 6).floor() % 6;
          selectedPlayer = playerNames[selectedPlayerIndex];
        });
      });
    });
  }

  Widget buildPlayerNames() {
    return ListView.builder(
      itemCount: playerNames.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Player ${index + 1} Name",
              labelStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.deepPurple, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
            ),
            onChanged: (value) {
              playerNames[index] = value.isNotEmpty ? value : "Player ${index + 1}";
            },
          ),
        );
      },
    );
  }

  Widget buildWheel() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(playerNames.length, (index) {
        final angle = (index / playerNames.length) * 2 * pi;
        return Transform.translate(
          offset: Offset(
            120 * cos(angle),
            120 * sin(angle),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: playerColors[index],
            child: Text(
              playerNames[index],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Spin the Bottle Game",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Left side: Player Names
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildPlayerNames(),
                        ),
                      ),
                    ),
                  ),
                  // Right side: Wheel and bottle
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        buildWheel(),
                        Transform.rotate(
                          angle: _currentRotation,
                          child: Image.asset(
                            'images/s.png', // Ensure the image is available at this path
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Bottom: Button and Result Display
            Column(
              children: [
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      selectedPlayer.isNotEmpty
                          ? "$selectedPlayer is selected!"
                          : "No player selected yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.deepPurple,
                    elevation: 10,
                    shadowColor: Colors.deepPurpleAccent,
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: spinning ? null : spinBottle,
                  child: spinning
                      ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    "Spin",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
