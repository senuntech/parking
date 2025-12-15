import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:one_ds/one_ds.dart';

// --- Widget Principal do Cartão de Preços ---
class PremiumPricingCard extends StatelessWidget {
  const PremiumPricingCard({
    super.key,
    required this.productDetails,
    required this.onPressed,
    this.showBanner = false,
  });
  final ProductDetails productDetails;
  final VoidCallback onPressed;
  final bool showBanner;

  Widget getCard({required Widget child}) {
    if (showBanner) {
      return Banner(
        message: 'Plano Atual',
        location: .topEnd,
        color: Colors.red,
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    // Cor primária do design
    const Color primaryColor = Color(0xFF4CAF50); // Verde vibrante

    return Card(
      margin: .all(30),
      // Estilo geral do cartão
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      child: getCard(
        child: Container(
          // Garantir que o cartão não seja muito largo em telas grandes
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            borderRadius: .circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              // 1. Cabeçalho Verde com Forma Personalizada
              ClipPath(
                clipper: CustomCardClipper(),
                child: Container(
                  height: 200, // Altura do cabeçalho
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: .only(
                      topLeft: .circular(20),
                      topRight: .circular(20),
                    ),
                  ),
                  child: Stack(
                    alignment: .center,
                    children: [
                      // Texto "PREMIUM" no topo
                      const Positioned(
                        top: 30,
                        child: Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      // Contêiner do Preço (com cantos arredondados)
                      Positioned(
                        top: 60,
                        child: Container(
                          alignment: .center,
                          padding: const .symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),

                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                productDetails.price,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: .w800,
                                ),
                              ),
                              Text(
                                'Por Mês',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: .w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Seção de Recursos (Lista de Itens)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildFeatureItem('Sem Anúncios'),
                    _buildFeatureItem('Sem publicidades impressas'),
                    _buildFeatureItem('Relatórios Ilimitados'),
                    _buildFeatureItem('Carros Ilimitados'),
                  ],
                ),
              ),

              OneSize.height32,

              // 3. Botão "Selecionar Plano"
              ElevatedButton(
                onPressed: showBanner ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: .symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                  elevation: 5,
                ),
                child: const Text(
                  'SELECIONAR PLANO',
                  style: TextStyle(fontSize: 16, fontWeight: .bold),
                ),
              ),
              OneSize.height32,
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para construir o item de recurso
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: .symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_sharp,
            color: Color(0xFF4CAF50), // Checkmark verde
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Clipper para a Forma do Cabeçalho ---
class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 1. Ponto de Início (Canto superior esquerdo)
    path.lineTo(0, 0);

    // 2. Linha até o Canto superior direito
    path.lineTo(size.width, 0);

    // 3. Linha até o ponto diagonal inferior direito do corte
    // Este ponto define onde o corte começa na direita
    path.lineTo(size.width, size.height * 0.85);

    // 4. Curva de controle para o corte diagonal
    // A curva diagonal é crucial para o design
    path.quadraticBezierTo(
      size.width * 0.75, // Ponto de controle X (ajusta a profundidade do corte)
      size.height * 0.70, // Ponto de controle Y
      size.width * 0.5, // Ponto de chegada da curva X (meio)
      size.height * 0.75, // Ponto de chegada da curva Y
    );

    // 5. Segunda Curva de controle (cria a forma de onda invertida)
    path.quadraticBezierTo(
      size.width * 0.25, // Ponto de controle X
      size.height * 0.80, // Ponto de controle Y
      0, // Ponto de chegada X (canto inferior esquerdo)
      size.height * 0.65, // Ponto de chegada Y (ajusta a altura na esquerda)
    );

    // 6. Fecha o caminho de volta ao início
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomCardClipper oldClipper) => false;
}
