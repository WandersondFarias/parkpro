# 🅿️ ParkPro — Sistema de Estacionamento

Sistema completo de estacionamento com backend Node.js, banco PostgreSQL (Supabase) e deploy gratuito no Render.

---

## 📁 Estrutura do Projeto

```
parkpro/
├── backend/
│   ├── config/
│   │   └── supabase.js       ← Conexão com o banco
│   ├── middleware/
│   │   └── auth.js           ← Autenticação JWT
│   ├── routes/
│   │   ├── auth.js           ← Login / usuários
│   │   ├── movimentacoes.js  ← Entrada e saída
│   │   ├── mensalistas.js    ← Gestão mensalistas
│   │   └── relatorios.js     ← Relatórios e dashboard
│   ├── server.js             ← Servidor principal
│   ├── package.json
│   └── .env.example
├── frontend/
│   └── public/
│       └── index.html        ← Frontend completo (SPA)
├── database.sql              ← Schema do banco de dados
└── render.yaml               ← Configuração de deploy
```

---

## 🚀 PASSO A PASSO — Deploy Gratuito

### ETAPA 1 — Criar banco no Supabase (5 min)

1. Acesse **https://supabase.com** e crie uma conta gratuita
2. Clique em **"New Project"**
3. Preencha:
   - **Name:** parkpro
   - **Database Password:** (anote essa senha!)
   - **Region:** South America (São Paulo) ← mais próximo de Uberaba
4. Aguarde ~2 minutos para criar
5. No painel, vá em **SQL Editor**
6. Cole todo o conteúdo do arquivo `database.sql` e clique **Run**
7. Vá em **Settings → API** e copie:
   - `Project URL` → será sua `SUPABASE_URL`
   - `service_role` (secret) → será sua `SUPABASE_SERVICE_KEY`

### ETAPA 2 — Subir no GitHub (3 min)

1. Acesse **https://github.com** e crie uma conta (se não tiver)
2. Clique em **"New repository"**
3. Nome: `parkpro` → marque **Public** → clique **Create**
4. Na sua máquina, abra o terminal na pasta `parkpro` e rode:

```bash
git init
git add .
git commit -m "ParkPro inicial"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/parkpro.git
git push -u origin main
```

### ETAPA 3 — Deploy no Render (5 min)

1. Acesse **https://render.com** e crie uma conta gratuita (entre com GitHub)
2. Clique em **"New +"** → **"Web Service"**
3. Conecte seu repositório `parkpro`
4. Configure:
   - **Name:** parkpro
   - **Root Directory:** `backend`
   - **Runtime:** Node
   - **Build Command:** `npm install`
   - **Start Command:** `node server.js`
   - **Plan:** Free
5. Em **Environment Variables**, adicione:
   ```
   SUPABASE_URL = https://XXXX.supabase.co
   SUPABASE_SERVICE_KEY = eyJhbG...
   JWT_SECRET = qualquer_string_secreta_longa_aqui_123456
   ```
6. Clique **"Create Web Service"**
7. Aguarde ~3 minutos. Sua URL será algo como: `https://parkpro.onrender.com`

---

## 🔐 Primeiro Acesso

Após o deploy, acesse a URL e faça login com:

- **E-mail:** `admin@parkpro.com`  
- **Senha:** `password`

> ⚠️ **IMPORTANTE:** Troque a senha imediatamente após o primeiro login!

Para criar novos operadores, use a API:
```bash
POST /api/auth/criar-usuario
Authorization: Bearer SEU_TOKEN
{
  "nome": "Operador João",
  "email": "joao@parkpro.com",
  "senha": "senha123",
  "perfil": "operador"
}
```

---

## 🔌 Endpoints da API

### Auth
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/auth/login` | Login |
| GET | `/api/auth/me` | Dados do usuário logado |
| POST | `/api/auth/criar-usuario` | Criar operador (admin) |
| POST | `/api/auth/alterar-senha` | Alterar senha |

### Movimentações
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/movimentacoes` | Listar movimentações |
| GET | `/api/movimentacoes/dentro` | Veículos no pátio agora |
| POST | `/api/movimentacoes/entrada` | Registrar entrada |
| POST | `/api/movimentacoes/saida` | Registrar saída |
| GET | `/api/movimentacoes/preview/:placa` | Preview antes da saída |

### Mensalistas
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/mensalistas` | Listar mensalistas |
| POST | `/api/mensalistas` | Cadastrar mensalista |
| PUT | `/api/mensalistas/:id` | Editar mensalista |
| POST | `/api/mensalistas/:id/renovar` | Renovar mensalidade |
| DELETE | `/api/mensalistas/:id` | Desativar mensalista |

### Relatórios
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/relatorios/dashboard` | Métricas do dashboard |
| GET | `/api/relatorios/financeiro` | Relatório financeiro por período |
| GET | `/api/relatorios/vagas` | Mapa de vagas em tempo real |
| GET | `/api/relatorios/configuracoes` | Ler preços |
| PUT | `/api/relatorios/configuracoes` | Atualizar preços (admin) |

---

## 🛠️ Rodar Localmente

```bash
# 1. Instalar dependências
cd backend
npm install

# 2. Criar arquivo .env
cp .env.example .env
# Edite o .env com suas chaves do Supabase

# 3. Iniciar servidor
npm run dev
# Acesse: http://localhost:3000
```

---

## ✨ Funcionalidades

- ✅ Login com JWT (admin e operador)
- ✅ Registro de entrada e saída de veículos
- ✅ Detecção automática de mensalistas
- ✅ Cálculo automático de valor por hora
- ✅ Gestão completa de mensalistas (CRUD + renovação)
- ✅ Mapa visual de vagas em tempo real (até 300 vagas)
- ✅ Dashboard com métricas ao vivo
- ✅ Relatório financeiro por período
- ✅ Alerta de mensalistas vencendo em 7 dias
- ✅ Múltiplas formas de pagamento
- ✅ Tolerância configurável (ex: 10 min grátis)
- ✅ Configuração de preços por tipo de veículo

---

## 📱 Suporte

Sistema desenvolvido para **ParkPro — Uberaba/MG**  
Compatível com desktop, tablet e celular.
