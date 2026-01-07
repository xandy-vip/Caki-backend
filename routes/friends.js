const express = require('express');
const router = express.Router();
const friendsController = require('../controllers/friendsController');

router.post('/', friendsController.addFriend);
router.delete('/:id', friendsController.removeFriend);

module.exports = router;
