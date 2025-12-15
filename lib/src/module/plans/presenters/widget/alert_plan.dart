import 'package:flutter/material.dart';

class AlertPlan extends StatelessWidget {
  AlertPlan({super.key});
  String msg =
      "Plano Premium: recursos ilimitados, cancele a qualquer momento! 🚀";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent),
        color: Colors.orangeAccent.withAlpha(20),
      ),
      child: Text(
        msg,
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }
}
