const Room = require('../models/Room');

exports.addRoom = async (req, res) => {
  const { name, contens,company } = req.body;
  const existingRoom = await Room.findOne({ name: name, company: company });
  if (existingRoom) {
    return res.status(400).json({ message: 'Departman zaten mevcut' });
  }
  try {
    const newRoom = new Room({
      name: name,
      contens: contens,
      company:company,
    });
    await newRoom.save();
    res.status(201).json(newRoom);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteRoom = async (req, res) => {
  try {
    await Room.findByIdAndDelete(req.params.id);
    res.json({ message: 'Oda silindi.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getRoomsByCompany = async (req, res) => {
  const { companyName } = req.query;
  try {
    const rooms = await Room.find({ company: companyName });
    if (rooms.length === 0) {
      return res.status(404).json({ message: 'Hiç oda bulunamadı' });
    }
    res.status(200).json(rooms);
  } catch (err) {
    res.status(500).json({message: 'oda alınırken bir hata oluştu', error: err.message });
  }
};

exports.checkIfRoomExists = async (req, res) => {
  try {
    const { roomName } = req.query;
    const room = await Room.findOne({ name: roomName });

    if (room) {
      res.json({ exists: true });
    } else {
      res.json({ exists: false });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};