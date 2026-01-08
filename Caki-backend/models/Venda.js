const mongoose = require('mongoose');

const VendaSchema = new mongoose.Schema({
  revenda: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    nick: String
  },
  cliente: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    nick: String
  },
  pacote: {
    id: { type: mongoose.Schema.Types.ObjectId, ref: 'PacoteMoeda' },
    nome: String
  },
  valor: { type: Number, required: true },
  moedas: { type: Number, required: true },
  data: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Venda', VendaSchema);
