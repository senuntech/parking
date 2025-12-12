import 'package:flutter/material.dart';
import 'package:one_ds/core/components/index.dart';
import 'package:parking/main.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  void init() async {
    await context.read<SettingsController>().get();
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: OneDotsLoader()));
  }
}
