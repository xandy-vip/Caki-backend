const express = require('express');
const router = express.Router();
const PedidoMeta = require('../models/PedidoMeta');
const User = require('../models/User');
const { isUser, isReseller } = require('../middlewares/auth');

// Usuário solicita transferência de meta para revenda
router.post('/transferir-meta', isUser, async (req, res) => {
  try {
    const { revendaId, valor } = req.body;
    if (!revendaId || !valor || valor < 5) {
      return res.status(400).json({ error: 'Dados inválidos ou valor mínimo não atingido.' });
    }
    const usuario = await User.findById(req.user.id);
    if ((usuario.saldoMetaDisponivel || 0) < valor) {
      return res.status(400).json({ error: 'Saldo insuficiente.' });
    }
    // Bloqueia saldo
    usuario.saldoMetaDisponivel -= valor;
    usuario.saldoMetaBloqueado = (usuario.saldoMetaBloqueado || 0) + valor;
    await usuario.save();
    // Cria pedido
    const pedido = new PedidoMeta({
      usuario: { id: usuario._id, nick: usuario.nick, foto: usuario.foto },
      revenda: { id: revendaId },
      valor,
      status: 'pendente',
      log: [{ acao: 'solicitado', data: new Date(), usuarioId: usuario._id }]
    });
    await pedido.save();
    res.json({ success: true, pedido });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao solicitar transferência.' });
  }
});

// Revenda lista pedidos pendentes
router.get('/pedidos-pendentes', isReseller, async (req, res) => {
  try {
    const pedidos = await PedidoMeta.find({ 'revenda.id': req.user.id, status: 'pendente' });
    res.json(pedidos);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar pedidos.' });
  }
});

// Revenda aprova ou rejeita pedido
router.post('/pedido/:id/acao', isReseller, async (req, res) => {
  try {
    const { acao } = req.body; // 'aceito' ou 'negado'
    const pedido = await PedidoMeta.findById(req.params.id);
    if (!pedido || pedido.status !== 'pendente') return res.status(404).json({ error: 'Pedido não encontrado ou já processado.' });
    const usuario = await User.findById(pedido.usuario.id);
    const revenda = await User.findById(pedido.revenda.id);
    if (acao === 'aceito') {
      // Deduz saldo bloqueado do usuário
      usuario.saldoMetaBloqueado -= pedido.valor;
      await usuario.save();
      // Credita saldo em dólar na revenda
      revenda.reseller_wallet = (revenda.reseller_wallet || 0) + pedido.valor;
      await revenda.save();
      pedido.status = 'aceito';
      pedido.log.push({ acao: 'aceito', data: new Date(), usuarioId: req.user.id });
    } else if (acao === 'negado') {
      // Retorna saldo para usuário
      usuario.saldoMetaBloqueado -= pedido.valor;
      usuario.saldoMetaDisponivel += pedido.valor;
      await usuario.save();
      pedido.status = 'negado';
      pedido.log.push({ acao: 'negado', data: new Date(), usuarioId: req.user.id });
    } else {
      return res.status(400).json({ error: 'Ação inválida.' });
    }
    pedido.atualizadoEm = new Date();
    await pedido.save();
    res.json({ success: true, pedido });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao processar pedido.' });
  }
});

module.exports = router;
