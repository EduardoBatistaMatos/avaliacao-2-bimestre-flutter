const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_URL ? { rejectUnauthorized: false } : false,
});

async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS eventos (
      id    SERIAL PRIMARY KEY,
      nome  TEXT NOT NULL,
      local TEXT NOT NULL,
      data  TEXT NOT NULL
    )
  `);
  console.log('Tabela "eventos" pronta.');
}

// GET /eventos
app.get('/eventos', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM eventos ORDER BY id ASC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// POST /eventos
app.post('/eventos', async (req, res) => {
  const { nome, local, data } = req.body;
  if (!nome || !local || !data) {
    return res.status(400).json({ erro: 'Campos nome, local e data são obrigatórios.' });
  }
  try {
    const { rows } = await pool.query(
      'INSERT INTO eventos (nome, local, data) VALUES ($1, $2, $3) RETURNING *',
      [nome, local, data],
    );
    res.status(201).json(rows[0]);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// PUT /eventos/:id
app.put('/eventos/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const { nome, local, data } = req.body;
  if (!nome || !local || !data) {
    return res.status(400).json({ erro: 'Campos nome, local e data são obrigatórios.' });
  }
  try {
    const { rows } = await pool.query(
      'UPDATE eventos SET nome=$1, local=$2, data=$3 WHERE id=$4 RETURNING *',
      [nome, local, data, id],
    );
    if (rows.length === 0) return res.status(404).json({ erro: 'Evento não encontrado.' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

// DELETE /eventos/:id
app.delete('/eventos/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  try {
    const { rowCount } = await pool.query('DELETE FROM eventos WHERE id=$1', [id]);
    if (rowCount === 0) return res.status(404).json({ erro: 'Evento não encontrado.' });
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

const PORT = process.env.PORT || 3000;
initDb()
  .then(() => app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`)))
  .catch((err) => {
    console.error('Falha ao inicializar o banco:', err.message);
    process.exit(1);
  });
