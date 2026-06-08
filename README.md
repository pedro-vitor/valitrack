# ValiTrack

Aplicativo mobile desenvolvido em Flutter para auxiliar promotores de vendas no controle de validade de produtos em múltiplos estabelecimentos.

## Sobre o Projeto

O ValiTrack foi criado para atender uma necessidade comum na rotina de promotores de vendas: acompanhar produtos próximos ao vencimento em diversas lojas.

Diferente de sistemas tradicionais de estoque focados em apenas um estabelecimento, o aplicativo permite gerenciar várias lojas simultaneamente, facilitando o acompanhamento de produtos, datas de validade e quantidades em cada ponto de venda.

O objetivo é oferecer uma ferramenta prática para reduzir perdas, melhorar a organização e agilizar as visitas aos clientes.

## Funcionalidades

- Cadastro de múltiplas lojas.
- Cadastro e gerenciamento de produtos.
- Controle de validade por produto.
- Organização automática dos produtos por mês de vencimento.
- Identificação visual de produtos vencidos ou próximos do vencimento.
- Controle de quantidade em estoque.
- Registro de imagens dos produtos.
- Consulta rápida por loja.
- Edição e exclusão de produtos.
- Armazenamento local para funcionamento offline.

## Tecnologias Utilizadas

- Flutter
- Dart
- Provider
- SQLite
- Material Design

## Como Funciona

1. Cadastre as lojas que serão acompanhadas.
2. Adicione os produtos encontrados em cada estabelecimento.
3. Informe validade, quantidade e demais informações.
4. Visualize os produtos agrupados por mês de vencimento.
5. Identifique rapidamente itens vencidos ou próximos da validade.

## Estrutura do Projeto

```text
lib/
├── components/
├── database/
├── model/
├── providers/
├── screens/
├── services/
├── util/
└── main.dart
```

## Instalação

Clone o projeto:

```bash
git clone https://github.com/pedro-vitor/valitrack.git
```

Entre na pasta:

```bash
cd valitrack
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

## Roadmap

- [ ] Leitura automática de código de barras
- [ ] Notificações de produtos próximos ao vencimento
- [ ] Backup em nuvem
- [ ] Relatórios de validade
- [ ] Dashboard com indicadores por loja
- [ ] Exportação de dados

## Autor

**Pedro Vitor**

GitHub: https://github.com/pedro-vitor

---

Projeto desenvolvido para estudo e aplicação prática de Flutter, gerenciamento de estado e persistência local de dados.