import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/models/water_intake_model.dart';
import 'package:water_tracker/pages/detail_screen.dart';

class WaterIntakeHistory extends StatelessWidget {
  final List<WaterIntakeModel> waterIntakeHistory;

  const WaterIntakeHistory({super.key, required this.waterIntakeHistory});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: waterIntakeHistory.length - 1, // Remove the newest entry
        itemBuilder: (context, index) {
          final intake = waterIntakeHistory[index];
          return _buildHistoryCard(context, intake);
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, WaterIntakeModel intake) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(intake.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(
                    Icons.checklist_rounded,
                    size: 70,
                    color: intake.isGoalMet
                        ? Colors.green.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Goal: ${intake.dailyGoal} ml",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Consumed: ${intake.consumed} ml",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Remaining: ${intake.remaining} ml",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Pass the specific intake to DetailScreen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailScreen(waterIntakeModel: intake);
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Selengkapnya',
                      style: TextStyle(color: Colors.white),
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
}
