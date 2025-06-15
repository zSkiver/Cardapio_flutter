import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../models/item_carrinho.dart';
import '../data/carrinho.dart';
import 'carrinho_screen.dart';

class ProdutoDetalheScreen extends StatefulWidget {
  final Produto produto;

  const ProdutoDetalheScreen({super.key, required this.produto});

  @override
  State<ProdutoDetalheScreen> createState() => _ProdutoDetalheScreenState();
}

class _ProdutoDetalheScreenState extends State<ProdutoDetalheScreen> {
  late List<Adicional> adicionaisDisponiveis;
  final Map<Adicional, int> adicionaisSelecionados = {};
  late double total;

  @override
  void initState() {
    super.initState();
    adicionaisDisponiveis = List<Adicional>.from(widget.produto.adicionais);
    total = widget.produto.preco;
  }

  void _atualizarTotal() {
    final extras = adicionaisSelecionados.entries
        .fold<double>(0.0, (acc, e) => acc + e.key.preco * e.value);

    setState(() => total = widget.produto.preco + extras);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.produto.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.produto.imagem,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.produto.descricao,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            const Text(
              'Adicionais:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...adicionaisDisponiveis.map((adicional) {
              final qtd = adicionaisSelecionados[adicional] ?? 0;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(adicional.nome,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('R\$ ${adicional.preco.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: qtd == 0
                                ? null
                                : () {
                                    setState(() {
                                      adicionaisSelecionados[adicional] = qtd - 1;
                                      if (adicionaisSelecionados[adicional] == 0) {
                                        adicionaisSelecionados.remove(adicional);
                                      }
                                      _atualizarTotal();
                                    });
                                  },
                          ),
                          Text('$qtd', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                adicionaisSelecionados[adicional] = qtd + 1;
                                _atualizarTotal();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final extras = [
                    for (final entry in adicionaisSelecionados.entries)
                      for (int i = 0; i < entry.value; i++) entry.key
                  ];

                  carrinho.add(ItemCarrinho(
                    produto: widget.produto,
                    adicionais: extras,
                  ));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Adicionado ao carrinho!'),
                      action: SnackBarAction(
                        label: 'Ver Carrinho',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Adicionar ao Pedido – R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
