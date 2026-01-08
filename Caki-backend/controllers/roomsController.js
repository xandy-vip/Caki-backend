// Atualizar regras da sala
exports.updateRules = async (req, res) => {
  const { rules } = req.body;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    room.rules = rules;
    await room.save();
    res.json({ rules: room.rules });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao atualizar regras' });
  }
};

// Enviar aviso do sistema para a sala
exports.sendSystemNotice = async (req, res) => {
  const { text } = req.body;
  if (!text) return res.status(400).json({ error: 'Texto obrigatório' });
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    room.messages.push({
      user: 'Sistema',
      text,
      type: 'system',
      date: new Date()
    });
    await room.save();
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao enviar aviso do sistema' });
  }
};
// Promover ou rebaixar ADM
exports.setAdmin = async (req, res) => {
  const { userId, makeAdmin } = req.body;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    if (makeAdmin) {
      if (!room.admins.includes(userId)) room.admins.push(userId);
    } else {
      room.admins = room.admins.filter(id => id !== userId);
    }
    // Atualiza flag no array users
    room.users = room.users.map(u => u.userId === userId ? { ...u, isAdmin: !!makeAdmin } : u);
    await room.save();
    res.json({ admins: room.admins });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao atualizar permissões de ADM' });
  }
};

// Expulsar usuário da sala
exports.kickUser = async (req, res) => {
  const { userId } = req.body;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    room.users = room.users.filter(u => u.userId !== userId);
    // Libera microfones ocupados pelo usuário
    room.mics = room.mics.map(m => m.userId === userId ? { ...m, occupied: false, userId: '', muted: false } : m);
    await room.save();
    res.json({ users: room.users });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao expulsar usuário' });
  }
};

// Bloquear usuário na sala
exports.blockUser = async (req, res) => {
  const { userId } = req.body;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    if (!room.blockedUsers) room.blockedUsers = [];
    if (!room.blockedUsers.includes(userId)) room.blockedUsers.push(userId);
    // Remove usuário da sala e libera microfones
    room.users = room.users.filter(u => u.userId !== userId);
    room.mics = room.mics.map(m => m.userId === userId ? { ...m, occupied: false, userId: '', muted: false } : m);
    await room.save();
    res.json({ blockedUsers: room.blockedUsers });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao bloquear usuário' });
  }
};
// Enviar mensagem privada na sala
exports.sendPrivateMessage = async (req, res) => {
  const { fromUserId, toUserId, text } = req.body;
  if (!fromUserId || !toUserId || !text) {
    return res.status(400).json({ error: 'Dados inválidos' });
  }
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    if (!room.privateMessages) room.privateMessages = [];
    const msg = {
      fromUserId,
      toUserId,
      text,
      date: new Date(),
      type: 'private'
    };
    room.privateMessages.push(msg);
    await room.save();
    res.json(msg);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao enviar mensagem privada' });
  }
};

// Listar mensagens privadas entre dois usuários na sala
exports.listPrivateMessages = async (req, res) => {
  const { userA, userB } = req.query;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    const msgs = (room.privateMessages || []).filter(m =>
      (m.fromUserId === userA && m.toUserId === userB) ||
      (m.fromUserId === userB && m.toUserId === userA)
    );
    res.json(msgs);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar mensagens privadas' });
  }
};
// Enviar presente virtual
const User = require('../models/User');
exports.sendPresent = async (req, res) => {
  const { fromUserId, toUserId, presentType, value } = req.body;
  if (!fromUserId || !toUserId || !presentType || !value) {
    return res.status(400).json({ error: 'Dados inválidos' });
  }
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    // Atualiza histórico de presentes
    room.presents.push({ fromUserId, toUserId, presentType, value, date: new Date() });
    // Atualiza ranking
    let rank = room.ranking.find(r => r.userId === toUserId);
    if (!rank) {
      rank = { userId: toUserId, coins: 0 };
      room.ranking.push(rank);
    }
    rank.coins += value;
    // Mensagem no chat
    room.messages.push({
      user: fromUserId,
      text: `Enviou um presente (${presentType}) para ${toUserId} no valor de ${value} moedas!`,
      type: 'gift',
      date: new Date()
    });
    await room.save();
    // Atualiza riqueza do usuário (opcional)
    const user = await User.findById(toUserId);
    if (user) {
      user.coins = (user.coins || 0) + value;
      await user.save();
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao enviar presente' });
  }
};
// Gerenciar microfones
exports.updateMic = async (req, res) => {
  const { micNumber } = req.params;
  const { action, userId } = req.body;
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    const mic = room.mics.find(m => m.number === parseInt(micNumber));
    if (!mic) return res.status(404).json({ error: 'Microfone não encontrado' });
    switch (action) {
      case 'occupy':
        if (mic.occupied) return res.status(400).json({ error: 'Microfone já ocupado' });
        mic.occupied = true;
        mic.userId = userId;
        mic.muted = false;
        break;
      case 'release':
        mic.occupied = false;
        mic.userId = '';
        mic.muted = false;
        break;
      case 'mute':
        mic.muted = true;
        break;
      case 'unmute':
        mic.muted = false;
        break;
      case 'lock':
        mic.locked = true;
        break;
      case 'unlock':
        mic.locked = false;
        break;
      default:
        return res.status(400).json({ error: 'Ação inválida' });
    }
    await room.save();
    res.json(mic);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao atualizar microfone' });
  }
};
const User = require('../models/User');
// Processa retorno diário de 3% para o dono da sala
exports.processDailyReturn = async (req, res) => {
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    const now = new Date();
    const dayStart = getAppDayStart(now);
    // Soma "jogado" (exemplo: 1 ponto por mensagem do tipo 'gift')
    let total = 0;
    room.messages.forEach(msg => {
      if (msg.date && new Date(msg.date) >= dayStart && new Date(msg.date) < now) {
        if (msg.type === 'gift') total += 1; // Ajuste conforme lógica real
      }
    });
    const retorno = Math.floor(total * 0.03);
    if (retorno > 0) {
      // Credita saldo ao dono
      const owner = await User.findById(room.ownerId);
      if (owner) {
        owner.coins = (owner.coins || 0) + retorno;
        await owner.save();
        // Mensagem automática
        room.messages.push({
          user: 'Sistema',
          text: `Você recebeu ${retorno} moedas de retorno diário (3% do total jogado na sala).`,
          type: 'system',
          date: now
        });
        await room.save();
      }
    }
    res.json({ retorno, total });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao processar retorno diário' });
  }
};
// Função utilitária para calcular início/fim do dia e semana (18h)
function getAppDayStart(now) {
  const today18 = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 18, 0, 0, 0);
  if (now < today18) {
    today18.setDate(today18.getDate() - 1);
  }
  return today18;
}

