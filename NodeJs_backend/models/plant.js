const mongoose = require('mongoose');

const plantSchema = new mongoose.Schema({
  UserUsername: {
    type: String,
    required: true,
  },
  Image: {
    type: String,
    required: true,
  },
  Disease: {
    type: String,
    required: false,
  },
  Treatment: {
    type: String,
    required: false,
  },
});

const Plant = mongoose.model('Plant', plantSchema);

module.exports = Plant;
