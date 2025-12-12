import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

class Input extends StatelessWidget {
  const Input({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'Buscar...',
        prefixIcon: Icon(LucideIcons.search),
        contentPadding: EdgeInsets.zero,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(LucideIcons.qrCode),
        ),
      ),
      scrollPadding: EdgeInsets.zero,
    );
  }
}
