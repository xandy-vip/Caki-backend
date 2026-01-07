// Script Node.js para rodar diariamente às 18h e processar retorno de todas as salas
const axios = require('axios');
const mongoose = require('mongoose');
const Room = require('./models/Room');

// Conecte ao MongoDB (ajuste a string de conexão conforme seu ambiente)
mongoose.connect('mongodb://localhost:27017/caki', { useNewUrlParser: true, useUnifiedTopology: true });

async function processAllRoomsDailyReturn() {
  const rooms = await Room.find();
  for (const room of rooms) {
    try {
      await axios.post(`http://localhost:3000/rooms/${room._id}/daily-return`);
      console.log(`Retorno diário processado para sala ${room._id}`);
    } catch (e) {
      console.error(`Erro ao processar sala ${room._id}:`, e.message);
    }
  }
  mongoose.disconnect();
}

processAllRoomsDailyReturn();
