const Employee = require('../models/Employee');

exports.updatePassword = async (req, res) => {
  const { email, newPassword } = req.body;
  try {
    const updatedEmployee = await Employee.findOneAndUpdate(
      { email },
      { password: newPassword },
      { new: true }
    );
    if (updatedEmployee) {
      res.json({ success: true });
    } else {
      res.status(404).json({ error: 'Kullanıcı bulunamadı' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.checkIfEmailExists = async (req, res) => {
  const { email } = req.params;
  try {
    const employee = await Employee.findOne({ email });
    res.json({ exists: !!employee });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getEmployeeByCompany = async (req, res) => {
  const { companyName } = req.params;
  try {
    const employees = await Employee.find({ company: companyName });
    res.json(employees);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getEmployeeByRoleAndCompany = async (req, res) => {
  const { companyName, role } = req.params;
  const { departmentId } = req.query;
  try {
    let employees;
    if (role === 'admin') {
      employees = await Employee.find({ company: companyName });
    } else if (role === 'department_manager' && departmentId) {
      employees = await Employee.find({
        company: companyName,
        department_id: departmentId,
      });
    } else {
      employees = [];
    }
    res.json(employees);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getEmployeeByRoleAndCompany2 = async (req, res) => {
  const { companyName, role } = req.params;
  const { departmentId, searchQuery } = req.query; 
  try {
    let filter = { company: companyName };
    if (searchQuery && searchQuery.trim() !== '' && searchQuery !== 'null') {
      filter['$or'] = [
        { name: new RegExp(searchQuery, 'i') },
        { surname: new RegExp(searchQuery, 'i') },
      ];
    }
    if (role === 'admin') {
      const employees = await Employee.find(filter);
      res.status(200).json(employees);
    } 
    else if (role === 'department_manager' && departmentId) {
      filter.department_id = departmentId;
      const employees = await Employee.find(filter);
      res.json(employees);
    } 
    else {
      res.json([]);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getEmployeeByRoleAndCompany3 = async (req, res) => {
  const { companyName, role } = req.params;
  const { departmentId, searchQuery } = req.query; 
  
  try {
    let filter = { company: companyName };
    if (searchQuery && searchQuery.trim() !== ''&& searchQuery !== 'null') {
      filter['$or'] = [
        { name: new RegExp(searchQuery, 'i') },
        { surname: new RegExp(searchQuery, 'i') },
      ];
    }
    if (role === 'admin') {
      filter.role = 'department_manager';
      const employees = await Employee.find(filter);
      res.json(employees);
    } 
    else if (role === 'department_manager' && departmentId) {
      filter.department_id = departmentId;
      filter.role = 'staff';
      const employees = await Employee.find(filter);
      res.json(employees);
    } 
    else {
      res.json([]);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteEmployee = async (req, res) => {
  const { employeeId } = req.params;
  try {
    await Employee.findByIdAndDelete(employeeId);
    res.json({ message: 'Çalışan silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getEmployeeNameById = async (req, res) => {
  const { id } = req.params;
  try {
    const employee = await Employee.findById(id);
    if (employee) {
      res.json({ name: `${employee.name} ${employee.surname}` });
    } else {
      res.status(404).json({ error: 'Çalışan bulunamadı' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
exports.getEmployeeIdById = async (req, res) => {
  const { id } = req.params;
  try {
    const employee = await Employee.findById(id);
    if (employee) {
      res.json( { id: employee.id } );
    } else {
      res.status(404).json({ error: 'Çalışan bulunamadı' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateEmployee = async (req, res) => {
  const { id } = req.params;
  const updatedData = req.body;
  try {
    const updatedEmployee = await Employee.findByIdAndUpdate(id, updatedData, { new: true });
    res.json(updatedEmployee);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.insertEmployee = async (req, res) => {
  const newEmployee = new Employee(req.body);
  try {
    await newEmployee.save();
    res.status(201).json(newEmployee);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.validateUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const employee = await Employee.findOne({ email, password });
    res.json({ valid: !!employee });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getUserByEmail = async (req, res) => {
  const { email } = req.params;
  try {
    const employee = await Employee.findOne({ email:email });
    res.json(employee);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};