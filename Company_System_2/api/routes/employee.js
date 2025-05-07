const express = require('express');
const router = express.Router();
const controller = require('../controllers/employeeController');

router.get('/check-email/:email', controller.checkIfEmailExists);
router.put('/update-password', controller.updatePassword);
router.get('/company/:companyName', controller.getEmployeeByCompany);
router.get('/role/:companyName/:role', controller.getEmployeeByRoleAndCompany);
router.get('/role2/:companyName/:role', controller.getEmployeeByRoleAndCompany2);
router.get('/role3/:companyName/:role', controller.getEmployeeByRoleAndCompany3);
router.delete('/:employeeId', controller.deleteEmployee);
router.get('/name/:id', controller.getEmployeeNameById);
router.get('/bnm/:id', controller.getEmployeeIdById);
router.put('/:id', controller.updateEmployee);
router.post('/', controller.insertEmployee);
router.post('/validate', controller.validateUser);
router.get('/email/:email', controller.getUserByEmail);

module.exports = router;