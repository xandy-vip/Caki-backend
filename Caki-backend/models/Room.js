// Lista de usuários bloqueados na sala
RoomSchema.add({
  blockedUsers: [String]
});
// Mensagens privadas entre usuários na sala
RoomSchema.add({
  privateMessages: [
    {
      fromUserId: String,
      toUserId: String,
      text: String,
      date: { type: Date, default: Date.now },
      type: { type: String, default: 'private' }
    }
  ]
});
const mongoose = require('mongoose');


const RoomSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, enum: ['public', 'private'], required: true },
  ownerId: { type: String, required: true }, // Dono da sala
  status: { type: String, enum: ['open', 'closed'], default: 'open' },
  users: [{
    userId: String,
    nickname: String,
    avatar: String,
    isAdmin: { type: Boolean, default: false },
    isHost: { type: Boolean, default: false }
  }],
  mics: [{
    number: Number,
    userId: String,
    occupied: { type: Boolean, default: false },
    muted: { type: Boolean, default: false },
    locked: { type: Boolean, default: false }
  }],
  ranking: [{
    userId: String,
    coins: { type: Number, default: 0 }
  }],
  presents: [{
    fromUserId: String,
    toUserId: String,
    presentType: String,
    value: Number,
    date: { type: Date, default: Date.now }
  }],
  messages: [{
    user: String,
    text: String,
    type: { type: String, default: 'text' },
    date: { type: Date, default: Date.now }
  }],
  rules: { type: String, default: '' },
  admins: [{ type: String }],
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Room', RoomSchema);
