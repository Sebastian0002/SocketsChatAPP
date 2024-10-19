/*
    path: api/login

*/
const { Router } = require('express');
const { check } = require('express-validator');

const { crearUsuario, login, renewToken, googleAuthController} = require('../controllers/auth');
const { validarCampos } = require('../middlewares/validar-campos');
const { validarJWT } = require('../middlewares/validar-jwt');

const router = Router();

router.post('/new', [
    check('nombre','Name is required').not().isEmpty(),
    check('password','Password is required').not().isEmpty(),
    check('email','Email is required').isEmail(),
    validarCampos
], crearUsuario );

router.post('/', [
    check('password','Password is required').not().isEmpty(),
    check('email','Email is required').isEmail(),
], login );

router.get('/renew', validarJWT, renewToken );

router.post('/google', googleAuthController);

module.exports = router;
