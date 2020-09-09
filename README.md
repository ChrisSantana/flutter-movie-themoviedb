# Flutter Movie The Movie DB
Projeto Flutter base com bottom-navigator

## Estrutura do Projeto

Com o objetivo de organizar e compor responsabilidades a cada repositório, o projeto
esta estruturado da seguinte forma:

- Bloc:
Diretório com as classes responsáveis pela camada lógica, gerenciamento de estado, que se comunica com a view e
seus respectivos repositorys.

- Data:
Diretório que armazena dados fictícios ou storages locais que são abertos com a aplicação
sem a necessidade de estar em um servidor externo, por exemplo.

- Enums:
Os enums são arquivos que configuram dados essências para a aplicação e são imutáveis.

- Library:
Constantes, arquivos de configuração e classes utéis são armazenadas nesse diretório.

- Model:
Os models são classes com propriedades específicas de um determinado objeto. Essas classes
possuem métodos essências para mapear o retorno de dados da API, por exemplo.

- Repository:
Nesse diretório estão os arquivos do tipo service que fazem comunicação com serviços externos ou alguma base de dados.

- Screen:
O diretório Screen compõe os Widgets responsáveis pelas telas da aplicação. o sufixo _screen define que
o Widget é uma tela, já o sufixo _tab define que o Widget é uma aba de uma tela específica, ou seja, uma subtela de uma screen.

- Tile:
Os tiles são Widgtes reusáveis em screen, tab ou em outros Widgtes. Úteis para ser exibidos em uma lista, card, etc.

- Widget:
Nesse diretório estão os Widgets, os quais, podem ser utilizados/reusáveis em screen, tabs ou em outros Widgets.

## Configuração

Baixe o SDK do [Flutter](https://flutter.dev/docs/get-started/install/windows) específico para o Windows e extraia o arquivo zip em um diretório do seu interesse. Exemplo: c:\src\flutter.

Após isso, adicione o caminho flutter/bin nas variáveis de ambiente e rode o comando:

```bash
flutter doctor
```
Observação: Não instale o Flutter em um diretório que exija privilégios.

[Flutter Release](https://flutter.dev/docs/development/tools/sdk/releases)

[Flutter Tutorial](https://flutter.dev/docs/cookbook)



## Copyright ©

[Christiano Santana](https://www.linkedin.com/in/christiano-santana-7b090628)
