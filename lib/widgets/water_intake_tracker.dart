import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/models/water_intake_model.dart';
import 'package:water_tracker/pages/detail_screen.dart';

class WaterIntakeTracker extends StatefulWidget {
  final List<WaterIntakeModel> waterIntakeHistory;
  final double dailyGoal;

  const WaterIntakeTracker({
    super.key,
    required this.waterIntakeHistory,
    required this.dailyGoal,
  });

  @override
  _WaterIntakeTrackerState createState() => _WaterIntakeTrackerState();
}

class _WaterIntakeTrackerState extends State<WaterIntakeTracker>
    with WidgetsBindingObserver {
  late List<WaterIntakeModel> waterIntakeHistory;
  late double dailyGoal;

  @override
  void initState() {
    super.initState();
    waterIntakeHistory = widget.waterIntakeHistory;
    dailyGoal = widget.dailyGoal;
    _checkAndAddNewDayEntry();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkAndAddNewDayEntry() {
    DateTime today = DateTime.now();
    if (waterIntakeHistory.isEmpty ||
        !_isSameDay(waterIntakeHistory.last.date, today)) {
      waterIntakeHistory
          .add(WaterIntakeModel(date: today, dailyGoal: dailyGoal));
      saveWaterIntakeHistory();
    }
    setState(() {});
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Function to show a dialog to edit the daily goal
  Future<void> _showEditGoalDialog(BuildContext context) async {
    TextEditingController goalController =
        TextEditingController(text: dailyGoal.toString());

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Daily Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Enter new daily goal (ml)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? newGoal = double.tryParse(goalController.text);
                if (newGoal != null && newGoal > 0) {
                  setState(() {
                    dailyGoal = newGoal;
                    _updateDailyGoalForToday(newGoal); // Update today's entry
                    _saveDailyGoal(newGoal); // Save the updated goal
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error if the input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter a valid number.")),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to update the daily goal for today's entry in waterIntakeHistory
  void _updateDailyGoalForToday(double newGoal) {
    DateTime today = DateTime.now();
    // Check if the last entry is for today and update its daily goal
    if (_isSameDay(waterIntakeHistory.last.date, today)) {
      waterIntakeHistory.last.dailyGoal = newGoal; // Update today's goal
      saveWaterIntakeHistory(); // Save the updated history to SharedPreferences
    }
  }

  // Function to save the updated daily goal using SharedPreferences
  Future<void> _saveDailyGoal(double goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = await prefs.setDouble('dailyGoal', goal);

    if (isSaved) {
      print('Daily goal berhasil disimpan: $goal');
    } else {
      print('Daily goal gagal disimpan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayIntake = waterIntakeHistory.isNotEmpty
        ? waterIntakeHistory.last
        : WaterIntakeModel(date: DateTime.now(), dailyGoal: dailyGoal);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kebutuhan Air Harian: ${todayIntake.dailyGoal} ml",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    _showEditGoalDialog(context); // Trigger the edit dialog
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Asupan Air Hari Ini: ${todayIntake.consumed} ml",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Sisa Air: ${todayIntake.remaining} ml",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        updateIntake(150); // Add 150 ml water intake
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Tambah Asupan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailScreen(
                              waterIntakeModel: todayIntake); // Show history
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Cek Riwayat",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateIntake(double amount) {
    setState(() {
      waterIntakeHistory.last.consumed += amount;
      waterIntakeHistory.last.intakeHistory.add({
        'amount': amount,
        'time': DateTime.now().toIso8601String(),
      });
      saveWaterIntakeHistory(); // Save updated history
    });
  }

  Future<void> saveWaterIntakeHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedHistory =
        waterIntakeHistory.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(
        'waterIntakeHistory', encodedHistory); // Persist history
    print('Data history berhasil disimpan');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Simpan data saat aplikasi di-pause
      saveWaterIntakeHistory();
    }
  }
}
