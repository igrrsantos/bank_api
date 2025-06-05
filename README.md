# Bank Accounts & Transactions API

API para gestão de contas bancárias, transações, depósitos e autenticação de usuários.
Implementada em **Ruby on Rails**, testada com **RSpec** e documentada via **Swagger (Rswag)**.

---

## Índice

- [Tecnologias](#tecnologias)
- [Setup do Projeto](#setup-do-projeto)
- [Configuração do Banco de Dados](#configuração-do-banco-de-dados)
- [Execução da Aplicação](#execução-da-aplicação)
- [Testes Automatizados](#testes-automatizados)
- [Documentação da API](#documentação-da-api)
- [Autenticação](#autenticação)
- [Principais Endpoints](#principais-endpoints)
- [Customização de Mensagens de Erro](#customização-de-mensagens-de-erro)
- [Contribuição](#contribuição)
- [Contato](#contato)

---

## Tecnologias

- Ruby 3.2.2
- Rails 7.1.5
- PostgreSQL
- Sidekiq
- Redis
- RSpec (testes)
- FactoryBot (fixtures)
- Rswag (Swagger/OpenAPI docs)
- JWT (autenticação)
- Dry-Validation, Dry-Monads

---

## Setup do Projeto

1. **Clone o repositório:**
```bash
git clone https://github.com/seu_usuario/seu_repo.git
cd seu_repo
```

2. **Instale as dependências:**
```bundle install```

3. **Configurar variáveis de ambiente:**
(Exemplo usando .env ou credentials.yml.enc — configure DB, JWT_SECRET etc.)

4. **Configurar o banco:**
```bash
rails db:create db:migrate
```

## Execução da Aplicação
```bash
rails server
```
O app estará em http://localhost:3000

## Testes Automatizados

Execute todos os testes de unidade, integração e API:
```bash
bundle exec rspec
```

## Documentação da API
A documentação interativa (Swagger) é gerada a partir dos próprios testes (spec/integration).

1. **Rode os testes de integração para atualizar a documentação:**
```bash
bundle exec rspec --format Rswag::Specs::SwaggerFormatter ./spec/
```

2. **Acesse a documentação:**
Com a aplicação rodando, vá para http://localhost:3000/api-docs

## Autenticação
A maioria dos endpoints exige JWT Token no header:
```bash
Authorization: Bearer <token>
```
Tokens são obtidos no endpoint de login (POST /api/v1/auth/login).

## Principais Endpoints
**Autenticação**
```POST /api/v1/auth/signup``` – Cadastro de usuário

```POST /api/v1/auth/login``` – Login do usuário (retorna token JWT)

**Contas Bancárias**
```POST /api/v1/bank_accounts``` – Criação de conta

```GET /api/v1/bank_accounts/:id/balance``` – Saldo

```GET /api/v1/bank_accounts/:id/bank_statement``` – Extrato (com filtros e paginação)

```POST /api/v1/bank_accounts/deposit``` – Depósito

**Transações**
```POST /api/v1/transactions``` – Transferência imediata

```POST /api/v1/transactions/schedule``` – Agendamento de transferência

## Customização de Mensagens de Erro
Mensagens de erro e validação podem ser personalizadas nos arquivos YAML de tradução:
```config/locales/pt-BR.yml```