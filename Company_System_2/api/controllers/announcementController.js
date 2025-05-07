const Announcement = require('../models/Announcement');

exports.insertAnnouncement = async (req, res) => {
  try {
    const { announcer, content, company, departmentid } = req.body;

    // Verilerin kontrolü
    if (!announcer || !content || !company) {
      return res.status(400).json({ error: "Eksik veri gönderildi." });
    }

    const newAnnouncement = new Announcement({
      announcer,
      content,
      company,
      departmentid: departmentid ?? null,
    });

    const saved = await newAnnouncement.save();
    res.status(201).json(saved);
  } catch (err) {
    console.error('Insert Announcement Error:', err.message);
    res.status(500).json({ error: err.message });
  }
};

exports.updateAnnouncement = async (req, res) => {
  try {
    const updated = await Announcement.findByIdAndUpdate(
      req.params.id,
      {
        announcer: req.body.announcer,
        content: req.body.content
      },
      { new: true }
    );
    res.json(updated);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteAnnouncement = async (req, res) => {
  try {
    await Announcement.findByIdAndDelete(req.params.id);
    res.json({ message: 'Duyuru silindi.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAnnouncementsByCompany = async (req, res) => {
  try {
    const { companyName,dep_id  } = req.query;
    let filter = { company: companyName };
    if (dep_id !== undefined && dep_id!=="null") {
      filter.$or = [
        { departmentid: dep_id },
        { departmentid: null }
      ];
    }

    const announcements = await Announcement.find(filter);
    res.json(announcements);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};