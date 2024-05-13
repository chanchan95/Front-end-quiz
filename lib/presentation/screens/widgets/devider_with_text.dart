import 'package:flutter/material.dart';

class DeviderWithText extends StatelessWidget {
  const DeviderWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Divider(
                  color: Colors.black,
                  height: 36,
                ),
              ),
            ),
            const Text('OR'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Divider(
                  color: Colors.black,
                  height: 36,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}