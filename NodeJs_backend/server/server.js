const express = require('express');
const https = require('https');
const fs = require('fs');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const session = require('express-session');
const cors = require('cors');
const multer = require('multer');
const crypto = require('crypto');
const cookieParser = require('cookie-parser');
const userController = require('../controllers/userController');
const plantController = require('../controllers/plantController');

const app = express();
const port = 3000;

const privateKey = fs.readFileSync('key.pem', 'utf8');
const certificate = fs.readFileSync('cert.pem', 'utf8');
const credentials = { key: privateKey, cert: certificate };
const server = https.createServer(credentials, app);

app.use(cors({
  credentials: true,
}));
app.use(cookieParser());

app.use(
  session({
    secret: crypto.randomBytes(32).toString('hex'),
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true },
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json());
mongoose.connect('mongodb://127.0.0.1:27017/Agricure', { useNewUrlParser: true, useUnifiedTopology: true });

app.post('/signup', userController.signup);
app.post('/login', userController.login);
app.get('/get-logged-in-user', userController.getLoggedInUser);
app.post('/logout', userController.logout);
app.get('/verify', userController.verifyEmail);
app.post('/save-plant', plantController.savePlant);
app.get('/plants/:UserUsername', plantController.getPlantsByUser);


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
