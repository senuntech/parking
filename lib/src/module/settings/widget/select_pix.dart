import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';

class SelectPix extends StatefulWidget {
  const SelectPix({super.key});

  @override
  State<SelectPix> createState() => _SelectPixState();
}

class _SelectPixState extends State<SelectPix> {
  Widget expanded(Widget child) => Expanded(child: child);
  int select = 0;

  void onSelect(value) {
    setState(() {
      select = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double space = 16;
    return Column(
      spacing: space,
      children: [
        Row(
          spacing: space,
          children: [
            expanded(
              OneSelect(
                onChanged: onSelect,
                value: 1,
                label: 'E-mail',
                selected: select,
                type: OneSelectType.background,
              ),
            ),
            expanded(
              OneSelect(
                value: 2,
                onChanged: onSelect,
                selected: select,
                label: 'CPF',
                type: OneSelectType.background,
              ),
            ),
          ],
        ),
        Row(
          spacing: space,
          children: [
            expanded(
              OneSelect(
                value: 3,
                onChanged: onSelect,
                selected: select,
                label: 'CNPJ',
                type: OneSelectType.background,
              ),
            ),
            expanded(
              OneSelect(
                value: 4,
                onChanged: onSelect,
                selected: select,
                label: 'Telefone',
                type: OneSelectType.background,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
