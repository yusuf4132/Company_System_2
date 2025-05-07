const mongoose = require('mongoose');
const Counter = require('./Counter');

const DepartmentSchema = new mongoose.Schema({
  id: { type: Number, required: false, unique: true },
  name: { type: String, required: true },
  company: { type: String, required: true },
});
DepartmentSchema.pre('save', async function(next) {
  if (this.isNew) {
    try {
      const counter = await Counter.findOneAndUpdate(
        { collectionName: 'department' },   
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

module.exports = mongoose.model('Department', DepartmentSchema);