const mongoose = require('mongoose');

const ProgressSchema = new mongoose.Schema({
  task_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Job', required: true },
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Employee', required: true },
  company: { type: String, required: true },
  progress: { type: Number, required: true },
  registration_date: { type: String, required: true },
});

module.exports = mongoose.model('Progress', ProgressSchema);