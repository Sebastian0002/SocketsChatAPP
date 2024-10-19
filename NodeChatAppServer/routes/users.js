/*
    path: api/users

*/
const { Router } = require('express');
const { check } = require('express-validator');

const { validarJWT } = require('../middlewares/validar-jwt');
const { getUsers, requestDeleteUser } = require('../controllers/users');
const { validarCampos } = require('../middlewares/validar-campos');

const router = Router();

router.get('/', validarJWT, getUsers);

router.post('/request-delete', [
    check('name','Name is required').not().isEmpty(),
    check('email','Email is required').not().isEmpty(),
    validarCampos
], requestDeleteUser);

module.exports = router;
