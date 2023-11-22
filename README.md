## Swapex

Serviço que recupera todas as issues de um determinado repositório no github e retorna um JSON assincronamente via webhook com as issues e contribuidores que existiam no projeto no momento da chamada.

## Entradas e Saídas esperados
- Entrada: Nome do usuário Nome do repositório
- Expectativa de retorno de JSON em um webhook(Utilizar o https://webhook.site/):

```elixir
{ user: nome_usuario
  repository: nome_repositorio
  issues: [
    {title, author and labels},
    {title, author and labels},
    ...
  ],
  contributors: [
    {name, user, qtd_commits},
    {name, user, qtd_commits},
    ....
  ]
 }
```

## Processo

  Criamos as entidades `Issue`, `Contributor` e `GithubRepo` para formar o json de resposta, esperado acima.
  Adicionamos validações aos campos nas entidades, tudo orientado a TDD.

  Em temos de biblioteca externa, ~~preferimos não utilizar o Ecto, visto que não havia necessidade de utilizar banco de dados~~ utilizamos o Ecto com SQLite somente para a execução dos jobs. E também no propósito de deixa o projeto todo mais leve possivel, evitamos de adicioná-lo ao Phoenix, juntamente com o Html (visto que não teria interface web.)

  Para testes utilizamos `faker`, `httpmock`, `mimic`, `mix_test_watch` e `:credo`.
  Para bibliotecas externas, além do phoenix framework (sem ecto e html) utilizamos `httpoison`, `sqlite`, `ecto` e `oban`

  - [x] Criação da entidade `Issue`
  - [x] Criação da entidade `Contributor`
  - [x] Criação da entidade `GithubRepo`
  - [x] Criação do Recurso API com HTTPoison
  - [x] Tratamento da informação proveniente da API em Github.Response
    [x] Configurar Mock em testes de API Externa (requisição HTTPoison)
  - [x] Criação da função para obter os dados do repo do Github
  - [x] Criação da função para obter os dados de issues do repo do Github
  - [x] Criação da função para obter os dados de contribuidores do repo do Github
  - [x] Criação da função de contexto para retorno dos issues
  - [x] Criação da função de contexto para retorno dos contributors
  - [x] Criação da função de contexto para criação do retorno da `saída esperada`
  - [x] Configuração de testes para rate limit
  - [x] Configuração de testes gerenciar estados por testes individuais
  - [x] Ajustar função de obter issues e contributors recursivamente.
  - [x] Criaçao da função para popular o webhook
  - [x] Configuração do Oban com SQLite para agendar operações pro proximo dia
  - [x] Criação de um job imediato (até 1 por vez) para obter os dados do Github
  - [x] Criação de um job agendado (até 10 por vez) para efetuar push pro Webhook
  - [ ] Implementar endpoint para realizar `entrada esperada`

## Observação final
  É necessário implementar prevenção de rate_limit para muitas requisições no Github (60 req/hora) visto que para obter os `issues` e `contributors` é executado uma consulta recursiva na Api do github que retorna sempre 100 de cada, caso o repositorio solicitado tenha muitos contribuidores e muitas issues então o limite de 60 req/hora será facilmente estourado.
  A estratégia que poderiamos implementar é um Genserver para realizar as consultas no github, de maneira que conseguiremos controlar objetivamente a quantidade de requisicoes realizadas, e depois, caso tenha se esgotado as requisicoes durante a montagem dos dados de um repo, o worker esperaria o tempo de disponibilidade para realizar novas (o tempo é informado no header do retorno do github), e então continuaria a montar os dados do repo e somente qundo finalizasse este, iria para o próximo da fila. visto que os jobs `Job.Github` somente performa 1 por vez.

## Para rodar a aplicação
  Configuramos a aplicação para ficar pronta em docker afim de que a execução seja facilitada, além de poder medir o tamanho da imagem e prever a quantidade de recursos que ela necessitará, em caso de rodando em kubernetes.

  * Executar `docker-compose up` para rodar a aplicação através do docker

## Para contribuir com o projeto

 1. Instale a versão mais 1.14 do [Elixir](https://elixir-lang.org/install.html).

 2. Configuramos um script com as validações necessárias para garantir a qualidade do código, e deve ser executado antes de realizar o commit, ou então instale o [pre-commit](https://pre-commit.com/) para que seja configurado para rodar automaticamente antes de subir qualquer commit.

    - Instale o pre-commit com `pip install pre-commit`
    - execute o comando `pre-commit install`na raiz do projeto para configurar a validação no hook do pre-commit.
    - execute o comando `pre-commit run --all-files` para verificar se está tudo ok.
