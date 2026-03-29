-- ============================================================
-- NutriPro — Migração: Módulo de Pacientes para Supabase
-- Executar no SQL Editor do Supabase Dashboard
-- ============================================================

-- 1. TABELA: pacientes
CREATE TABLE IF NOT EXISTS pacientes (
  id            UUID PRIMARY KEY,
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nome          TEXT NOT NULL,
  objetivo      TEXT,
  tipo          TEXT,
  status        TEXT DEFAULT 'ativo',
  inicio        DATE,
  prox_consulta DATE,
  valor         NUMERIC,
  whats         TEXT DEFAULT '',
  obs           TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABELA: evolucoes
CREATE TABLE IF NOT EXISTS evolucoes (
  id           UUID PRIMARY KEY,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  paciente_id  UUID NOT NULL REFERENCES pacientes(id) ON DELETE CASCADE,
  data         DATE NOT NULL,
  peso         NUMERIC,
  humor        TEXT,
  obs          TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABELA: consultas
CREATE TABLE IF NOT EXISTS consultas (
  id           UUID PRIMARY KEY,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  paciente_id  UUID NOT NULL REFERENCES pacientes(id) ON DELETE CASCADE,
  data         DATE NOT NULL,
  status       TEXT,
  notas        TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABELA: contatos
CREATE TABLE IF NOT EXISTS contatos (
  id           UUID PRIMARY KEY,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  paciente_id  UUID NOT NULL REFERENCES pacientes(id) ON DELETE CASCADE,
  data         DATE NOT NULL,
  canal        TEXT,
  resultado    TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. ROW LEVEL SECURITY (RLS) — cada nutricionista vê só os seus
-- ============================================================

ALTER TABLE pacientes  ENABLE ROW LEVEL SECURITY;
ALTER TABLE evolucoes  ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultas  ENABLE ROW LEVEL SECURITY;
ALTER TABLE contatos   ENABLE ROW LEVEL SECURITY;

-- Políticas: cada usuário acessa apenas seus próprios dados
CREATE POLICY "pacientes_own"  ON pacientes  FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "evolucoes_own"  ON evolucoes  FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "consultas_own"  ON consultas  FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "contatos_own"   ON contatos   FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- ============================================================
-- 6. ÍNDICES — performance nas queries mais comuns
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_pacientes_user     ON pacientes(user_id);
CREATE INDEX IF NOT EXISTS idx_evolucoes_user_pac ON evolucoes(user_id, paciente_id);
CREATE INDEX IF NOT EXISTS idx_consultas_user_pac ON consultas(user_id, paciente_id);
CREATE INDEX IF NOT EXISTS idx_contatos_user_pac  ON contatos(user_id, paciente_id);
