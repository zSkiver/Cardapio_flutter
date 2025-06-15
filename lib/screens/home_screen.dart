import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import 'produto_detalhe_screen.dart';
import 'carrinho_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? categoriaSelecionada;

  List<String> getCategorias() {
    final categorias = mockProdutos.map((p) => p.categoria).toSet().toList();
    categorias.sort();
    return categorias;
  }

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = categoriaSelecionada == null
        ? mockProdutos
        : mockProdutos.where((p) => p.categoria == categoriaSelecionada).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍔 Cardápio Digital'),
        actions: [
          IconButton(
            tooltip: 'Carrinho',
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CheckoutScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips de categorias
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: categoriaSelecionada == null,
                  onSelected: (_) => setState(() => categoriaSelecionada = null),
                ),
                ...getCategorias().map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: categoriaSelecionada == cat,
                      onSelected: (_) => setState(() => categoriaSelecionada = cat),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Lista de produtos
          Expanded(
            child: ListView.builder(
              itemCount: produtosFiltrados.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProdutoDetalheScreen(produto: produto),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'prod-${produto.id}',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              produto.imagem,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported, size: 48),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produto.nome,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                produto.descricao,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'R\$ ${produto.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
