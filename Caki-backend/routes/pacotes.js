const express = require('express');
const router = express.Router();
const PacoteMoeda = require('../models/PacoteMoeda');
const User = require('../models/User');
const { isReseller, isAdmin } = require('../middlewares/auth');

// Listar todos os pacotes ativos
router.get('/pacotes', isReseller, async (req, res) => {
  try {
    const pacotes = await PacoteMoeda.find({ ativo: true });
    res.json(pacotes);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar pacotes.' });
  }
});

// Comprar pacote de moedas
router.post('/pacotes/comprar/:id', isReseller, async (req, res) => {
  try {
    const pacote = await PacoteMoeda.findById(req.params.id);
    if (!pacote || !pacote.ativo) return res.status(404).json({ error: 'Pacote não encontrado.' });

    const user = await User.findById(req.user.id);
    if (user.reseller_wallet < pacote.valor) {
      return res.status(400).json({ error: 'Saldo insuficiente.' });
    }
    // Debita saldo e credita moedas
    user.reseller_wallet -= pacote.valor;
    user.moedas = (user.moedas || 0) + pacote.moedas + (pacote.bonus || 0);
    await user.save();
    // Aqui pode registrar transação se quiser
    res.json({ success: true, saldo: user.reseller_wallet, moedas: user.moedas });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao comprar pacote.' });
  }
});

// Admin: criar novo pacote
router.post('/pacotes', isAdmin, async (req, res) => {
  try {
    const { valor, moedas, bonus, descricao, ativo } = req.body;
    const pacote = new PacoteMoeda({ valor, moedas, bonus, descricao, ativo });
    await pacote.save();
    res.json(pacote);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao criar pacote.' });
  }
});

// Admin: editar pacote
router.put('/pacotes/:id', isAdmin, async (req, res) => {
  try {
    const pacote = await PacoteMoeda.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(pacote);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao editar pacote.' });
  }
});

// Admin: remover pacote
router.delete('/pacotes/:id', isAdmin, async (req, res) => {
  try {
    await PacoteMoeda.findByIdAndDelete(req.params.id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao remover pacote.' });
  }
});

module.exports = router;
