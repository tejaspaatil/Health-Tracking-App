import 'package:flutter/material.dart';
import 'dart:math'; // Import math library for pow function

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _weight = 0.0; // User weight in kilograms
  double _height = 0.0; // User height in centimeters
  double _bmi = 0.0; // Calculated BMI
  int _caloriesConsumed = 0; // Consumed calories
  int _targetCalories = 2000; // Target daily calories
  int _waterIntake = 0; // Water intake in milliliters
  int _waterGoal = 2000; // Target daily water intake (replace with user input)

  // Function to calculate BMI
  double calculateBmi(double weight, double height) {
    if (height > 0) {
      return weight / pow(height / 100, 2.0);
    } else {
      return 0.0; // Handle cases with zero height (optional)
    }
  }

  void _calculateBmi() {
    setState(() {
      _bmi = calculateBmi(_weight, _height);
    });
  }

  void _updateWaterIntake(int amount) {
    setState(() {
      _waterIntake = (_waterIntake + amount)
          .clamp(0, _waterGoal); // Clamp to prevent exceeding goal
    });
  }

  void _updateCaloriesConsumed(int calories) {
    setState(() {
      _caloriesConsumed = (_caloriesConsumed + calories)
          .clamp(0, _targetCalories); // Clamp to prevent exceeding goal
    });
  }

  void _setTargetCalories(int calories) {
    setState(() {
      _targetCalories = calories;
    });
  }

  void _setWaterGoal(int goal) {
    setState(() {
      _waterGoal = goal;
    });
  }

  String determineBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal weight';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getBmiColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.orange; // Underweight
    } else if (bmi < 25) {
      return Colors.green; // Normal weight
    } else if (bmi < 30) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obese
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Tracker',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Theme.of(context).primaryColor, // Use primary color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // BMI Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'BMI (Body Mass Index)',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                            icon: Icon(Icons
                                .info_outline), // Info icon for BMI tooltip
                            onPressed: () {
                              // Add functionality for BMI tooltip (optional)
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('What is BMI?'),
                                  content: Text(
                                    'Body Mass Index (BMI) is a measure of body fat based on height and weight. It is a general indicator of weight-for-height and does not directly measure body fat. However, BMI can be used to screen for weight categories that may lead to health problems.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Weight (kg)',
                                prefixIcon:
                                    Icon(Icons.person_outline), // Weight icon
                              ),
                              onChanged: (weight) {
                                _weight = double.parse(weight);
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Height (cm)',
                                prefixIcon: Icon(Icons.height), // Height icon
                              ),
                              onChanged: (height) {
                                _height = double.parse(height);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: _calculateBmi,
                            icon: Icon(
                                Icons.calculate_outlined), // Calculate icon
                            label: Text('Calculate BMI'),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context)
                                  .primaryColor, // Use primary color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Your BMI: ${_bmi.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      // Display BMI Category with Color Coding
                      Text(
                        _bmi > 0 ? determineBmiCategory(_bmi) : '',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: getBmiColor(_bmi),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Calorie Intake Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Calorie Intake',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Target: $_targetCalories kcal',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Add Calories',
                                prefixIcon: Icon(
                                    Icons.add_box_outlined), // Add calorie icon
                              ),
                              onSubmitted: (calories) {
                                _updateCaloriesConsumed(int.parse(calories));
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Consumed: $_caloriesConsumed kcal',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // **Progress Bar for Calorie Intake**
                      LinearProgressIndicator(
                        value: _caloriesConsumed / _targetCalories,
                        backgroundColor: Colors.grey[200], // Background color
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context)
                              .colorScheme
                              .secondary, // Use accent color for progress bar
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              // Functionality to set target calories
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Set Target Calories'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Enter target calories',
                                    ),
                                    onSubmitted: (calories) {
                                      _setTargetCalories(int.parse(calories));
                                      Navigator.pop(
                                          context); // Close dialog after setting target
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.settings), // Settings icon
                            label: Text('Set Target'),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Water Intake Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Water Intake',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Goal: $_waterGoal ml',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Add Water (ml)',
                                prefixIcon: Icon(Icons
                                    .water_drop_outlined), // Water drop icon
                              ),
                              onSubmitted: (water) {
                                _updateWaterIntake(int.parse(water));
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Drank: $_waterIntake ml',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // **Progress Bar for Water Intake**
                      LinearProgressIndicator(
                        value: _waterIntake / _waterGoal,
                        backgroundColor: Colors.grey[200], // Background color
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context)
                              .colorScheme
                              .secondary, // Use accent color for progress bar
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              // Functionality to set water goal
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Set Water Goal'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Enter daily water goal (ml)',
                                    ),
                                    onSubmitted: (goal) {
                                      _setWaterGoal(int.parse(goal));
                                      Navigator.pop(
                                          context); // Close dialog after setting goal
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.settings), // Settings icon
                            label: Text('Set Goal'),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
