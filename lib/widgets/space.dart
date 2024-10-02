import 'package:flutter/material.dart';

class SpaceWidget extends StatelessWidget {
  const SpaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          SizedBox(height: 10),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
