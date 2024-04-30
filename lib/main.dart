import 'package:flutter/material.dart';

import 'home.dart';
import 'workout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0; // Track selected navigation item

  List<Widget> pages = [
    HomePage(), // Replace with your Home Page content
    WorkoutPage(),
    ProfilePage(), // Replace with your Profile Page content
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: Text('Home').data, // Extract string from Text
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: Text('fitnessLabel').data,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: Text('Profile').data, // Extract string from Text
            ),
          ],
        ),
      ),
    );
  }
}

// Replace these with your Page widgets (HomePage, ProfilePage)

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile picture
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  'https://placeimg.com/640/480/people', // Replace with your image URL
                ),
              ),
            ),
            // User name
            Text(
              'John Doe',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            // User email
            Text('johndoe@example.com'),
            // Divider
            Divider(thickness: 1.0),
            // Profile information sections
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              subtitle: Text('This is a brief description about myself.'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
