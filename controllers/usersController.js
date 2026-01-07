// Lista todos os usuários (apenas para testes/admin)
exports.listAllUsers = async (req, res) => {
  try {
    const users = await User.find({}, 'username coins');
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao listar usuários' });
  }
};
// Atualiza o saldo de moedas de um usuário (admin/teste)
exports.setUserCoins = async (req, res) => {
  try {
    const { coins } = req.body;
    if (typeof coins !== 'number' || coins < 0) {
      return res.status(400).json({ error: 'Valor de moedas inválido' });
    }
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { coins },
      { new: true }
    ).select('-password');
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });
    res.json({ message: 'Saldo atualizado', user });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao atualizar moedas' });
  }
};

const User = require('../models/User');

exports.getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    if (!user) return res.status(404).json({ error: 'Usuário não encontrado' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar usuário' });
  }
};
