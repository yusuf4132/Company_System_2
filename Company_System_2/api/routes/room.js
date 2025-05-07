const express = require('express');
const router = express.Router();
const controller = require('../controllers/roomController');

router.post('/', controller.addRoom);                  
router.delete('/:id', controller.deleteRoom);         
router.get('/', controller.getRoomsByCompany);
router.get('/check', controller.checkIfRoomExists); 
module.exports = router;