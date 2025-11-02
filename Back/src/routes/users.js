const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { authenticate } = require('../middleware/authMiddleware');

router.use(authenticate);

router.get('/', userController.list);
router.post('/', userController.create);
router.get('/:id', userController.get);
router.put('/:id', userController.update);
router.delete('/:id', userController.remove);

module.exports = router;