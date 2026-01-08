const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  level: { type: Number, default: 1 },
  coins: { type: Number, default: 0 },
  customId: { type: Number, unique: true }, // ID personalizado
});

module.exports = mongoose.model('User', UserSchema);
