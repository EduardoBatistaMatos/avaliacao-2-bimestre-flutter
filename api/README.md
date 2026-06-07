# Eventos API

API REST para gerenciamento de eventos, construída com Node.js + Express + PostgreSQL.  
Pronta para deploy no [Render](https://render.com).

---

## Variáveis de ambiente

| Variável       | Descrição                                      | Obrigatória |
|----------------|------------------------------------------------|-------------|
| `DATABASE_URL` | Connection string do PostgreSQL (ex.: Render)  | Sim         |
| `PORT`         | Porta HTTP (padrão: `3000`)                    | Não         |

---

## Inicialização

A tabela `eventos` é criada automaticamente no startup caso não exista. Nenhuma migration manual é necessária.

---

## Rotas

### `GET /eventos`

Lista todos os eventos ordenados por `id`.

**Resposta 200**
```json
[
  { "id": 1, "nome": "Hackathon SENAI", "local": "Sala 3", "data": "2025-08-10" },
  { "id": 2, "nome": "Workshop Flutter", "local": "Auditório", "data": "2025-09-05" }
]
```

---

### `POST /eventos`

Cadastra um novo evento.

**Body (JSON)**
```json
{
  "nome": "Hackathon SENAI",
  "local": "Sala 3",
  "data": "2025-08-10"
}
```

**Resposta 201**
```json
{ "id": 1, "nome": "Hackathon SENAI", "local": "Sala 3", "data": "2025-08-10" }
```

**Resposta 400** — campo ausente
```json
{ "erro": "Campos nome, local e data são obrigatórios." }
```

---

### `PUT /eventos/:id`

Atualiza um evento existente pelo `id`.

**Parâmetro de rota:** `id` (integer)

**Body (JSON)**
```json
{
  "nome": "Hackathon SENAI 2025",
  "local": "Sala 5",
  "data": "2025-08-15"
}
```

**Resposta 200**
```json
{ "id": 1, "nome": "Hackathon SENAI 2025", "local": "Sala 5", "data": "2025-08-15" }
```

**Resposta 404** — id não encontrado
```json
{ "erro": "Evento não encontrado." }
```

---

### `DELETE /eventos/:id`

Remove um evento pelo `id`.

**Parâmetro de rota:** `id` (integer)

**Resposta 204** — sem corpo

**Resposta 404** — id não encontrado
```json
{ "erro": "Evento não encontrado." }
```

---

## Como rodar localmente

```bash
# Instalar dependências
npm install

# Definir a variável de ambiente (PowerShell)
$env:DATABASE_URL = "postgresql://usuario:senha@host:5432/banco"

# Modo desenvolvimento (recarrega ao salvar)
npm run dev

# Modo produção
npm start
```

---

## Deploy no Render

1. Crie um serviço **Web Service** apontando para este repositório.
2. Defina **Root Directory** como `api` (se o repositório contiver o projeto Flutter junto).
3. Configure a variável de ambiente `DATABASE_URL` com a connection string do banco PostgreSQL do Render.
4. **Build Command:** `npm install`
5. **Start Command:** `npm start`
