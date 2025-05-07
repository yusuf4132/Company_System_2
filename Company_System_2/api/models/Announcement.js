const mongoose = require('mongoose');
const Counter = require('./Counter');

const AnnouncementSchema = new mongoose.Schema({
  id: { type: Number, required: false, unique: true },
  announcer: { type: String, required: true },
  content: { type: String, required: true },
  company: { type: String, required: true },
  departmentid: { type: mongoose.Schema.Types.ObjectId, ref: 'Department', required: false,
  default: null },
});
AnnouncementSchema.pre('save', async function(next) {
  // Before adding the announcement, let's get the auto increment id
  if (this.isNew) {
    try {
      const counter = await Counter.findOneAndUpdate(
        { collectionName: 'announcement' },
        { $inc: { sequenceValue: 1 } },
        { new: true, upsert: true }
      );

      this.id = counter.sequenceValue;
      next();
    } catch (error) {
      next(error);
    }
  } else {
    next();  // If it's not new, there's no need to do anything
  }
});

module.exports = mongoose.model('Announcement', AnnouncementSchema);