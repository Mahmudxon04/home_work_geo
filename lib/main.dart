import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? myPosition;
  Position? myPosition2;
  double _counter = 0;


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My current position is ${myPosition?.longitude},${myPosition?.latitude},',
            ),
            Text(
              'My current position is ${myPosition2?.longitude},${myPosition2?.latitude},',
            ),
            Text("$_counter"),
            ElevatedButton(
              onPressed: () async {
                _counter = await Geolocator.distanceBetween(
                    myPosition!.latitude,
                    myPosition!.longitude,
                    myPosition2!.latitude,
                    myPosition2!.longitude);
                setState(() {});
              },
              child: Text(""),
            ),
            ElevatedButton(
                onPressed: () async {
                  myPosition2 = await _determinePosition();
                  setState(() {});
                },
                child: Icon(Icons.add))
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          myPosition = await _determinePosition();
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}