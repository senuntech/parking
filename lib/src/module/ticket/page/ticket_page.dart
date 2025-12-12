import 'package:flutter/material.dart';
import 'package:one_ds/core/index.dart';
import 'package:one_ds/one_ds.dart' show LucideIcons, OneText;
import 'package:parking/main.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int valueType = 1;

  void setValue(int? value) {
    setState(() {
      valueType = value ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Entrada',
        context: context,
        subtitle: 'Adicionar veiculo',
      ),
      body: OneBody(
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            OneCard(
              title: 'Condutor',
              children: [
                OneInput(
                  label: 'Responsável',
                  icon: LucideIcons.user,
                  hintText: 'Ex: Paulo',
                ),
                OneInput(
                  label: 'WhatsApp',
                  icon: LucideIcons.phone,
                  hintText: 'Ex: Paulo',
                ),
                OneInput(
                  label: 'Segurança',
                  icon: LucideIcons.shieldCheck,
                  hintText: 'CPF do Responsável',
                ),
              ],
            ),
            OneCard(
              title: 'Tipo De Cobrança',
              children: [
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: OneSelect(
                        onChanged: setValue,
                        value: 1,
                        label: 'Úni.',
                        type: .background,
                        selected: valueType,
                      ),
                    ),
                    Expanded(
                      child: OneSelect(
                        onChanged: setValue,
                        value: 2,
                        label: 'Hora',
                        type: .background,
                        selected: valueType,
                      ),
                    ),
                    Expanded(
                      child: OneSelect(
                        onChanged: setValue,
                        value: 3,
                        label: 'Dia',
                        type: .background,
                        selected: valueType,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            OneCard(
              title: 'Veículo',
              children: [
                OneInput(
                  label: 'Modelo',
                  icon: LucideIcons.carFront,
                  hintText: 'Ex: Gol',
                ),
                OneInput(
                  label: 'Placa',
                  icon: LucideIcons.navigation,
                  hintText: 'Ex: XXXX-XXX',
                ),
              ],
            ),
            OneSize.height128,
          ],
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(LucideIcons.save),
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.receipt);
        },
        label: OneText('Adicionar Veículo'),
      ),
    );
  }
}
