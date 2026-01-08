const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const connectDB = require('./models/db');


const http = require('http');
const app = express();
app.use(cors());
app.use(bodyParser.json());

// Conectar ao MongoDB
connectDB();

// Rotas principais
app.use('/auth', require('./routes/auth'));
const authMiddleware = require('./middlewares/auth');
app.use('/rooms', authMiddleware, require('./routes/rooms'));
app.use('/users', authMiddleware, require('./routes/users'));
app.use('/friends', authMiddleware, require('./routes/friends'));

app.get('/', (req, res) => {
  res.send('API Caki Backend rodando!');
});

const PORT = process.env.PORT || 3000;
const server = http.createServer(app);

// Socket.IO setup
const { Server } = require('socket.io');
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});


io.on('connection', (socket) => {
  console.log('Novo cliente conectado:', socket.id);

  // Entrar em uma sala
  socket.on('joinRoom', ({ roomId, userId }) => {
    socket.join(roomId);
    io.to(roomId).emit('userJoined', { userId, socketId: socket.id });
  });

  // Sair de uma sala
  socket.on('leaveRoom', ({ roomId, userId }) => {
    socket.leave(roomId);
    io.to(roomId).emit('userLeft', { userId, socketId: socket.id });
  });

  // Enviar mensagem para a sala
  socket.on('sendMessage', ({ roomId, message }) => {
    io.to(roomId).emit('newMessage', message);
  });

  // Atualizar microfone
  socket.on('updateMic', ({ roomId, mic }) => {
    io.to(roomId).emit('micUpdated', mic);
  });

  // Enviar presente
  socket.on('sendPresent', ({ roomId, present }) => {
    io.to(roomId).emit('presentSent', present);
  });

  // Promover/rebaixar admin
  socket.on('setAdmin', ({ roomId, userId, makeAdmin }) => {
    io.to(roomId).emit('adminUpdated', { userId, makeAdmin });
  });

  // Expulsar usuário
  socket.on('kickUser', ({ roomId, userId }) => {
    io.to(roomId).emit('userKicked', { userId });
  });

  // Bloquear usuário
  socket.on('blockUser', ({ roomId, userId }) => {
    io.to(roomId).emit('userBlocked', { userId });
  });

  // Atualizar regras
  socket.on('updateRules', ({ roomId, rules }) => {
    io.to(roomId).emit('rulesUpdated', rules);
  });

  // Aviso do sistema
  socket.on('sendSystemNotice', ({ roomId, notice }) => {
    io.to(roomId).emit('systemNotice', notice);
  });

  socket.on('disconnect', () => {
    console.log('Cliente desconectado:', socket.id);
  });
});

server.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

module.exports = { app, server, io };
