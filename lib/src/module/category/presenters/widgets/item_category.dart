import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';

class ItemCategory extends StatelessWidget {
  const ItemCategory({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OneListTile(
      title: label,
      leading: Icon(icon),
      padding: .symmetric(horizontal: 8),

      actions: [
        OneMiniButton(
          onPressed: onTap,
          icon: LucideIcons.pen,
          color: OneColors.success,
        ),
      ],
      children: [OneText.caption('Valores para $label')],
    );
  }
}
