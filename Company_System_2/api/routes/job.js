const express = require('express');
const router = express.Router();
const controller = require('../controllers/jobController');

router.get('/byy', controller.getJobs);
router.put('/mainj',controller.updateMainJobProgress); 
router.post('/', controller.insertJob);
router.put('/progress', controller.updateJobProgress); 
router.get('/by/:companyName/:role/:id', controller.getJobsByCompany);
router.delete('/:jobId', controller.deleteJob);                    
router.put('/:id', controller.updateJob);                     
router.get('/subj/:jobId', controller.getJobsByParentJobId);     

module.exports = router;