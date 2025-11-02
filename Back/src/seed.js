require('dotenv').config();
const { sequelize } = require('./config/db');
const { User } = require('./models');

(async () => {
  try {
    await sequelize.sync();
    // create support user if not exists
    const supportEmail = 'support@example.com';
    const clientEmail = 'client@example.com';

    const sup = await User.findOne({ where: { email: supportEmail } });
    if (!sup) {
      await User.create({ name: 'Support User', email: supportEmail, password: 'supportpass', role: 'SUPPORT' });
      console.log('Created support user: support@example.com / supportpass');
    }

    const cli = await User.findOne({ where: { email: clientEmail } });
    if (!cli) {
      await User.create({ name: 'Client User', email: clientEmail, password: 'clientpass', role: 'CLIENT' });
      console.log('Created client user: client@example.com / clientpass');
    }

    console.log('Seed finished');
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
})();