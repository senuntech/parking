# Regras e Contexto do Projeto (Parking)

Este arquivo define as regras de desenvolvimento, arquitetura e negócio para o aplicativo **Parking**. Sempre aplique estas diretrizes ao atuar neste repositório.

## 1. Visão Geral do Projeto
O aplicativo **Parking** é um sistema em Flutter para gerenciamento de estacionamentos, que lida com fluxo de veículos (entrada e saída), controle financeiro (caixa diário), cálculo dinâmico de preços e integração com impressoras térmicas via Bluetooth.

## 2. Stack Tecnológica Base
- **UI/Framework**: Flutter.
- **State Management**: `provider`.
- **Persistência**: `sqlbrite` (reativo, sobre SQLite) e `localstorage`.
- **Integração de UI**: Pacote local/irmão `one_ds` (Design System com extensões e widgets padronizados).
- **Impressão**: `print_bluetooth_thermal`, `esc_pos_utils_plus`.
- **Análise/Gráficos**: `community_charts_flutter`.

## 3. Arquitetura e Diretórios
A arquitetura é guiada por features (modular). A estruturação esperada para o código é:
- **`lib/core/`**: Código e infraestrutura globais.
  - `database/`: Conexão, criação de tabelas e queries do SQLite (`sqlbrite`).
  - `enum/`: Enums de aplicação (e.g. `TypeChargeEnum`, `VehicleEnum`).
  - `extension/`: Extensões utilitárias essenciais.
  -Outros domínios transversais: compras (`purchase`), anúncios (`ads`).
- **`lib/src/module/`**: Módulos divididos por contexto (ex: `cash_register`, `category`, `ticket`, `reports`, `settings`, etc). Estrutura interna comum:
  - `data/model/`: Classes POJO para o banco/JSON.
  - `presenters/page/`: Páginas Flutter.
  - `presenters/controller/`: Classes ChangeNotifier/Provider para regras de negócio e controle da view.
  - `presenters/widgets/`: Componentes visuais exclusivos do módulo.
- **`lib/src/utils/` / `lib/src/widgets/`**: Utilitários e widgets de uso geral na aplicação (não presos a uma feature).

## 4. Regras de Negócio e Convenções
1. **Modelagem Reativa**: Como o banco usa `sqlbrite`, as páginas devem assinar *streams* de dados dos controllers sempre que possível. Apenas o banco de dados é a "fonte da verdade".
2. **Cálculos e Arredondamento (Moeda)**: Todo valor final em dinheiro deve ser arredondado para o múltiplo de `0.05` superior, visando facilitar transações em espécie (ex: lógica `(this * 20).ceil() / 20`). Sempre reaja com esta regra usando as extensões apropriadas presentes no `one_ds`.
3. **Preços Dinâmicos**: A precificação pode ser do tipo Fixa, por Dia (24h) ou por Hora, com o fracionamento minuto a minuto em alguns casos. Mantenha as lógicas coesas nesses três domínios (`TypeChargeEnum`).
4. **Design System**: Não crie cores ou fontes *hardcoded* (`Colors.red`, etc.) indiscriminadamente. Use sempre que possível as abstrações ou extensões provenientes de `one_ds`.

## 5. Guias de Modificação
- **Adição de Tabelas**: Adicionar em `lib/core/database/` e prover as queries num controller de dados padronizado.
- **Nova Feature**: Criar pasta no `lib/src/module/`, seguir a subdivisão de `model`, `page`, `controller` e `widgets`.
- Sempre registre controllers novos que requeiram escopo de app no arquivo principal que gerencia o `MultiProvider`, ou providencie localmente se for de escopo isolado de uma tela.
