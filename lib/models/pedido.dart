import 'item_carrinho.dart';

class Pedido {
  final int id;
  final DateTime dataHora;
  final List<ItemCarrinho> itens;
  String status; // <- precisa ser mutável

  Pedido({
    required this.id,
    required this.dataHora,
    required this.itens,
    this.status = 'Em preparo',
  });

  double get total {
    return itens.fold(0.0, (soma, item) {
      final adicionaisTotal =
          item.adicionais.fold(0.0, (sub, adicional) => sub + adicional.preco);
      return soma + item.produto.preco + adicionaisTotal;
    });
  }
}
