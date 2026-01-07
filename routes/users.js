const express = require('express');
const router = express.Router();
const usersController = require('../controllers/usersController');

// Endpoint para listar todos os usuários (apenas para testes/admin)
router.get('/', usersController.listAllUsers);
router.get('/:id', usersController.getUserProfile);
// Endpoint para atualizar moedas (admin/teste)
router.put('/:id/coins', usersController.setUserCoins);

module.exports = router;
