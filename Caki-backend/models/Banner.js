const mongoose = require('mongoose');

const BannerSchema = new mongoose.Schema({
  image_url: { type: String, required: true },
  action_type: { type: String, enum: ['screen', 'link', 'recharge'], required: true },
  action_value: { type: String, required: true },
  status: { type: String, enum: ['ativo', 'inativo'], default: 'ativo' },
  order: { type: Number, default: 0 },
  created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Banner', BannerSchema);
