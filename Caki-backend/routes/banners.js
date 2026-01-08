const express = require('express');
const router = express.Router();
const Banner = require('../models/Banner');

// GET /api/banners - lista banners ativos ordenados
router.get('/', async (req, res) => {
  try {
    const banners = await Banner.find({ status: 'ativo' }).sort({ order: 1 });
    res.json(banners);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao buscar banners.' });
  }
});

module.exports = router;
