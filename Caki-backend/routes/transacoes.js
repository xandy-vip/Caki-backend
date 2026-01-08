const express = require('express');
const router = express.Router();
const Transacao = require('../models/Transacao');
const { isUser, isReseller } = require('../middlewares/auth');

// Registrar nova transação (chamar em cada operação relevante)
router.post('/registrar', async (req, res) => {
  try {
    const { tipo, origem, destino, valor, moeda, descricao, status } = req.body;
    const transacao = new Transacao({ tipo, origem, destino, valor, moeda, descricao, status });
    await transacao.save();
    res.json({ success: true, transacao });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao registrar transação.' });
  }
});

// Listar transações do usuário
router.get('/usuario', isUser, async (req, res) => {
  try {
    const transacoes = await Transacao.find({
      $or: [
        { 'origem.id': req.user.id },
        { 'destino.id': req.user.id }
      ]
    }).sort({ criadoEm: -1 });
    res.json(transacoes);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar transações.' });
  }
});

// Listar transações da revenda
router.get('/revenda', isReseller, async (req, res) => {
  try {
    const transacoes = await Transacao.find({
      $or: [
        { 'origem.id': req.user.id },
        { 'destino.id': req.user.id }
      ]
    }).sort({ criadoEm: -1 });
    res.json(transacoes);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar transações.' });
  }
});

module.exports = router;
