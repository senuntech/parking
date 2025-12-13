enum TypePixEnum {
  email(type: 1, errorMessage: '*E-mail Inválido'),
  cpf(type: 2, errorMessage: '*CPF Inválido'),
  cnpj(type: 3, errorMessage: '*CNPJ Inválido'),
  telefone(type: 4, errorMessage: '*Telefone Inválido');

  const TypePixEnum({required this.type, required this.errorMessage});
  final int type;
  final String errorMessage;
}
