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
  const { name, type } = req.body;
  if (!name || !type) return res.status(400).json({ error: 'Dados inválidos' });
  try {
    const newRoom = new Room({ name, type });
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
