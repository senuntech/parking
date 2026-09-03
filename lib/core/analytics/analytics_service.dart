import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;
  bool _initialized = false;

  /// Inicializa o Firebase Analytics
  void initialize() {
    try {
      _analytics = FirebaseAnalytics.instance;
      _initialized = true;
      log('📊 [Firebase Analytics] Inicializado com sucesso.');
    } catch (e) {
      log('⚠️ [Firebase Analytics] Falha ao inicializar: $e');
    }
  }

  /// Retorna o observer de rotas para o MaterialApp
  FirebaseAnalyticsObserver? get observer {
    if (!_initialized || _analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: _analytics!);
  }

  /// Método genérico seguro para envio de eventos
  Future<void> _logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      log('📊 [Analytics Event] $name | Params: $parameters');
      if (_initialized && _analytics != null) {
        await _analytics!.logEvent(
          name: name,
          parameters: parameters,
        );
      }
    } catch (e) {
      log('⚠️ [Firebase Analytics] Erro ao registrar evento $name: $e');
    }
  }

  // ===========================================================================
  // 1. Veículos e Pátio (Entrada, Saída, Scanner, Cancelamento)
  // ===========================================================================

  /// Registra entrada de veículo no pátio
  Future<void> logEntradaVeiculo({
    required String tipoVeiculo,
    required String tipoCobranca,
    required bool temPlaca,
    double? valorBase,
  }) async {
    await _logEvent(
      name: 'entrada_veiculo',
      parameters: {
        'tipo_veiculo': tipoVeiculo,
        'tipo_cobranca': tipoCobranca,
        'tem_placa': temPlaca ? 1 : 0,
        if (valorBase != null) 'valor_base': valorBase,
      },
    );
  }

  /// Registra saída de veículo e finalização de ticket
  Future<void> logSaidaVeiculo({
    required String tipoVeiculo,
    required String tipoCobranca,
    required int tempoMinutos,
    required double valorPago,
    required String formaPagamento,
  }) async {
    await _logEvent(
      name: 'saida_veiculo',
      parameters: {
        'tipo_veiculo': tipoVeiculo,
        'tipo_cobranca': tipoCobranca,
        'tempo_minutos': tempoMinutos,
        'valor_pago': valorPago,
        'forma_pagamento': formaPagamento,
      },
    );
  }

  /// Registra uso do scanner para localização de ticket
  Future<void> logLeituraScannerTicket({
    required bool sucesso,
  }) async {
    await _logEvent(
      name: 'leitura_scanner_ticket',
      parameters: {
        'sucesso': sucesso ? 1 : 0,
      },
    );
  }

  /// Registra cancelamento de ticket
  Future<void> logCancelamentoTicket({
    int? idTicket,
    String? motivo,
  }) async {
    await _logEvent(
      name: 'cancelamento_ticket',
      parameters: {
        if (idTicket != null) 'id_ticket': idTicket,
        if (motivo != null) 'motivo': motivo,
      },
    );
  }

  // ===========================================================================
  // 2. Caixa Diário (Abertura, Fechamento, Sangria, Suprimento)
  // ===========================================================================

  /// Registra abertura de caixa
  Future<void> logAberturaCaixa({
    required double valorInicial,
  }) async {
    await _logEvent(
      name: 'abertura_caixa',
      parameters: {
        'valor_inicial': valorInicial,
      },
    );
  }

  /// Registra fechamento de caixa
  Future<void> logFechamentoCaixa({
    required double valorFinal,
    double? totalFaturamento,
    int? totalVeiculos,
  }) async {
    await _logEvent(
      name: 'fechamento_caixa',
      parameters: {
        'valor_final': valorFinal,
        if (totalFaturamento != null) 'total_faturamento': totalFaturamento,
        if (totalVeiculos != null) 'total_veiculos': totalVeiculos,
      },
    );
  }

  /// Registra movimentação de caixa (sangria ou suprimento)
  Future<void> logMovimentacaoCaixa({
    required String tipoMovimentacao, // 'sangria' ou 'suprimento'
    required double valor,
    String? motivo,
  }) async {
    await _logEvent(
      name: 'movimentacao_caixa',
      parameters: {
        'tipo_movimentacao': tipoMovimentacao,
        'valor': valor,
        if (motivo != null && motivo.isNotEmpty) 'motivo': motivo,
      },
    );
  }

  // ===========================================================================
  // 3. Impressão e Dispositivos
  // ===========================================================================

  /// Registra impressão de comprovante
  Future<void> logImpressaoComprovante({
    required String tipoComprovante, // 'entrada', 'saida', 'fechamento_caixa'
    required String tipoImpressora,   // 'bluetooth', 'pdf'
    required bool sucesso,
  }) async {
    await _logEvent(
      name: 'impressao_comprovante',
      parameters: {
        'tipo_comprovante': tipoComprovante,
        'tipo_impressora': tipoImpressora,
        'sucesso': sucesso ? 1 : 0,
      },
    );
  }

  /// Registra conexão com impressora
  Future<void> logConexaoImpressora({
    required String nomeDispositivo,
    required bool sucesso,
  }) async {
    await _logEvent(
      name: 'conexao_impressora',
      parameters: {
        'nome_dispositivo': nomeDispositivo,
        'sucesso': sucesso ? 1 : 0,
      },
    );
  }

  // ===========================================================================
  // 4. Relatórios
  // ===========================================================================

  /// Registra visualização de relatórios
  Future<void> logVisualizarRelatorio({
    required String periodo, // 'hoje', 'mes', 'personalizado'
    String? filtro,
  }) async {
    await _logEvent(
      name: 'visualizar_relatorio',
      parameters: {
        'periodo': periodo,
        if (filtro != null) 'filtro': filtro,
      },
    );
  }

  /// Registra exportação de relatório
  Future<void> logExportarRelatorio({
    required String formato, // 'pdf', 'compartilhar'
  }) async {
    await _logEvent(
      name: 'exportar_relatorio',
      parameters: {
        'formato': formato,
      },
    );
  }

  // ===========================================================================
  // 5. Categorias e Tarifas
  // ===========================================================================

  /// Registra cadastro de nova categoria/tarifa
  Future<void> logCategoriaCadastrada({
    required String tipoVeiculo,
    required String tipoCobranca,
    required double valor,
  }) async {
    await _logEvent(
      name: 'categoria_cadastrada',
      parameters: {
        'tipo_veiculo': tipoVeiculo,
        'tipo_cobranca': tipoCobranca,
        'valor': valor,
      },
    );
  }

  /// Registra atualização de categoria/tarifa
  Future<void> logCategoriaAtualizada({
    required String tipoVeiculo,
    required String tipoCobranca,
    required double valor,
  }) async {
    await _logEvent(
      name: 'categoria_atualizada',
      parameters: {
        'tipo_veiculo': tipoVeiculo,
        'tipo_cobranca': tipoCobranca,
        'valor': valor,
      },
    );
  }

  // ===========================================================================
  // 6. Planos e Compras In-App (IAP)
  // ===========================================================================

  /// Registra visualização da tela de planos/assinatura
  Future<void> logVisualizarPlanos({
    String? origem,
  }) async {
    await _logEvent(
      name: 'visualizar_planos',
      parameters: {
        if (origem != null) 'origem': origem,
      },
    );
  }

  /// Registra início do fluxo de compra
  Future<void> logIniciarCompra({
    required String idProduto,
  }) async {
    await _logEvent(
      name: 'iniciar_compra',
      parameters: {
        'id_produto': idProduto,
      },
    );
  }

  /// Registra compra concluída com sucesso
  Future<void> logCompraConcluida({
    required String idProduto,
    double? valor,
    String? moeda,
  }) async {
    await _logEvent(
      name: 'compra_concluida',
      parameters: {
        'id_produto': idProduto,
        if (valor != null) 'valor': valor,
        if (moeda != null) 'moeda': moeda,
      },
    );
  }

  /// Registra falha na compra
  Future<void> logCompraFalhou({
    required String idProduto,
    String? motivoErro,
  }) async {
    await _logEvent(
      name: 'compra_falhou',
      parameters: {
        'id_produto': idProduto,
        if (motivoErro != null) 'motivo_erro': motivoErro,
      },
    );
  }

  // ===========================================================================
  // 7. Configurações
  // ===========================================================================

  /// Registra alteração de configuração
  Future<void> logConfiguracaoAlterada({
    required String nomeConfiguracao,
    required String novoValor,
  }) async {
    await _logEvent(
      name: 'configuracao_alterada',
      parameters: {
        'nome_configuracao': nomeConfiguracao,
        'novo_valor': novoValor,
      },
    );
  }
}
