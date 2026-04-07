import 'package:flutter_test/flutter_test.dart';
import 'package:one_ds/core/extension/double_extension.dart';
import 'package:parking/core/enum/type_charge_enum.dart';
import 'package:parking/src/module/ticket/data/model/order_ticket_model.dart';
import 'package:parking/src/utils/vehicle_utils.dart';

void main() {
  group('roundUp', () {
    test('VALOR EXATO: 1.13 deve retornar 1.15', () {
      double value = 1.13;
      expect(value.roundUp, 1.15);
    });

    test('ARREDONDAMENTO 0.05: 1.01 deve retornar 1.05', () {
      double value = 1.01;
      expect(value.roundUp, 1.05);
    });

    test('ARREDONDAMENTO 0.05: 1.04 deve retornar 1.05', () {
      double value = 1.04;
      expect(value.roundUp, 1.05);
    });

    test('VALOR EXATO: 1.05 deve retornar 1.05', () {
      double value = 1.05;
      expect(value.roundUp, 1.05);
    });

    test('ARREDONDAMENTO 0.10: 1.06 deve retornar 1.10', () {
      double value = 1.06;
      expect(value.roundUp, 1.10);
    });

    test('ARREDONDAMENTO 0.10: 1.09 deve retornar 1.10', () {
      double value = 1.09;
      expect(value.roundUp, 1.10);
    });

    test('VALOR EXATO: 1.10 deve retornar 1.10', () {
      double value = 1.10;
      expect(value.roundUp, 1.10);
    });

    test(
      'DEVE TRATAR VALORES COM MAIS DE DUAS CASAS: 1.021 -> 1.03 -> 1.05',
      () {
        double value = 1.021;
        expect(value.roundUp, 1.05);
      },
    );
    test('DEVE TRATAR VALORES COM MAIS DE DUAS CASAS: 1000.32 -> 1000.35', () {
      double value = 1000.31;
      expect(value.roundUp, 1000.35);
    });
    test('DEVE TRATAR VALORES COM MAIS DE DUAS CASAS: 10.5 -> 10.5', () {
      double value = 10.5;
      expect(value.roundUp, 10.5);
    });
    test('DEVE TRATAR VALORES COM MAIS DE DUAS CASAS: 1.11 -> 1.15', () {
      double value = 1.11;
      expect(value.roundUp, 1.15);
    });
  });

  group('getTotalPrice', () {
    final now = DateTime(2024, 1, 1, 10, 0); // 10:00

    test('TIPO FIXO: deve retornar o valor exato sem arredondamento', () {
      final model = OrderTicketModel(
        price: 10.0,
        valueType: TypeChargeEnum.fix.type,
      );
      expect(getTotalPrice(model), 10.0);
    });

    test('TIPO DIA: deve retornar preço * dias (1 dia)', () {
      final model = OrderTicketModel(
        price: 50.0,
        valueType: TypeChargeEnum.day.type,
        createdAt: now,
        exitAt: now.add(const Duration(hours: 1)), // Mesma data, < 24h = 1 dia (inDays + 1)
      );
      expect(getTotalPrice(model), 50.0);
    });

    test('TIPO DIA: deve retornar preço * dias (2 dias)', () {
      final model = OrderTicketModel(
        price: 50.0,
        valueType: TypeChargeEnum.day.type,
        createdAt: now,
        exitAt: now.add(const Duration(days: 1)), // 24h = 1 inDay + 1 = 2 dias
      );
      expect(getTotalPrice(model), 100.0);
    });

    test('TIPO HORA (ARREDONDAMENTO): 1.03 deve arredondar para 1.05', () {
      // 61.80 / 60 = 1.03 por minuto
      // 1 minuto = 1.03
      final model = OrderTicketModel(
        price: 61.80,
        valueType: TypeChargeEnum.hour.type,
        createdAt: now,
        exitAt: now.add(const Duration(minutes: 1)),
      );
      expect(getTotalPrice(model), 1.05);
    });

    test('TIPO HORA (ARREDONDAMENTO): 1.06 deve arredondar para 1.10', () {
      // 63.60 / 60 = 1.06 por minuto
      final model = OrderTicketModel(
        price: 63.60,
        valueType: TypeChargeEnum.hour.type,
        createdAt: now,
        exitAt: now.add(const Duration(minutes: 1)),
      );
      expect(getTotalPrice(model), 1.10);
    });

    test('TIPO HORA (ARREDONDAMENTO): 1.05 deve permanecer 1.05', () {
      // 63 / 60 = 1.05
      final model = OrderTicketModel(
        price: 63.0,
        valueType: TypeChargeEnum.hour.type,
        createdAt: now,
        exitAt: now.add(const Duration(minutes: 1)),
      );
      expect(getTotalPrice(model), 1.05);
    });

    test('TIPO HORA: cálculo composto (15/hr, 37 mins = 9.25)', () {
      final model = OrderTicketModel(
        price: 15.0,
        valueType: TypeChargeEnum.hour.type,
        createdAt: now,
        exitAt: now.add(const Duration(minutes: 37)),
      );
      // (15/60) * 37 = 0.25 * 37 = 9.25
      expect(getTotalPrice(model), 9.25);
    });

    test('TIPO HORA: cálculo composto com arredondamento (15/hr, 38 mins = 9.50)', () {
      final model = OrderTicketModel(
        price: 15.0,
        valueType: TypeChargeEnum.hour.type,
        createdAt: now,
        exitAt: now.add(const Duration(minutes: 38)),
      );
      // (15/60) * 38 = 0.25 * 38 = 9.50
      expect(getTotalPrice(model), 9.50);
    });
  });
}
