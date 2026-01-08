const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Transaction = require('../models/Transaction');

// GET /api/reseller/wallet?userId=123
router.get('/wallet', async (req, res) => {
  try {
    const userId = req.query.userId;
    const user = await User.findOne({ customId: userId, is_reseller: true });
    if (!user) return res.status(404).json({ error: 'Revenda não encontrada ou não autorizada.' });

    // Saldo de moedas e financeiro
    const saldoMoedas = user.coins || 0;
    const saldoFinanceiro = user.saldo_financeiro || 0;

    // Histórico de compras
    const historicoCompras = await Transaction.find({ to_user_id: userId, type: 'buy' }).sort({ created_at: -1 }).limit(20);
    // Histórico de vendas
    const historicoVendas = await Transaction.find({ from_user_id: userId, type: 'sell' }).sort({ created_at: -1 }).limit(20);

    res.json({
      saldoMoedas,
      saldoFinanceiro,
      historicoCompras,
      historicoVendas
    });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar carteira da revenda.' });
  }
});

module.exports = router;
