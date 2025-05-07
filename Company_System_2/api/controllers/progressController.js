const Progress = require('../models/Progress');

exports.addProgress = async (req, res) => {
  try {
    const newProgress = new Progress(req.body);
    const saved = await newProgress.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getProgressByJobId = async (req, res) => {
  try {
    const { jobId } = req.params;
    const progresses = await Progress.find({ task_id: jobId });
    res.json(progresses);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};