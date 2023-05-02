import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startScanner, {super.key});

  final void Function() startScanner;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [Colors.indigo, Colors.deepPurple],
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/speedometer-clipart-design-illustration-free-png.webp',
                width: 200,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'OdoScan',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 237, 223, 252)),
            ),
            const SizedBox(height: 80),
            OutlinedButton.icon(
              onPressed: startScanner,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_forward_ios),
              label: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
