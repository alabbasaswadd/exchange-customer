import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient walletCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF0A2D6E)],
  );

  static const LinearGradient homeHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A192F), Color(0xFF1565C0)],
  );

  static const LinearGradient loginBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A192F), Color(0xFF0D47A1)],
  );
}
