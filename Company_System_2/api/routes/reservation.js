const express = require('express');
const router = express.Router();
const controller = require('../controllers/reservationController');

router.get('/', controller.getReservationsByCompany);
router.delete('/:id', controller.deleteReservation);
router.post('/check', controller.checkReservationConflict);
router.post('/checkavailability', controller.isRoomAvailable);
router.post('/', controller.addReservation);

module.exports = router;