import 'produto.dart';

class ItemCarrinho {
  final Produto produto;
  final List<Adicional> adicionais;

  ItemCarrinho({
    required this.produto,
    required this.adicionais,
  });

  double get total {
    double adicionaisTotal = adicionais.fold(0, (soma, a) => soma + a.preco);
    return produto.preco + adicionaisTotal;
  }
}
