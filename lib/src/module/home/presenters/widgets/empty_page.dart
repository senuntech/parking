import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: .center,
      children: [
        SizedBox(height: size.height * 0.2),
        Icon(LucideIcons.search, size: 50, color: Colors.grey),
        OneSize.height16,
        OneText.caption('Nenhum veículo encontrado'),
      ],
    );
  }
}
