// Regras e avisos do sistema
router.patch('/:id/rules', roomsController.updateRules);
router.post('/:id/system-notice', roomsController.sendSystemNotice);
// Permissões de ADM e controle de usuários
router.post('/:id/set-admin', roomsController.setAdmin);
router.post('/:id/kick-user', roomsController.kickUser);
router.post('/:id/block-user', roomsController.blockUser);
// Mensagens privadas
router.post('/:id/private-message', roomsController.sendPrivateMessage);
router.get('/:id/private-messages', roomsController.listPrivateMessages);
// Enviar presente virtual
router.post('/:id/present', roomsController.sendPresent);
// Microfone: ocupar/liberar/mute/unmute/lock/unlock
router.patch('/:id/mic/:micNumber', roomsController.updateMic);
const express = require('express');
const router = express.Router();
const roomsController = require('../controllers/roomsController');


router.get('/', roomsController.listRooms);
router.post('/', roomsController.createRoom);
router.get('/:id/messages', roomsController.listMessages);
router.post('/:id/messages', roomsController.sendMessage);
router.get('/:id/rank', roomsController.roomRank); // NOVA ROTA
router.post('/:id/daily-return', roomsController.processDailyReturn); // Retorno diário

module.exports = router;
