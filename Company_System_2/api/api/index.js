const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');


const departmentRoutes = require('../routes/department');
const announcementRoutes = require('../routes/announcement');
const progressRoutes = require('../routes/progress');
const roomRoutes = require('../routes/room');
const jobRoutes = require('../routes/job');
const employeeRoutes = require('../routes/employee');
const reservationRoutes = require('../routes/reservation');

const app = express();
app.use(cors());
const port = 3000;

// Middleware
app.use(express.json());

// MongoDB connect
mongoose.connect('mongodb+srv://yusuf:4132@cluster0.pm67sq2.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
  .then(() => console.log("Connected to MongoDB"))
  .catch(err => console.log("MongoDB connection error", err));

//Mongodb save model
const Record = mongoose.model('Record', {
  title: String,
  content: String,
});
// Routes 
app.use('/api/departments', departmentRoutes);
app.use('/api/announcements', announcementRoutes);
app.use('/api/progress', progressRoutes);
app.use('/api/rooms', roomRoutes);
app.use('/api/jobs', jobRoutes);
app.use('/api/employees', employeeRoutes);
app.use('/api/reservations', reservationRoutes);

module.exports = app;