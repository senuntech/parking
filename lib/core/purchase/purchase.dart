import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

/// Delegate necessário apenas no iOS.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) => true;

  @override
  bool shouldShowPriceConsent() => false;
}

class PurchaseApp with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  // --- Estados ---
  bool _isAvailable = false;
  bool _isLoading = true;
  bool _isPurchased = false;

  List<ProductDetails> _products = [];
  PurchaseDetails? _activePurchase;

  // --- Constantes ---
  static const String productId = 'driver_control';

  // --- Getters Públicos ---
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  bool get isPurchased => _isPurchased;
  List<ProductDetails> get products => _products;
  PurchaseDetails? get activePurchase => _activePurchase;

  ProductDetails? get product =>
      _products.firstWhereOrNull((p) => p.id == productId);

  // ---------------------------------------------------------------------------
  // Inicialização
  // ---------------------------------------------------------------------------
  Future<void> initialize() async {
    _setLoading(true);

    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      log('⚠ In-App Purchase indisponível.');
      _setLoading(false);
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (e) => log('Erro no stream de compra: $e'),
    );

    if (Platform.isIOS) {
      final iOS = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iOS.setDelegate(ExamplePaymentQueueDelegate());
    }

    await _iap.restorePurchases();
    await _loadProducts();

    _setLoading(false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Carregamento de Produtos
  // ---------------------------------------------------------------------------
  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails({productId});

    if (response.error != null) {
      log('Erro ao carregar produtos: ${response.error!.message}');
      _products = [];
      return;
    }

    _products = response.productDetails;
    if (_products.isEmpty) log('Nenhum produto encontrado na loja.');
  }

  // ---------------------------------------------------------------------------
  // Compra
  // ---------------------------------------------------------------------------
  Future<bool> buy(ProductDetails prod) async {
    if (prod.id != productId) {
      log('Tentativa de comprar produto inválido: ${prod.id}');
      return false;
    }

    try {
      final purchaseParam = PurchaseParam(productDetails: prod);
      final started = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      if (!started) {
        log('⚠ Compra não iniciada.');
      }

      return started;
    } catch (e) {
      log('Erro ao iniciar compra: $e');

      return false;
    }
  }

  Future<void> restore() async {
    _setLoading(true);
    await _iap.restorePurchases();
    _setLoading(false);
  }

  // ---------------------------------------------------------------------------
  // Listener de Compra
  // ---------------------------------------------------------------------------
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != productId) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          log('⏳ Compra pendente');
          break;

        case PurchaseStatus.error:
          log('❌ Erro na compra: ${purchase.error?.message}');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _processSuccessfulPurchase(purchase);
          break;

        case PurchaseStatus.canceled:
          log('Compra cancelada pelo usuário.');
          break;
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }

    _setLoading(false);
  }

  void _processSuccessfulPurchase(PurchaseDetails purchase) {
    _isPurchased = true;
    _activePurchase = purchase;

    log('✅ Compra ativa: ${purchase.productID}');
  }

  // ---------------------------------------------------------------------------
  // Utils
  // ---------------------------------------------------------------------------
  PurchaseDetails? getPurchase(String id) =>
      _activePurchase?.productID == id ? _activePurchase : null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Extensão para "firstWhereOrNull"
// ---------------------------------------------------------------------------
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