function getAppWeekRange(now) {
  const appDayStart = getAppDayStart(now);
  const daysToSunday = appDayStart.getDay(); // 0 = domingo
  const weekStart = new Date(appDayStart);
  weekStart.setDate(appDayStart.getDate() - daysToSunday);
  weekStart.setHours(18, 0, 0, 0);
  const weekEnd = new Date(weekStart);
  weekEnd.setDate(weekStart.getDate() + 7);
  return { start: weekStart, end: weekEnd };
}

// Calcula ranking diário, semanal, mensal
exports.roomRank = async (req, res) => {
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    const now = new Date();
    const dayStart = getAppDayStart(now);
    const weekRange = getAppWeekRange(now);
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1, 18, 0, 0, 0);

    // Função para somar pontos e charma por usuário
    function aggregate(messages, start, end) {
      const stats = {};
      messages.forEach(msg => {
        if (msg.date && new Date(msg.date) >= start && new Date(msg.date) < end) {
          if (!stats[msg.user]) stats[msg.user] = { user: msg.user, points: 0, charma: 0 };
          stats[msg.user].points += 1; // 1 ponto por mensagem enviada
          if (msg.type === 'charma') stats[msg.user].charma += 1; // Exemplo: tipo charma
        }
      });
      // Ordena por pontos
      return Object.values(stats).sort((a, b) => b.points - a.points);
    }

    const daily = aggregate(room.messages, dayStart, now);
    const weekly = aggregate(room.messages, weekRange.start, now);
    const monthly = aggregate(room.messages, monthStart, now);

    res.json({ daily, weekly, monthly });
  } catch (err) {
    res.status(500).json({ error: 'Erro ao calcular ranking' });
  }
};

const Room = require('../models/Room');

exports.listRooms = async (req, res) => {
  try {
    const rooms = await Room.find();
    res.json(rooms);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao listar salas' });
  }
};

exports.createRoom = async (req, res) => {
  const {
    name,
    type,
    ownerId,
    users = [],
    mics = [],
    ranking = [],
    presents = [],
    messages = [],
    rules = '',
    admins = [],
    status = 'open'
  } = req.body;
  if (!name || !type || !ownerId) return res.status(400).json({ error: 'Dados inválidos' });
  try {
    // Inicializa 10 microfones livres por padrão
    const defaultMics = Array.from({ length: 10 }, (_, i) => ({
      number: i + 1,
      userId: '',
      occupied: false,
      muted: false,
      locked: false
    }));
    const newRoom = new Room({
      name,
      type,
      ownerId,
      status,
      users: users.length ? users : [{ userId: ownerId, isHost: true, isAdmin: true }],
      mics: mics.length ? mics : defaultMics,
      ranking,
      presents,
      messages,
      rules,
      admins: admins.length ? admins : [ownerId]
    });
    await newRoom.save();
    res.json(newRoom);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao criar sala' });
  }
};

exports.listMessages = async (req, res) => {
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    res.json(room.messages);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar mensagens' });
  }
};

exports.sendMessage = async (req, res) => {
  const { user, text, type } = req.body;
  if (!user || !text) return res.status(400).json({ error: 'Dados inválidos' });
  try {
    const room = await Room.findById(req.params.id);
    if (!room) return res.status(404).json({ error: 'Sala não encontrada' });
    const msg = { user, text, type: type || 'text', date: new Date() };
    room.messages.push(msg);
    await room.save();
    res.json(msg);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao enviar mensagem' });
  }
};
