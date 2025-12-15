import 'package:flutter/material.dart';
import 'package:one_ds/core/ui/index.dart';
import 'package:parking/src/module/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';

class SelectPix extends StatefulWidget {
  SelectPix({super.key, this.onChanged});
  Function(int? value)? onChanged;

  @override
  State<SelectPix> createState() => _SelectPixState();
}

class _SelectPixState extends State<SelectPix> {
  Widget expanded(Widget child) => Expanded(child: child);

  @override
  Widget build(BuildContext context) {
    double space = 16;
    return Consumer<SettingsController>(
      builder: (context, value, _) {
        void onSelect(type) {
          setState(() {
            value.typePix = type;
          });
          widget.onChanged?.call(type);
        }

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
                    selected: value.typePix,
                    type: OneSelectType.background,
                  ),
                ),
                expanded(
                  OneSelect(
                    value: 2,
                    onChanged: onSelect,
                    selected: value.typePix,
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
                    selected: value.typePix,
                    label: 'CNPJ',
                    type: OneSelectType.background,
                  ),
                ),
                expanded(
                  OneSelect(
                    value: 4,
                    onChanged: onSelect,
                    selected: value.typePix,
                    label: 'Telefone',
                    type: OneSelectType.background,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
