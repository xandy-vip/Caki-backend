const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const connectDB = require('./models/db');

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
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

module.exports = app;
