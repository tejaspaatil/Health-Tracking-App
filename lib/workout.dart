import 'package:flutter/material.dart';
import 'dart:async';

class Exercise {
  final String name;
  int duration; // Make duration mutable
  final String category;
  final int initialDuration;

  Exercise({required this.name, required int duration, required this.category})
      : this.duration = duration,
        this.initialDuration = duration; // Store initial duration

  void decreaseDuration() {
    if (this.duration > 0) {
      this.duration--;
    }
  }
}

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<String> workoutCategories = [
    'Cardio',
    'Strength',
    'Yoga',
    'Flexibility'
  ];
  String selectedCategory = 'Cardio';
  List<Exercise> allExercises = [
    Exercise(name: 'Running', duration: 300, category: 'Cardio'),
    Exercise(name: 'Pushups', duration: 20, category: 'Strength'),
    Exercise(name: 'Squats', duration: 15, category: 'Strength'),
    Exercise(name: 'Lunges', duration: 10, category: 'Strength'),
    Exercise(name: 'Yoga poses', duration: 15, category: 'Yoga'),
    Exercise(name: 'Stretching', duration: 10, category: 'Flexibility'),
  ];
  List<Exercise> filteredExercises = [];
  int currentExerciseIndex = 0;
  bool isWorkoutStarted = false;
  Duration restDuration =
      Duration(seconds: 30); // Set your desired rest duration
  Timer? timer;

  @override
  void initState() {
    super.initState();
    filteredExercises = allExercises
        .where((exercise) => exercise.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: Column(
        children: [
          // Workout category selection
          DropdownButton<String>(
            value: selectedCategory,
            items: workoutCategories
                .map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
                filteredExercises = allExercises
                    .where((exercise) => exercise.category == selectedCategory)
                    .toList();
              });
            },
          ),
          // Exercise list with cards and timers
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Card(
                  child: ListTile(
                    title: Text(exercise.name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${exercise.duration} seconds'),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Change Duration'),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (int.tryParse(value) != null) {
                                      exercise.duration = int.parse(value);
                                    }
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isWorkoutStarted
                            ? IconButton(
                                onPressed: () {
                                  if (timer != null) {
                                    timer!.cancel();
                                  }
                                  setState(() {
                                    isWorkoutStarted = false;
                                  });
                                },
                                icon: Icon(Icons.stop))
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isWorkoutStarted = true;
                                  });
                                  timer = Timer.periodic(Duration(seconds: 1),
                                      (timer) {
                                    if (exercise.duration < 1) {
                                      timer.cancel();
                                      setState(() {
                                        isWorkoutStarted = false;
                                      });
                                    } else {
                                      exercise.duration--;
                                      setState(
                                          () {}); // Update UI with remaining duration
                                    }
                                  });
                                },
                                child: Text('Start'),
                              ),
                        SizedBox(width: 5),
                        isWorkoutStarted
                            ? ElevatedButton(
                                onPressed: () {
                                  if (timer != null) {
                                    timer!.cancel();
                                  }
                                  setState(() {
                                    isWorkoutStarted = false;
                                    exercise.duration = exercise
                                        .initialDuration; // Reset duration
                                  });
                                },
                                child: Text('Reset'),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
