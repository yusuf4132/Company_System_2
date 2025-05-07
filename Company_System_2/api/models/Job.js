const mongoose = require('mongoose');
const Counter = require('./Counter');

const JobSchema = new mongoose.Schema({
  id: { type: Number, required: false, unique: true },
  subject: { type: String, required: true },
  explanation: { type: String, required: true },
  company: { type: String, required: true },
  creator_id: { type: mongoose.Schema.Types.ObjectId,ref: 'Employee', required: true },
  assigned_id: { type: mongoose.Schema.Types.ObjectId,ref: 'Employee', required: true },
  department_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Department', required: true },
  deadline: { type: String, required: true },
  parentjob_id: { type: mongoose.Schema.Types.ObjectId, default: null },
  progress: { type: Number, default: 0 },
  creation_date: { type: String, required: true },
});
JobSchema.pre('save', async function(next) {
  if (this.isNew) {
    try {
      const counter = await Counter.findOneAndUpdate(
        { collectionName: 'job' }, 
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

module.exports = mongoose.model('Job', JobSchema);