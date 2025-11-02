const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const defineUser = require('./user');

const User = defineUser(sequelize, DataTypes);

module.exports = {
  sequelize,
  User
};