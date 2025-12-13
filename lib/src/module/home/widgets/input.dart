import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/src/module/ticket/controller/ticket_controller.dart';
import 'package:provider/provider.dart';

class Input extends StatelessWidget {
  const Input({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,

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
      onChanged: (value) {
        context.read<TicketController>().searchTicket(value);
      },
    );
  }
}
