import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/models/water_intake_model.dart';

class DetailScreen extends StatelessWidget {
  final WaterIntakeModel waterIntakeModel;

  const DetailScreen({super.key, required this.waterIntakeModel});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMMM yyyy').format(waterIntakeModel.date);

    final remaining = waterIntakeModel.dailyGoal - waterIntakeModel.consumed;
    final isGoalMet = waterIntakeModel.consumed >= waterIntakeModel.dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Asupan Air",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kebutuhan Harian: ${waterIntakeModel.dailyGoal} ml",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 5),
                Text(
                  "Asupan Air: ${waterIntakeModel.consumed} ml",
                  style: TextStyle(
                    fontSize: 16,
                    color: isGoalMet ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Sisa: $remaining ml",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Divider(height: 20, thickness: 1),
                if (waterIntakeModel.intakeHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Asupan Air per Jam:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: waterIntakeModel.intakeHistory.map((intake) {
                          final timeString = intake['time'];
                          final amount = intake['amount'];

                          if (timeString == null || amount == null) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Invalid data for this entry",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          }

                          DateTime? timestamp;
                          try {
                            timestamp = DateTime.parse(timeString);
                          } catch (e) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Invalid timestamp format",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          }

                          final formattedTime =
                              DateFormat('HH:mm').format(timestamp);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_drink,
                                  color: Colors.blueAccent.withOpacity(0.7),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "$formattedTime - ${amount} ml",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (waterIntakeModel.intakeHistory.isEmpty)
                  const Text(
                    "No water intake recorded for this day.",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
