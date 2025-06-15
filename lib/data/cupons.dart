import '../models/cupom.dart';

final List<Cupom> cuponsDisponiveis = [
  Cupom(
    codigo: 'CUPOM10',
    descricao: 'Desconto de 10%',
    descontoPercentual: 10.0,
  ),
  Cupom(
    codigo: 'FRETEGRATIS',
    descricao: 'Frete grátis',
    descontoPercentual: 7.99,
  ),
  Cupom(
    codigo: 'VIP15',
    descricao: 'Desconto de 15% para clientes VIP',
    descontoPercentual: 15.0,
  ),
];
