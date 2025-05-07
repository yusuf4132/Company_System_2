const Department = require('../models/Department');

exports.addDepartment = async (req, res) => {
  const { departmentName, companyName } = req.body;

  const existingDepartment = await Department.findOne({ name: departmentName, company: companyName });
  if (existingDepartment) {
    return res.status(400).json({ message: 'Departman zaten mevcut' });
  }

  try {
    const newDepartment = new Department({
      name: departmentName,
      company: companyName,
    });

    await newDepartment.save();
    res.status(201).json(newDepartment); 
  } catch (err) {
    res.status(500).json({ message: 'Departman eklenirken bir hata oluştu', error: err.message });
  }
};

exports.getDepartments = async (req, res) => {
  const { companyName } = req.query; 

  try {
    const departments = await Department.find({ company: companyName });

    if (departments.length === 0) {
      return res.status(404).json({ message: 'Hiç departman bulunamadı' });
    }

    res.status(200).json(departments);
  } catch (err) {
    res.status(500).json({ message: 'Departmanlar alınırken bir hata oluştu', error: err.message });
  }
};


exports.deleteDepartment = async (req, res) => {
  const { id } = req.params; 

  try {
    const department = await Department.findById(id);

    if (!department) {
      return res.status(404).json({ message: 'Departman bulunamadı' });
    }

    await department.deleteOne();
    res.status(200).json({ message: 'Departman silindi' });
  } catch (err) {
    res.status(500).json({ message: 'Departman silinirken bir hata oluştu', error: err.message });
  }
};
exports.checkIfDepartmentExists = async (req, res) => {
  const { departmentName, companyName } = req.query;
    
      try {
        const department = await Department.findOne({
          name: departmentName,
          company: companyName,
        });
    
        return res.status(200).json({ exists: !!department });
      } catch (err) {
        console.error(err);
        return res.status(500).json({
          message: 'Departman kontrol edilirken bir hata oluştu',
          error: err.message,
        });
      }
};
    
exports.getDepartmentsByCompany = async (req, res) => {
    const { companyName } = req.query;
  
    try {
      const departments = await Department.find({ company: companyName });
  
      if (departments.length === 0) {
        return res.status(404).json({ message: 'Hiç departman bulunamadı' });
      }
  
      res.status(200).json(departments);
    } catch (err) {
      res.status(500).json({ message: 'Departmanlar alınırken bir hata oluştu', error: err.message });
    }
  };

exports.getDepartments1 = async (req, res) => {
    const { companyName } = req.query; 
  
    try {
      const departments = await Department.distinct('name', { company: companyName });
  
      if (departments.length === 0) {
        return res.status(404).json({ message: 'Hiç benzersiz departman bulunamadı' });
      }
  
      res.status(200).json(departments);
    } catch (err) {
      res.status(500).json({ message: 'Departmanlar alınırken bir hata oluştu', error: err.message });
    }
  };

exports.getDepartmentNameById = async (req, res) => {
  const { id } = req.query; 
  try {

    if (id==="null" ||id===null) {
      return res.status(200).json({ name: 'Yok' }); 
    }
    const department = await Department.findById(id);
    res.status(200).json({ name: department.name }); 
  } catch (err) {
    res.status(500).json({ message: 'Departman alınırken bir hata oluştu', error: err.message });
  }
};