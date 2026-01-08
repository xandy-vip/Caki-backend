const mongoose = require('mongoose');

const TransacaoSchema = new mongoose.Schema({
  tipo: { type: String, required: true }, // compra, venda, transferência, conversão, etc.
  origem: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    nick: String,
    foto: String
  },
  destino: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    nick: String,
    foto: String
  },
  valor: { type: Number, required: true },
  moeda: { type: String, default: 'USD' },
  status: { type: String, enum: ['pendente', 'concluida', 'cancelada'], default: 'concluida' },
  descricao: String,
  criadoEm: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Transacao', TransacaoSchema);
