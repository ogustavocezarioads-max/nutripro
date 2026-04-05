-- ============================================================
-- NutriPro — Tabelas: consultorio + lancamentos
-- Executar no SQL Editor do Supabase Dashboard
-- ============================================================

-- 1. TABELA: consultorio (plano, metas, produtos por nutricionista)
CREATE TABLE IF NOT EXISTS consultorio (
  user_id       UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  plano         TEXT NOT NULL DEFAULT 'essencial',
  meta_anual    NUMERIC,
  meta_mensal   NUMERIC,
  produtos      JSONB DEFAULT '[]'::jsonb,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE consultorio ENABLE ROW LEVEL SECURITY;

CREATE POLICY "consultorio_own"
  ON consultorio FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- 2. TABELA: lancamentos (financeiro — entradas e saídas)
CREATE TABLE IF NOT EXISTS lancamentos (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tipo          TEXT NOT NULL CHECK (tipo IN ('entrada','saida')),
  descricao     TEXT NOT NULL,
  valor         NUMERIC NOT NULL,
  data          DATE NOT NULL,
  status        TEXT DEFAULT 'nao_recebido',
  categoria     TEXT,
  paciente      TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lancamentos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "lancamentos_own"
  ON lancamentos FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE INDEX IF NOT EXISTS idx_lancamentos_user_data
  ON lancamentos(user_id, data DESC);
