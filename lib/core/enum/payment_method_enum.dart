enum PaymentMethodEnum {
  pix(id: 1, name: 'Pix'),
  card(id: 2, name: 'Cartão'),
  cash(id: 3, name: 'Dinheiro');

  const PaymentMethodEnum({required this.id, required this.name});

  final int id;
  final String name;
}
