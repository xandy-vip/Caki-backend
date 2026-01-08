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
