const express = require('express');
const router = express.Router();
const departmentController = require('../controllers/departmentController');

router.post('/', departmentController.addDepartment);
router.get('/', departmentController.getDepartments);
router.delete('/:id', departmentController.deleteDepartment);
router.get('/name', departmentController.getDepartmentNameById);
router.get('/check', departmentController.checkIfDepartmentExists);
router.get('/byCompany', departmentController.getDepartmentsByCompany);
router.get('/distinctByCompany', departmentController.getDepartments1);

module.exports = router;