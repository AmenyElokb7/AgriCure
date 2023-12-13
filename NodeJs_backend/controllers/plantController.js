const Plant = require('../models/plant');

const savePlant = async (req, res) => {
    try {
      const { UserUsername, Image, Disease, Treatment } = req.body;
        const newPlant = new Plant({
        UserUsername,
        Image,
        Disease,
        Treatment,
      });
      const savedPlant = await newPlant.save();
      res.status(201).json(savedPlant);
    } catch (error) {
      console.error('Error saving plant:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  const getPlantsByUser = async (req, res) => {
    try {
      const { UserUsername } = req.params;
        const plants = await Plant.find({ UserUsername });
        res.status(200).json(plants);
    } catch (error) {
      console.error('Error fetching plants:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

module.exports = {
savePlant,
getPlantsByUser,

};
