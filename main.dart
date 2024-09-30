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
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
  ];

  List<String> playerNames = List.generate(10, (index) => "Player ${index + 1}");
  bool spinning = false;
  String selectedPlayer = "";
  bool showNameInput = true;
  String selectedBottleImage = 'images/s.png'; // Default bottle image

  AnimationController? _controller;
  double _currentRotation = 0;
  double _targetRotation = 0;

  // Predefined challenges
  List<String> challenges = [
    "Do 10 pushups",
    "Sing a song",
    "Tell a joke",
    "Dance for 30 seconds",
    "Imitate an animal",
    "Share a secret",
    "Do your best impression of a celebrity",
    "Act like a robot for 1 minute",
    "Do a silly walk",
    "Say the alphabet backwards"
  ];

  String selectedChallenge = "";

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

  // Prevent back navigation while spinning
  Future<bool> _onWillPop() async {
    if (spinning) {
      return false; // Prevent back navigation if spinning
    } else {
      return true; // Allow back navigation if not spinning
    }
  }

  void spinBottle() {
    setState(() {
      spinning = true;

      // The angle each player occupies on the circle
      double playerAngle = (2 * pi) / playerNames.length;

      // Randomly select the player index and calculate stop angle
      Random random = Random();
      int selectedPlayerIndex = random.nextInt(playerNames.length);
      double stopAngle = selectedPlayerIndex * playerAngle;

      // Calculate the rotation target, including multiple spins for smoothness
      _targetRotation = _currentRotation + 4 * pi + stopAngle - _currentRotation % (2 * pi);

      _controller?.reset();
      _controller?.forward().then((value) {
        setState(() {
          spinning = false;
          // Now set the selected player once the spinning is done
          selectedPlayer = playerNames[selectedPlayerIndex];
          selectedChallenge = challenges[random.nextInt(challenges.length)];
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              labelText: "Player ${index + 1} Name",
              labelStyle: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 3),
              ),
            ),
            onChanged: (value) {
              playerNames[index] =
              value.isNotEmpty ? value : "Player ${index + 1}";
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
            backgroundColor: playerColors[index % playerColors.length],
            child: Text(
              playerNames[index],
              style: const TextStyle(
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

  void selectBottle() async {
    String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Bottle"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Image.asset('images/s.png', width: 50, height: 50),
                  title: Text("Wine Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('images/s.png');
                  },
                ),
                ListTile(
                  leading: Image.asset('images/a.png', width: 50, height: 50),
                  title: Text("Green Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('images/a.png');
                  },
                ),
                ListTile(
                  leading: Image.asset('images/b.png', width: 50, height: 50),
                  title: Text("Black Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('images/b.png');
                  },
                ),
                ListTile(
                  leading: Image.asset('images/c.png', width: 50, height: 50),
                  title: Text("Milk Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('images/c.png');
                  },
                ),
                ListTile(
                  leading: Image.asset('images/d.png', width: 50, height: 50),
                  title: Text("Juice Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('images/d.png');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedBottleImage = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: Text(
            "Spin the Bottle Game",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: showNameInput
                    ? buildPlayerNamePage()
                    : buildSpinBottlePage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlayerNamePage() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildPlayerNames(),
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.deepPurple,
            elevation: 10,
            shadowColor: Colors.deepPurpleAccent,
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              showNameInput = false;
            });
          },
          child: Text(
            "Start the Game",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSpinBottlePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Align to center vertically
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: selectBottle,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.deepPurpleAccent,
            ),
            child: Text(
              "Select Bottle",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _currentRotation,
                  child: Image.asset(
                    selectedBottleImage,
                    width: 150,
                    height: 150,
                  ),
                ),
                buildWheel(), // Displays the players around the spinning bottle
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        if (selectedPlayer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Selected Player: $selectedPlayer",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        if (selectedChallenge.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Challenge: $selectedChallenge",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.deepPurple,
            elevation: 10,
            shadowColor: Colors.deepPurpleAccent,
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          onPressed: spinning ? null : spinBottle,
          child: Text(
            spinning ? "Spinning..." : "Spin the Bottle",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
