const mongoose = require('mongoose');
const Counter = require('./Counter');

const EmployeeSchema = new mongoose.Schema({
  id: { type: Number, required: false, unique: true },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  phone: { type: String, required: true },
  company: { type: String, required: true },
  salary: { type: Number, required: false },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  gender: { type: String, required: true },
  role: { type: String, enum: ['admin', 'department_manager', 'staff'], required: true },
  department_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Department' },
  expertise: { type: String, required: false },
});
EmployeeSchema.pre('save', async function(next) {
  if (this.isNew) {
    try {
      const counter = await Counter.findOneAndUpdate(
        { collectionName: 'employee' },   
        { $inc: { sequenceValue: 1 } },      
        { new: true, upsert: true }        
      );

      this.id = counter.sequenceValue; 
      next();  
    } catch (error) {
      next(error);  
    }
  } else {
    next(); 
  }
});

module.exports = mongoose.model('Employee', EmployeeSchema);