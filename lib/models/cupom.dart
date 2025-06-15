class Cupom {
  final String codigo;
  final String descricao;
  final double descontoPercentual;
  final bool ativo;

  Cupom({
    required this.codigo,
    required this.descricao,
    required this.descontoPercentual,
    this.ativo = true,
  });
}
