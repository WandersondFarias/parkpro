require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const rateLimit = require('express-rate-limit');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── MIDDLEWARES ───────────────────────────────────────────
app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 200 });
app.use('/api/', limiter);

// Servir frontend estático
app.use(express.static(path.join(__dirname, '../frontend/public')));

// ─── ROTAS API ─────────────────────────────────────────────
app.use('/api/auth', require('./routes/auth'));
app.use('/api/movimentacoes', require('./routes/movimentacoes'));
app.use('/api/mensalistas', require('./routes/mensalistas'));
app.use('/api/relatorios', require('./routes/relatorios'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString(), version: '1.0.0' });
});

// SPA fallback - todas as rotas vão para o frontend
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/public/index.html'));
});

// ─── ERROR HANDLER ─────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error('❌ Erro:', err.stack);
  res.status(500).json({ error: 'Erro interno do servidor' });
});

app.listen(PORT, () => {
  console.log(`🅿️  ParkPro rodando na porta ${PORT}`);
  console.log(`🌐 http://localhost:${PORT}`);
});
