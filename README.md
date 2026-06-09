# Gerenciador de Eventos

App mobile em Flutter para cadastrar, listar, editar e excluir eventos. Tenta comunicação com a API em todas as operações; se indisponível, opera localmente via SQLite.

## Integrantes

Eduardo Batista Matos

Luis Fernando Mendes

---

## Rotas da API

**Base URL:** `https://eventos-api-7z2v.onrender.com`

| Método | Rota | Descrição | Body |
|--------|------|-----------|------|
| GET | `/eventos` | Lista todos os eventos | — |
| POST | `/eventos` | Cria um evento | `{ "nome": "", "local": "", "data": "" }` |
| PUT | `/eventos/:id` | Atualiza um evento | `{ "nome": "", "local": "", "data": "" }` |
| DELETE | `/eventos/:id` | Remove um evento | — |
