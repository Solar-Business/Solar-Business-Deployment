const { Sequelize } = require('sequelize');
const path = require('path');

const storage = path.resolve(__dirname, '../../database.sqlite');

const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage,
  logging: false
});

module.exports = { sequelize };