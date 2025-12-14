import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/home/widgets/show_scan.dart';
import 'package:parking/src/module/ticket/controller/ticket_controller.dart';
import 'package:provider/provider.dart';

final controller = TextEditingController();

class Input extends StatelessWidget {
  const Input({super.key, this.focusNode});

  final FocusNode? focusNode;

  void onScan(BuildContext context) async {
    final String? result = await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return ShowScan();
      },
    );
    if (result != null) {
      controller.text = result;
      context.read<TicketController>().getTicketByCode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        controller.clear();
        context.read<TicketController>().reset();
      },
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'Buscar...',
        prefixIcon: Icon(LucideIcons.search),
        contentPadding: EdgeInsets.zero,
        suffixIcon: IconButton(
          onPressed: () => onScan(context),
          icon: Icon(LucideIcons.qrCode),
        ),
      ),
      scrollPadding: EdgeInsets.zero,
      onChanged: (value) {
        context.read<TicketController>().searchTicket(value);
      },
    );
  }
}
