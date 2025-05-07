const Reservation = require('../models/Reservation');
const Room = require('../models/Room');

exports.getReservationsByCompany = async (req, res) => {
  const { companyName } = req.query;
  try {
    const reservations = await Reservation.find({ company: companyName })
      .populate('room_id', 'name');
    res.json(reservations);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


exports.deleteReservation = async (req, res) => {
    try {
      const reservationId = req.params.id; 
    const deletedReservation = await Reservation.findByIdAndDelete(reservationId);

    if (!deletedReservation) {
      return res.status(404).json({ message: 'Rezervasyon bulunamadı' });
    }
    res.status(200).json({ message: 'Rezervasyon silindi' });
  } catch (err) {
    console.error('Silme hatası:', err);
    res.status(500).json({ message: 'Silme işlemi sırasında hata oluştu', error: err });
  }
};

exports.checkReservationConflict = async (req, res) => {
  try {
    const { roomId, startTime, endTime } = req.body;

    if (!roomId || !startTime || !endTime) {
      return res.status(400).json({ error: 'Eksik veri: roomId, startTime ve endTime zorunludur.' });
    }

    const reservations = await Reservation.find({ room_id: roomId });

    const startDateTime1 = new Date(startTime);
    const endDateTime1 = new Date(endTime);

    for (const reservation of reservations) {
      const startDateTime2 = new Date(reservation.start_time);
      const endDateTime2 = new Date(reservation.end_time);

      const isOverlap =
        (startDateTime1 > startDateTime2 && startDateTime1 < endDateTime2) ||
        (endDateTime1 > startDateTime2 && endDateTime1 < endDateTime2) ||
        startDateTime1.getTime() === startDateTime2.getTime() ||
        endDateTime1.getTime() === endDateTime2.getTime() ||
        (startDateTime1 <= startDateTime2 && endDateTime1 >= endDateTime2);

      if (isOverlap) {
        return res.json({ conflict: true });
      }
    }

    return res.json({ conflict: false });
  } catch (err) {
    console.error('Çakışma kontrol hatası:', err);
    return res.status(500).json({ error: err.message });
  }
};


exports.isRoomAvailable = async (req, res) => {
  const { roomId, startTime, endTime } = req.body;
  try {
    const conflictingReservations = await Reservation.find({
      room_id: roomId,
      $or: [
        { start_time: { $lt: endTime }, end_time: { $gt: startTime } },
        { start_time: { $lt: startTime }, end_time: { $gt: endTime } },
      ],
    });

    res.json({ available: conflictingReservations.length === 0 });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


exports.addReservation = async (req, res) => {
  const { roomId, startTime, endTime, companyName, owner, content, department } = req.body;
  try {
    const reservation = new Reservation({
      room_id: roomId,
      company: companyName,
      booker: owner,
      contens: content,
      departmentid: department,
      start_time: startTime,
      end_time: endTime,
    });

    await reservation.save();
    res.status(201).json(reservation);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};