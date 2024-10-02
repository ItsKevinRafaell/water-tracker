import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/models/water_intake_model.dart';
import 'package:water_tracker/widgets/greet.dart';
import 'package:water_tracker/widgets/space.dart';
import 'package:water_tracker/widgets/water_intake_history.dart';
import 'package:water_tracker/widgets/water_intake_tracker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<double> loadDailyGoalFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('dailyGoal') ?? 2000; // Default value is 2000ml
  }

  Future<void> saveWaterIntakeHistory(List<WaterIntakeModel> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedHistory =
        history.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('waterIntakeHistory', encodedHistory);
  }

  @override
  Widget build(BuildContext context) {
    List<WaterIntakeModel> dummyData = generateDummyData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Water Tracker",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Greet(),
            const SpaceWidget(),

            // Use FutureBuilder to load the daily goal
            FutureBuilder<double>(
              future: loadDailyGoalFromPrefs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return const Text("Error loading daily goal.");
                } else {
                  double dailyGoal = snapshot.data ?? 2000;
                  return WaterIntakeTracker(
                      dailyGoal: dailyGoal ?? 2000,
                      waterIntakeHistory: dummyData);
                }
              },
            ),

            const SpaceWidget(),
            const SizedBox(height: 20),

            const Text(
              "Riwayat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Use FutureBuilder to load the water intake history
            Expanded(
              child: WaterIntakeHistory(waterIntakeHistory: dummyData),
            ),
          ],
        ),
      ),
    );
  }
}
