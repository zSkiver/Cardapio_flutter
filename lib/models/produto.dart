class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;
  final List<Adicional> adicionais;
  final String categoria; 

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
    required this.adicionais,
    required this.categoria, 
  });
}

class Adicional {
  final int id;
  final String nome;
  final double preco;
  final String icone;

  const Adicional({required this.id, 
  required this.nome, 
  required this.preco,
  required this.icone,
  
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Adicional && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

