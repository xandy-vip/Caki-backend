const mongoose = require('mongoose');

const PedidoMetaSchema = new mongoose.Schema({
  usuario: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    nick: String,
    foto: String
  },
  revenda: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }
  },
  valor: { type: Number, required: true }, // em dólar
  status: { type: String, enum: ['pendente', 'aceito', 'negado'], default: 'pendente' },
  criadoEm: { type: Date, default: Date.now },
  atualizadoEm: { type: Date },
  log: [{ acao: String, data: Date, usuarioId: String }]
});

module.exports = mongoose.model('PedidoMeta', PedidoMetaSchema);
