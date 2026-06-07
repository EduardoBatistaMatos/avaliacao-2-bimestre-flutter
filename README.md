# Eventos App — Prova Adriano 2º Bimestre

Aplicativo Flutter de gerenciamento de **Eventos** e **Transferências**, com persistência local via SQLite e suporte opcional a API REST.

---

## Funcionalidades

### Eventos
- Listagem de eventos em cards
- Cadastro, edição e exclusão de eventos (CRUD completo)
- Confirmação antes de excluir
- Persistência local via SQLite (dados mantidos ao fechar o app)

### Transferências
- Listagem de transferências em cards
- Cadastro de transferências com número da conta e valor
- Armazenamento em memória (dados perdidos ao fechar o app)

---

## Estrutura do projeto

```
├── api/                               # API REST Node.js (opcional)
│   ├── index.js                       # Servidor Express + PostgreSQL
│   └── package.json
│
└── lib/                               # App Flutter
    ├── main.dart                      # Entrada — BottomNavigationBar com 2 abas
    ├── models/
    │   ├── evento.dart                # id?, nome, local, data + toMap/fromMap
    │   └── transferencia.dart         # valor, numeroConta
    ├── components/
    │   └── editor.dart                # TextField reutilizável com label
    ├── db/
    │   └── database_helper.dart       # SQLite — CRUD da tabela eventos
    ├── repository/
    │   ├── evento_repository.dart         # Interface abstrata de eventos
    │   ├── evento_repository_local.dart   # Implementação SQLite (em uso)
    │   ├── evento_repository_remoto.dart  # Implementação HTTP (opcional)
    │   ├── transferencia_repository.dart  # Interface abstrata de transferências
    │   └── transferencia_repository_memoria.dart  # Implementação em memória
    ├── services/
    │   ├── api_config.dart            # URL base da API (baseUrl)
    │   └── evento_service.dart        # Cliente HTTP para a API REST
    └── screens/
        ├── eventos/
        │   ├── lista.dart             # Lista com editar/excluir + loading/erro
        │   └── formulario.dart        # Criar e editar (modo duplo)
        └── transferencia/
            ├── lista.dart             # Lista com loading/erro
            └── formulario.dart        # Criar transferência
```

---

## Onde os dados são salvos

### Eventos — SQLite local
O app usa `EventoRepositoryLocal`, que persiste os dados em um banco SQLite dentro do armazenamento interno do dispositivo:

```
/data/data/com.example.eventos/databases/eventos.db
```

Os dados sobrevivem ao fechamento do app, mas ficam apenas no dispositivo.

### Transferências — memória
O app usa `TransferenciaRepositoryMemoria`. Os dados existem apenas enquanto o app está aberto — são perdidos ao fechar.

---

## Trocar para API remota (opcional)

O projeto já possui a infraestrutura completa para usar uma API REST em vez do SQLite.

### 1. Configure a URL da API

Em [lib/services/api_config.dart](lib/services/api_config.dart):

```dart
class ApiConfig {
  static const String baseUrl = 'https://sua-api.onrender.com';
}
```

### 2. Troque o repository no main.dart

Em [lib/main.dart](lib/main.dart), substitua:

```dart
// de:
final _eventoRepository = EventoRepositoryLocal();

// para:
final _eventoRepository = EventoRepositoryRemoto();
```

---

## API REST (Node.js + PostgreSQL)

Localizada em `api/`. Expõe um CRUD completo de eventos.

### Endpoints

| Método | Rota           | Descrição              |
|--------|----------------|------------------------|
| GET    | /eventos       | Lista todos os eventos |
| POST   | /eventos       | Cria um evento         |
| PUT    | /eventos/:id   | Atualiza um evento     |
| DELETE | /eventos/:id   | Remove um evento       |

### Rodar localmente

```bash
cd api
npm install
```

Crie o arquivo `api/.env`:

```
DATABASE_URL=postgres://usuario:senha@host:5432/nome_do_banco
PORT=3000
```

```bash
npm run dev   # com hot reload (nodemon)
# ou
npm start     # produção
```

### Deploy no Render

Configure as variáveis de ambiente diretamente no painel do serviço (sem `.env`):
- `DATABASE_URL` — string de conexão do PostgreSQL
- `PORT` — definida automaticamente pelo Render

---

## Arquitetura

```
main.dart
    ├── ListaEventos(repository: EventoRepositoryLocal)   ← SQLite
    └── ListaTransferencias(repository: TransferenciaRepositoryMemoria) ← memória

Padrão Repository:
    EventoRepository (interface)
        ├── EventoRepositoryLocal   → DatabaseHelper → SQLite
        └── EventoRepositoryRemoto  → EventoService  → HTTP / API REST
```

| Aspecto                 | Decisão                                                        |
|-------------------------|----------------------------------------------------------------|
| Gerenciamento de estado | `StatefulWidget` local — sem Provider, Bloc ou Riverpod        |
| Persistência (eventos)  | SQLite via `sqflite` — dados persistem no dispositivo          |
| Persistência (transf.)  | Em memória — dados perdidos ao fechar                          |
| Navegação               | `BottomNavigationBar` + `IndexedStack`                         |
| Padrão de acesso        | Repository — troca de fonte de dados sem alterar as telas      |

---

## Tecnologias

### Flutter (app)

| Tecnologia | Versão  |
|------------|---------|
| Flutter    | 3.44.0  |
| Dart SDK   | ^3.10.8 |

**Dependências:**
- `sqflite: ^2.4.2` — SQLite para Android/iOS
- `sqflite_common_ffi: ^2.3.4` — SQLite para desktop (Windows/Linux/macOS)
- `path: ^1.9.1` — manipulação de caminhos de arquivo
- `http: ^1.2.2` — requisições HTTP para a API
- `cupertino_icons: ^1.0.8`

### API (Node.js)

| Tecnologia | Versão  |
|------------|---------|
| Node.js    | >=18    |
| Express    | ^4.19.2 |
| pg         | ^8.12.0 |

---

## Como rodar o app

**Pré-requisitos:** Flutter 3.x instalado e emulador Android ou dispositivo físico conectado.

```bash
flutter pub get
flutter run
```

### Solução de problemas — Gradle

**Erro `Unable to delete directory` ao buildar:**

1. Abra o Gerenciador de Tarefas e encerre processos `java.exe`
2. Delete a pasta `build/` manualmente
3. Rode `flutter run` novamente
