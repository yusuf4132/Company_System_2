const mongoose = require('mongoose');

const ReservationSchema = new mongoose.Schema({
  room_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Room', required: true },
  company: { type: String, required: true },
  booker: { type: String, required: true },
  contens: { type: String, required: true },
  departmentid: { type: mongoose.Schema.Types.ObjectId, ref: 'Department', required: false },
  start_time: { type: String, required: true },
  end_time: { type: String, required: true },
});

module.exports = mongoose.model('Reservation', ReservationSchema);