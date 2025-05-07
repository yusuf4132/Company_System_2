const express = require('express');
const router = express.Router();
const controller = require('../controllers/announcementController');

router.post('/', controller.insertAnnouncement);
router.put('/:id', controller.updateAnnouncement);
router.delete('/:id', controller.deleteAnnouncement);
router.get('/', controller.getAnnouncementsByCompany);

module.exports = router;