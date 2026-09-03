<p align="center">
  <img src="assets/icon/icon.png" width="128" alt="Logo Gestor de Estacionamento" />
</p>

# 🚗 Gestor de Estacionamento & Pátio (Parking)

Uma aplicação robusta e elegante desenvolvida em **Flutter** para o gerenciamento completo de estacionamentos, pátios de veículos e fluxo de caixa. O aplicativo conta com recursos premium de persistência local, emissão de recibos via impressoras térmicas Bluetooth e monetização inteligente integrada com anúncios AdMob (totalmente contornável para assinantes).

---

## 🌟 Principais Funcionalidades

### 📋 Controle Operacional de Pátio
* **Entrada Rápida**: Registro simplificado de veículos com dados de responsável (nome, WhatsApp), modelo, placa, tipo de veículo (Moto, Carro, Pesado) e formato de cobrança.
* **Saída Automatizada**: Cálculo inteligente do tempo de permanência e preço a ser cobrado.
* **Tipos de Cobrança Flexíveis**: Configuração de tarifas por preço **Fixo**, por **Hora** ou por **Dia**.
* **Gestão de Categorias**: Configuração de preços específicos de acordo com a categoria do veículo.

### 🖨️ Integração com Impressoras Térmicas (Bluetooth)
* Pareamento nativo e instantâneo com impressoras térmicas de 58mm/80mm.
* Impressão de **Comprovantes de Entrada** (via QR Code/texto).
* Impressão de **Comprovante de Saída / Recibos** com detalhes de pagamento.
* Impressão física de **Relatórios do Fechamento de Caixa**.

### 💰 Gestão Financeira & Caixa (Caixa)
* Monitoramento de receita total acumulada no dia ou período selecionado.
* Detalhamento de faturamento segmentado por método de pagamento: **PIX**, **Dinheiro** e **Cartão**.
* Histórico completo de transações com opção de estorno (devolução) do veículo ao pátio.
* Filtros por períodos customizados via calendário.

### 📢 Monetização Inteligente (AdMob) & Experiência Premium
* **Banners Fixos**: Exibição sutil de banner no rodapé da Home Page.
* **Banners Médios integrados**: Banners no formato `AdSize.mediumRectangle` inseridos nativamente no fluxo dos feeds da Home e da tela de Caixa, maximizando o eCPM.
* **Anúncios Interstitiais**: Exibição de anúncio em tela cheia de forma oportuna no fluxo de adição de veículo (entrada), com transição suave e indicador de carregamento.
* **Bypass Premium**: Se o usuário possuir o status de assinatura premium ativado (`PurchaseApp.isPurchased == true`), **todos os anúncios são 100% ocultados e ignorados**, proporcionando uma experiência limpa e livre de anúncios instantaneamente.

---

## 🏗️ Estrutura do Projeto

O projeto segue uma arquitetura modular, limpa e escalável baseada no padrão de Gerenciamento de Estado com **Provider**:

* `lib/core/`: Componentes globais e transversais do sistema.
  * `ads/`: Centralização da integração do Google Mobile Ads, contendo o `AdManager` (Singleton) e o widget adaptável `AdBannerWidget`.
  * `database/`: Conexão e repositório local SQLite para alta performance e funcionamento offline.
  * `enum/`: Enums de controle de tipos de veículo, cobrança e pagamento.
  * `purchase/`: Lógica de gerenciamento de assinaturas e compras In-App.
* `lib/src/module/`: Módulos de telas estruturados em controladores, modelos de dados e views (telas):
  * `home/`: Tela principal de monitoramento do pátio e busca de veículos.
  * `ticket/`: Fluxo de criação e edição de entradas (tickets).
  * `cash_register/`: Controle financeiro completo e histórico.
  * `printer/`: Configurações de conexão Bluetooth de impressoras.
  * `category/`: Gerenciamento e preços por tipo de veículo.
  * `plans/`: Apresentação e adesão de planos Premium.

---

## 🛠️ Requisitos de Compilação & Execução

Antes de iniciar, certifique-se de possuir o ambiente Flutter configurado na versão estável mais recente.

1. Instale as dependências do projeto:
   ```bash
   flutter pub get
   ```

2. Execute o projeto em modo de desenvolvimento:
   ```bash
   flutter run
   ```

---

## 📦 Comandos para Geração de Versão de Produção (Release)

> [!IMPORTANT]
> Ao gerar as versões de produção para as lojas oficiais, certifique-se de manter os parâmetros recomendados abaixo para garantir a renderização e o funcionamento perfeito dos ícones e fontes customizados.

### Gerar versão Appbundle (Google Play Store)
Use o comando abaixo para gerar o arquivo `.aab` otimizado:
```bash
flutter build appbundle --release --no-tree-shake-icons
```

### Gerar versão APK (Instalação Direta)
Use o comando abaixo para gerar o arquivo `.apk` independente para testes ou distribuição direta:
```bash
flutter build apk --release --no-tree-shake-icons
```

---

## 🔒 Configurações AdMob Nativas

Os identificadores do Google Mobile Ads já estão configurados nos arquivos nativos com os IDs reais do aplicativo:
* **Android**: Configurado em `android/app/src/main/AndroidManifest.xml`
* **iOS**: Configurado em `ios/Runner/Info.plist`
* **AdUnits (Banners/Interstitiais)**: Gerenciados dinamicamente via plataforma correspondente em `lib/core/ads/ad_manager.dart`.