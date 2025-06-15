class Endereco {
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;

  Endereco({
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
  });

  @override
  String toString() {
    return '$rua, Nº $numero, $bairro, $cidade';
  }
}
