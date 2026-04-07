import 'package:flutter_test/flutter_test.dart';
import 'package:one_ds/core/extension/double_extension.dart';

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
}
