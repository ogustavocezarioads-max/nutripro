-- ============================================================
-- NutriPro — Migration: perfil e jornada_progresso
-- Executar no SQL Editor do Supabase Dashboard
-- https://supabase.com/dashboard/project/bqyrtazdtzktqzykfmux/sql/new
-- ============================================================

ALTER TABLE consultorio
  ADD COLUMN IF NOT EXISTS nome            TEXT,
  ADD COLUMN IF NOT EXISTS cidade          TEXT,
  ADD COLUMN IF NOT EXISTS especialidade   TEXT,
  ADD COLUMN IF NOT EXISTS crn             TEXT,
  ADD COLUMN IF NOT EXISTS photo           TEXT,
  ADD COLUMN IF NOT EXISTS jornada_progresso JSONB DEFAULT '{}'::jsonb;
