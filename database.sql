-- ============================================================
-- PARKPRO - Schema do Banco de Dados (Supabase / PostgreSQL)
-- Execute este arquivo no SQL Editor do Supabase
-- ============================================================

-- EXTENSÃO para UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- TABELA: usuarios (operadores do sistema)
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  perfil VARCHAR(20) DEFAULT 'operador' CHECK (perfil IN ('admin', 'operador')),
  ativo BOOLEAN DEFAULT true,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABELA: configuracoes (preços e vagas)
-- ============================================================
CREATE TABLE IF NOT EXISTS configuracoes (
  id INTEGER PRIMARY KEY DEFAULT 1,
  preco_carro NUMERIC(10,2) DEFAULT 5.00,
  preco_moto NUMERIC(10,2) DEFAULT 3.00,
  preco_caminhonete NUMERIC(10,2) DEFAULT 7.00,
  preco_mensalidade NUMERIC(10,2) DEFAULT 250.00,
  total_vagas INTEGER DEFAULT 200,
  nome_estacionamento VARCHAR(100) DEFAULT 'ParkPro',
  tolerancia_minutos INTEGER DEFAULT 10,
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO configuracoes (id) VALUES (1) ON CONFLICT DO NOTHING;

-- ============================================================
-- TABELA: mensalistas
-- ============================================================
CREATE TABLE IF NOT EXISTS mensalistas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(14),
  telefone VARCHAR(20),
  email VARCHAR(150),
  placa VARCHAR(10) NOT NULL,
  tipo_veiculo VARCHAR(20) DEFAULT 'Carro',
  vaga_fixa INTEGER,
  vencimento DATE NOT NULL,
  valor_mensal NUMERIC(10,2) NOT NULL,
  ativo BOOLEAN DEFAULT true,
  observacao TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABELA: movimentacoes (entradas e saídas)
-- ============================================================
CREATE TABLE IF NOT EXISTS movimentacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  placa VARCHAR(10) NOT NULL,
  tipo_veiculo VARCHAR(20) DEFAULT 'Carro',
  entrada_em TIMESTAMPTZ DEFAULT NOW(),
  saida_em TIMESTAMPTZ,
  valor_cobrado NUMERIC(10,2),
  tempo_minutos INTEGER,
  tipo_cliente VARCHAR(20) DEFAULT 'avulso' CHECK (tipo_cliente IN ('avulso', 'mensalista')),
  mensalista_id UUID REFERENCES mensalistas(id),
  vaga_numero INTEGER,
  operador_id UUID REFERENCES usuarios(id),
  observacao TEXT,
  status VARCHAR(20) DEFAULT 'dentro' CHECK (status IN ('dentro', 'saiu'))
);

-- ============================================================
-- TABELA: pagamentos
-- ============================================================
CREATE TABLE IF NOT EXISTS pagamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  movimentacao_id UUID REFERENCES movimentacoes(id),
  mensalista_id UUID REFERENCES mensalistas(id),
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('avulso', 'mensalidade')),
  valor NUMERIC(10,2) NOT NULL,
  forma_pagamento VARCHAR(30) DEFAULT 'dinheiro',
  pago_em TIMESTAMPTZ DEFAULT NOW(),
  operador_id UUID REFERENCES usuarios(id)
);

-- ============================================================
-- INDEXES para performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_mov_placa ON movimentacoes(placa);
CREATE INDEX IF NOT EXISTS idx_mov_status ON movimentacoes(status);
CREATE INDEX IF NOT EXISTS idx_mov_entrada ON movimentacoes(entrada_em);
CREATE INDEX IF NOT EXISTS idx_mens_placa ON mensalistas(placa);
CREATE INDEX IF NOT EXISTS idx_pagamentos_data ON pagamentos(pago_em);

-- ============================================================
-- ADMIN padrão (senha: admin123) — TROQUE após o primeiro login
-- ============================================================
INSERT INTO usuarios (nome, email, senha_hash, perfil)
VALUES (
  'Administrador',
  'admin@parkpro.com',
  '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- senha: password
  'admin'
) ON CONFLICT DO NOTHING;

-- ============================================================
-- VIEW: resumo do dia
-- ============================================================
CREATE OR REPLACE VIEW vw_resumo_dia AS
SELECT
  DATE(pago_em) AS data,
  COUNT(*) AS total_saidas,
  SUM(valor) AS faturamento,
  COUNT(CASE WHEN tipo = 'avulso' THEN 1 END) AS avulsos,
  COUNT(CASE WHEN tipo = 'mensalidade' THEN 1 END) AS mensalidades
FROM pagamentos
GROUP BY DATE(pago_em)
ORDER BY data DESC;
