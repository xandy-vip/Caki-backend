
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');


exports.register = async (req, res) => {
  const { username, password, customId } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Dados inválidos' });
  try {
    const userExists = await User.findOne({ username });
    if (userExists) return res.status(409).json({ error: 'Usuário já existe' });

    // Se customId for fornecido e for de 1 a 199999, só permitir se for admin (painel)
    if (customId && customId >= 1 && customId <= 199999) {
      // Aqui você pode adicionar verificação de admin, ex: req.user.isAdmin
      return res.status(403).json({ error: 'Somente admin pode criar customId de 1 a 199999' });
    }

    // Gerar customId automático entre 200000 e 999999
    let generatedId;
    let exists = true;
    while (exists) {
      generatedId = Math.floor(Math.random() * (999999 - 200000 + 1)) + 200000;
      exists = await User.findOne({ customId: generatedId });
    }

    const hash = bcrypt.hashSync(password, 8);
    const user = new User({ username, password: hash, customId: generatedId });
    await user.save();
    res.json({ message: 'Usuário registrado com sucesso', customId: generatedId });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao registrar usuário' });
  }
};


exports.login = async (req, res) => {
  const { username, password } = req.body;
  try {
    const user = await User.findOne({ username });
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });
    const valid = bcrypt.compareSync(password, user.password);
    if (!valid) return res.status(401).json({ error: 'Senha inválida' });
    const token = jwt.sign({ id: user._id, username: user.username }, 'segredo', { expiresIn: '1h' });
    res.json({ token, userId: user._id });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao fazer login' });
  }
};
