import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/organisms/one_list_tile.dart';
import 'package:one_ds/one_ds.dart';

class ItemPrinter extends StatelessWidget {
  const ItemPrinter({
    super.key,
    required this.onTap,
    required this.title,
    required this.subTitle,
  });
  final VoidCallback onTap;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          OneListTile(
            title: title,
            leading: Icon(LucideIcons.printer),
            onTap: onTap,
            padding: .all(16),
            showDivider: false,
            children: [OneText(subTitle)],
          ),
          OneDivider(),
        ],
      ),
    );
  }
}
