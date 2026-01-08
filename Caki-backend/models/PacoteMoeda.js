const mongoose = require('mongoose');

const PacoteMoedaSchema = new mongoose.Schema({
  valor: { type: Number, required: true }, // valor em dólar
  moedas: { type: Number, required: true }, // quantidade de moedas
  bonus: { type: Number, default: 0 }, // bônus de moedas
  ativo: { type: Boolean, default: true },
  descricao: { type: String }, // opcional para descrição
  criadoEm: { type: Date, default: Date.now }
});

module.exports = mongoose.model('PacoteMoeda', PacoteMoedaSchema);