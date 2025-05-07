const express = require('express');
const router = express.Router();
const controller = require('../controllers/progressController');

router.post('/', controller.addProgress);               
router.get('/:jobId', controller.getProgressByJobId);   

module.exports = router;