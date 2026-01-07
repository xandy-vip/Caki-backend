
const Friend = require('../models/Friend');

exports.addFriend = async (req, res) => {
  const { userId, friendId } = req.body;
  if (!userId || !friendId) return res.status(400).json({ error: 'Dados inválidos' });
  try {
    const friend = new Friend({ userId, friendId });
    await friend.save();
    res.json({ message: 'Amigo adicionado' });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao adicionar amigo' });
  }
};

exports.removeFriend = async (req, res) => {
  const { id } = req.params;
  try {
    await Friend.deleteOne({ friendId: id });
    res.json({ message: 'Amigo removido' });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao remover amigo' });
  }
};
