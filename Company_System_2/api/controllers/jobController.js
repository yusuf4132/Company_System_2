const Job = require('../models/Job');
const Department = require('../models/Department');

exports.getJobs = async (req, res) => {
  const { companyName, depName } = req.query;

  try {
    if (depName!=="null") {
      const department = await Department.findOne({
        name: depName,
        company: companyName,
      });

      if (!department || depName==="null" || depName===null) {
        return res.status(404).json({ error: 'Departman bulunamadı' });
      }
      const jobs = await Job.find({
        company: companyName,
        department_id: department._id,
      });

      return res.json(jobs);
    } else {
      const jobs = await Job.find({ jobs_sirket: companyName });
      return res.json(jobs);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getJobsByCompany = async (req, res) => {
  const { companyName, role, id } = req.params;
  try {
    let jobs;
    if (role === 'admin') {
      jobs = await Job.find({ company: companyName });
    } else if (role === 'department_manager') {
      jobs = await Job.find({
        company: companyName,
        $or: [{ assigned_id: id }, { creator_id: id }],
      });
    } else if (role === 'staff') {
      jobs = await Job.find({
        company: companyName,
        assigned_id: id,
      });
    } else {
      jobs = [];
    }
    res.json(jobs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteJob = async (req, res) => {
  try {
    const { jobId } = req.params;
    await Job.findByIdAndDelete(jobId);
    res.json({ message: 'İş silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.insertJob = async (req, res) => {
  try {
    const newJob = new Job(req.body);
    const savedJob = await newJob.save();
    res.status(201).json(savedJob);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateJob = async (req, res) => {
  const { id } = req.params;
  try {
    const updatedJob = await Job.findByIdAndUpdate(id, req.body, { new: true });
    res.json(updatedJob);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getJobsByParentJobId = async (req, res) => {
  const { jobId } = req.params;
  try {
    const jobs = await Job.find({parentjob_id: jobId });
    res.json(jobs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateJobProgress = async (parentjobId, averageProgress) => {
  try {
    const updatedJob = await Job.findByIdAndUpdate(
      parentjobId,
      { progress: averageProgress },
      { new: true }
    );
    return updatedJob;
  } catch (err) {
    throw new Error(err.message); 
  }
};

exports.updateMainJobProgress = async (req, res) => {
  const { jobId, value } = req.body;
  try {
    await this.updateJobProgress(  jobId, value );

    const job = await Job.findById(jobId);
    const parentjobId = job.parentjob_id;

    const subJobs = await Job.find({ parentjob_id: parentjobId });
    let totalProgress = 0;
    subJobs.forEach(subJob => totalProgress += subJob.progress);

    const averageProgress = subJobs.length > 0 ? Math.floor(totalProgress / subJobs.length) : 0;

    await this.updateJobProgress(parentjobId, averageProgress );
    res.json({ message: 'İlerleme güncellendi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};