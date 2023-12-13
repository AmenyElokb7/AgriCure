const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
const randomstring = require('randomstring');
const User = require('../models/user');

const signup = async (req, res) => {
  const { username, password, confirmPassword } = req.body;

  if (!username || !password || !confirmPassword) {
    return res.status(400).json({ success: false, message: 'All fields are required.' });
  }

  if (password !== confirmPassword) {
    return res.status(400).json({ success: false, message: 'Passwords do not match' });
  }
  const existingUser = await User.findOne({ username });

  if (existingUser) {
    return res.status(400).json({ success: false, message: 'Email already exists. Please use a different email.' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    let verificationToken = randomstring.generate({
      length: 32,
      charset: 'url-safe',
    });
    const user = new User({
      username,
      password: hashedPassword,
      verificationToken,
      isEmailVerified: false,
    });
    console.log(user);
    try {
      const result = await user.save();
      console.log('zzzzz', result);
    } catch (error) {
      console.log(error);
    }

    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'agricure.solution@gmail.com',
        pass: 'umme wric kmwh gnyw',
      },
    });

    const mailOptions = {
      from: 'agricure.solution@gmail.com',
      to: username,
      subject: 'Account Verification',
      text: `Please click on the link to verify your account: http://192.168.56.1:3000/verify?token=${verificationToken}`,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log('Error sending email:', error);
      } else {
        console.log('Email sent:', info.response);
      }
    });

    res.status(201).json({ success: true, message: 'User registered successfully. Check your email for verification.' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error registering user.' });
  }
};

const login = async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });

    if (user) {
      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (isPasswordValid) {
        if (user.isEmailVerified) {
          req.session.username = user.username;

          res.cookie('username', user.username, {
            httpOnly: true,
            secure: true,
            sameSite: 'strict',
            maxAge: 3600000,
          });

          res.json({ success: true, message: 'Login successful', data: { username: user.username } });
        } else {
          res.status(401).json({
            success: false,
            message: 'Email not verified. Please check your email for verification instructions.',
          });
        }
      } else {
        res.status(401).json({ success: false, message: 'Invalid credentials' });
      }
    } else {
      res.status(401).json({ success: false, message: 'Invalid credentials' });
    }
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

const getLoggedInUser = async (req, res) => {
  console.log('zzzzzz', req.headers.auth);
  const username = req.headers.auth;
  console.log(username);
  if (!username) {
    return res.status(401).json({ success: false, message: 'Not authenticated' });
  }

  try {
    const user = await User.findOne({ username });

    if (user) {
      res.json({ success: true, data: { username } });
    } else {
      res.status(404).json({ success: false, message: 'User not found' });
    }
  } catch (error) {
    console.error('Error fetching user data:', error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};
const logout = (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      console.error('Error destroying session:', err);
      res.status(500).json({ success: false, message: 'Internal server error' });
    } else {
      res.json({ success: true, message: 'Logout successful' });
    }
  });
};
const verifyEmail = async (req, res) => {
  const { token } = req.query;
  try {
    const user = await User.findOne({ verificationToken: token });
    console.log(user, token);
    if (user) {
      await User.updateOne({ _id: user._id }, { $set: { isEmailVerified: true } });
      res.status(200).send('Email verification successful. You can now login.');
    } else {
      res.status(404).send('Invalid verification token.');
    }
  } catch (error) {
    console.error('Error during email verification:', error);
    res.status(500).send('Internal server error');
  }
};

module.exports = {
  signup,
  login,
  getLoggedInUser,
  logout,
  verifyEmail,
};
