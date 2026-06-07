import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Icon(
            Icons.event,
            color: Colors.white,
            size: size * 0.55,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Eventos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
