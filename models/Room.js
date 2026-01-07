const mongoose = require('mongoose');

const RoomSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, enum: ['public', 'private'], required: true },
  ownerId: { type: String, required: true }, // Dono da sala
  messages: [{
    user: String,
    text: String,
    type: { type: String, default: 'text' },
    date: { type: Date, default: Date.now }
  }]
});

module.exports = mongoose.model('Room', RoomSchema);
