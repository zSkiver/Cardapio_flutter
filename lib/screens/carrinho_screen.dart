import 'package:flutter/material.dart';
import '../data/carrinho.dart';
import '../data/cupons.dart'; 
import '../models/cupom.dart'; 
import '../data/enderecos.dart'; 
import '../models/endereco.dart'; 

String rua = '';
String numero = '';
String bairro = '';
String cidade = '';
String? trocoPara;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _tipoEntrega = 'Entrega';
  String _tempoEntrega = 'Padrão';
  String _formaPagamento = 'PIX';
  String _metodoPagamento = 'Site';

  final double taxaEntregaPadrao = 10.00;
  final double taxaEntregaRapida = 15.00;
  final TextEditingController _cupomController = TextEditingController();

  double descontoCupom = 0.0;
  String cupomAplicado = '';

  final List<Endereco> enderecos = List.from(enderecosMock);
Endereco? enderecoSelecionado;

  @override
void initState() {
  super.initState();
  enderecoSelecionado = enderecos.first;
}

  double get subtotal {
    return carrinho.fold(0.0, (total, item) => total + item.total);
  }

  double get taxaEntrega {
    if (_tipoEntrega == 'Retirada') return 0.0;
    return _tempoEntrega == 'Padrão' ? taxaEntregaPadrao : taxaEntregaRapida;
  }

  double get total {
    final totalBruto = subtotal + taxaEntrega;
    final totalComDesconto = totalBruto - descontoCupom;
    return totalComDesconto < 0 ? 0.0 : totalComDesconto;
  }

  void _trocarEndereco() async {
  Endereco? selecionado = enderecoSelecionado;

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(builder: (context, setModalState) {
        return AlertDialog(
          title: const Text('Selecionar ou Cadastrar Endereço'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...enderecos.map((e) => RadioListTile<Endereco>(
                      title: Text(e.toString()),
                      value: e,
                      groupValue: selecionado,
                      onChanged: (value) {
                        setModalState(() => selecionado = value);
                      },
                    )),
                const Divider(),
                TextField(
                  decoration: const InputDecoration(labelText: 'Rua'),
                  onChanged: (value) => rua = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Número'),
                  onChanged: (value) => numero = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Bairro'),
                  onChanged: (value) => bairro = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Cidade/UF'),
                  onChanged: (value) => cidade = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () {
                  if (rua.isNotEmpty || numero.isNotEmpty || bairro.isNotEmpty || cidade.isNotEmpty) {
                    if (rua.isNotEmpty && numero.isNotEmpty && bairro.isNotEmpty && cidade.isNotEmpty) {
                      final novo = Endereco(
                        rua: rua,
                        numero: numero,
                        bairro: bairro,
                        cidade: cidade,
                      );
                      setState(() {
                        enderecos.add(novo);
                        enderecoSelecionado = novo;

                        rua = '';
                        numero = '';
                        bairro = '';
                        cidade = '';
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preencha todos os campos para adicionar um novo endereço.')),
                      );
                      return; 
                    }
                  } else if (selecionado != null) {
                    setState(() => enderecoSelecionado = selecionado!);
                  }
                  Navigator.pop(context);
                                  },
                                  child: const Text('Salvar'),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: ['Entrega', 'Retirada'].map((tipo) {
              final selected = _tipoEntrega == tipo;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tipoEntrega = tipo),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected ? Colors.red : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tipo,
                      style: TextStyle(
                        color: selected ? Colors.red : Colors.black,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          if (_tipoEntrega == 'Entrega') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    enderecoSelecionado?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(onPressed: _trocarEndereco, child: const Text('Trocar')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Hoje, entrega em:'),
            Row(
              children: [
                _opcaoEntrega('Padrão', '28–38 min', taxaEntregaPadrao),
                const SizedBox(width: 10),
                _opcaoEntrega('Rápida', '22–32 min', taxaEntregaRapida),
              ],
            ),
            const SizedBox(height: 20),
          ],

          Row(
            children: ['Site', 'Entrega'].map((metodo) {
              final selected = _metodoPagamento == metodo;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _metodoPagamento = metodo),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected ? Colors.red : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Pague na $metodo',
                      style: TextStyle(
                        color: selected ? Colors.red : Colors.black,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          if (_metodoPagamento == 'Site') ...[
            ListTile(
              leading: const Icon(Icons.pix, color: Colors.green),
              title: const Text('Pague com Pix'),
              subtitle: const Text('Use o QR Code ou cole o código'),
              onTap: () => setState(() => _formaPagamento = 'PIX'),
              trailing: Radio<String>(
                value: 'PIX',
                groupValue: _formaPagamento,
                onChanged: (value) => setState(() => _formaPagamento = value!),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Adicionar novo cartão'),
              subtitle: const Text('Rápido e seguro'),
              onTap: () => setState(() => _formaPagamento = 'Cartão'),
              trailing: Radio<String>(
                value: 'Cartão',
                groupValue: _formaPagamento,
                onChanged: (value) => setState(() => _formaPagamento = value!),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.orange),
              title: const Text('Pagar com Dinheiro'),
              subtitle: const Text('Informe se precisa de troco'),
              onTap: () => setState(() => _formaPagamento = 'Dinheiro'),
              trailing: Radio<String>(
                value: 'Dinheiro',
                groupValue: _formaPagamento,
                onChanged: (value) => setState(() => _formaPagamento = value!),
              ),
            ),
            if (_formaPagamento == 'Dinheiro') Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Troco para quanto?',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (valor) {
                  print('Troco para: R\$ $valor');
                },
              ),
            ),
          ],

          const SizedBox(height: 16),
          TextField(
            controller: _cupomController,
            decoration: InputDecoration(
              labelText: 'Código de cupom',
              suffixIcon: IconButton(
                icon: const Icon(Icons.local_offer_outlined),
                onPressed: () {
                  final codigo = _cupomController.text.trim().toUpperCase();
                  final cupom = cuponsDisponiveis.firstWhere(
                    (c) => c.codigo == codigo && c.ativo,
                    orElse: () => Cupom(codigo: '', descricao: '', descontoPercentual: 0, ativo: false),
                  );

                  if (cupom.ativo && cupom.codigo.isNotEmpty) {
                    setState(() {
                      descontoCupom = cupom.descontoPercentual;
                      cupomAplicado = cupom.codigo;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cupom "${cupom.codigo}" aplicado com sucesso!')),
                    );
                  } else {
                    setState(() {
                      descontoCupom = 0.0;
                      cupomAplicado = '';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cupom inválido ou expirado.')),
                    );
                  }
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Itens do Pedido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: carrinho.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = carrinho[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: Image.asset(
                  item.produto.imagem,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Text('R\$ ${item.produto.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item.adicionais.isEmpty
                      ? [const Text('Sem adicionais', style: TextStyle(fontSize: 12))]
                      : item.adicionais.map((a) => Text('${a.nome} - R\$ ${a.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12))).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumo do Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _linhaResumo('Subtotal', subtotal),
                  if (descontoCupom > 0) _linhaResumo('Desconto (\$cupomAplicado)', -descontoCupom),
                  if (_tipoEntrega == 'Entrega') _linhaResumo('Taxa de entrega', taxaEntrega),
                  const Divider(),
                  _linhaResumo('Total', total, negrito: true),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _mostrarResumoConfirmacao,

              child: const Text('Confirmar Pedido'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _opcaoEntrega(String tipo, String tempo, double preco) {
    final selected = _tempoEntrega == tipo;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tempoEntrega = tipo),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(tipo, style: TextStyle(color: selected ? Colors.red : Colors.black)),
              Text(tempo, style: const TextStyle(fontSize: 12)),
              Text('R\$ ${preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linhaResumo(String label, double valor, {bool negrito = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            'R\$ ${valor.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: negrito ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  void _mostrarResumoConfirmacao() {
  final produtosResumo = carrinho
      .map((item) => '${item.produto.nome} - R\$ ${item.total.toStringAsFixed(2)}')
      .join('\n');

  final tempo = _tempoEntrega == 'Padrão' ? '28–38 min' : '22–32 min';

  final enderecoTexto = _tipoEntrega == 'Entrega'
      ? (enderecoSelecionado?.toString() ?? 'Não informado')
      : 'Retirada no local';

  final pagamentoTexto = _formaPagamento == 'Dinheiro'
      ? (trocoPara != null && trocoPara!.isNotEmpty
          ? 'Dinheiro (troco para R\$ $trocoPara)'
          : 'Dinheiro (sem troco informado)')
      : _formaPagamento;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmar Pedido'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Text('Resumo do Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(produtosResumo),
              const SizedBox(height: 12),
              Text('Entrega: $_tipoEntrega ($tempo)'),
              Text('Endereço: $enderecoTexto'),
              Text('Pagamento: $pagamentoTexto'),
              Text('Método: $_metodoPagamento'),
              const SizedBox(height: 8),
              Text('Total: R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                carrinho.clear(); 
                _cupomController.clear(); 
                descontoCupom = 0.0;
                cupomAplicado = '';
                trocoPara = null;
                _formaPagamento = 'PIX';
                _metodoPagamento = 'Site';
                _tipoEntrega = 'Entrega';
                _tempoEntrega = 'Padrão';
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido finalizado com sucesso!')),
              );
            },

            child: const Text('Finalizar'),
          ),
        ],
      );
    },
  );
}
}



