const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { isReseller } = require('../middlewares/auth');

// Buscar usuário por ID
router.get('/buscar-usuario/:id', isReseller, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado.' });
    res.json({ id: user._id, nick: user.nick, foto: user.foto });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar usuário.' });
  }
});

// Transferir moedas para usuário
router.post('/transferir-moedas', isReseller, async (req, res) => {
  try {
    const { usuarioId, quantidade } = req.body;
    if (!usuarioId || !quantidade || quantidade <= 0) {
      return res.status(400).json({ error: 'Dados inválidos.' });
    }
    const revenda = await User.findById(req.user.id);
    if ((revenda.moedas || 0) < quantidade) {
      return res.status(400).json({ error: 'Saldo insuficiente.' });
    }
    const usuario = await User.findById(usuarioId);
    if (!usuario) return res.status(404).json({ error: 'Usuário não encontrado.' });
    // Deduz saldo da revenda e credita no usuário
    revenda.moedas -= quantidade;
    usuario.moedas = (usuario.moedas || 0) + quantidade;
    await revenda.save();
    await usuario.save();
    // Aqui pode registrar transação se quiser
    res.json({ success: true, usuario: { id: usuario._id, nick: usuario.nick, foto: usuario.foto }, quantidade });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao transferir moedas.' });
  }
});

module.exports = router;
