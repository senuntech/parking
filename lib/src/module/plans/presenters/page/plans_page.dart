import 'package:flutter/material.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/purchase/purchase.dart';
import 'package:parking/src/module/plans/presenters/widget/alert_plan.dart';
import 'package:parking/src/module/plans/presenters/widget/card_plan_premium.dart';
import 'package:provider/provider.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late PurchaseApp purchaseApp;
  bool progress = false;

  @override
  void initState() {
    purchaseApp = context.read<PurchaseApp>();
    super.initState();
  }

  void pressedRestore() async {
    setState(() {
      progress = true;
    });
    await purchaseApp.restore();
    setState(() {
      progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OneAppBar(
        title: 'Planos Premium',
        subtitle: 'Escolha seu plano',
        context: context,
      ),
      body: OneBody(
        child: Consumer<PurchaseApp>(
          builder: (context, value, child) {
            if (value.isLoading || progress) {
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .3),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }
            if (value.products.isEmpty) {
              return TextButton.icon(
                label: const Text("Ops! Algo saiu errado, tentar novamente."),
                icon: const Icon(LucideIcons.refreshCcw),
                onPressed: () {
                  value.initialize();
                },
              );
            }
            return Column(
              children: [
                AlertPlan(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.products.length,
                  itemBuilder: (context, index) {
                    final item = value.products.elementAt(index);
                    return PremiumPricingCard(
                      productDetails: item,
                      showBanner: value.isPurchased,
                      onPressed: () async {
                        await value.buy(item);
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),

      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pressedRestore,
        icon: Icon(LucideIcons.refreshCcw),
        label: OneText('Restaurar Plano'),
      ),
    );
  }
}
