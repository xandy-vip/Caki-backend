const express = require('express');
const router = express.Router();
const Venda = require('../models/Venda');
const { isReseller } = require('../middlewares/auth');

// Registrar venda
router.post('/registrar', isReseller, async (req, res) => {
  try {
    const { cliente, pacote, valor, moedas } = req.body;
    const venda = new Venda({
      revenda: { id: req.user.id, nick: req.user.nick },
      cliente,
      pacote,
      valor,
      moedas
    });
    await venda.save();
    res.json({ success: true, venda });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao registrar venda.' });
  }
});

// Relatório de vendas por período, cliente, pacote
router.get('/relatorio', isReseller, async (req, res) => {
  try {
    const { inicio, fim, clienteId, pacoteId } = req.query;
    const filtro = { 'revenda.id': req.user.id };
    if (inicio && fim) {
      filtro.data = { $gte: new Date(inicio), $lte: new Date(fim) };
    }
    if (clienteId) filtro['cliente.id'] = clienteId;
    if (pacoteId) filtro['pacote.id'] = pacoteId;
    const vendas = await Venda.find(filtro).sort({ data: -1 });
    // Estatísticas
    const totalVendas = vendas.length;
    const totalMoedas = vendas.reduce((sum, v) => sum + (v.moedas || 0), 0);
    const totalValor = vendas.reduce((sum, v) => sum + (v.valor || 0), 0);
    res.json({ vendas, totalVendas, totalMoedas, totalValor });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao gerar relatório.' });
  }
});

module.exports = router;
