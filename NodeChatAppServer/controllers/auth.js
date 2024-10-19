const { response } = require('express');
const bcrypt = require('bcryptjs');
const Usuario = require('../models/usuario');
const { generarJWT } = require('../helpers/jwt');
const { verifyGoogleIdToken } = require("../helpers/google_verify_token");
const { v4 : uuidV4 } = require('uuid')


const crearUsuario = async (req, res = response ) => {

    
    try {
        const { email, password } = req.body;
        const existeEmail = await Usuario.findOne({ email });
        if( existeEmail ) {
            return res.status(400).json({
                ok: false,
                msg: 'Email already register.'
            });
        }

        const user = new Usuario( req.body );

        const salt = bcrypt.genSaltSync();
        user.password = bcrypt.hashSync( password, salt );

        await user.save();

        const token = await generarJWT( user.id );

        res.status(200).json({
            ok: true,
            user,
            token
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({
            ok: false,
            msg: 'An error was ocurred.'
        });
    }
}

const login = async ( req, res = response ) => {

    
    try {
        const { email, password } = req.body;
        const dbUser = await Usuario.findOne({ email });
        if ( !dbUser ) {
            return res.status(404).json({
                ok: false,
                msg: 'Email not found'
            });
        }

        const validPassword = bcrypt.compareSync( password, dbUser.password );
        if ( !validPassword ) {
            return res.status(400).json({
                ok: false,
                msg: 'Invalid password'
            });
        }

        const token = await generarJWT( dbUser.id );

        res.json({
            ok: true,
            user: dbUser,
            token
        });


    } catch (error) {
        console.log(error);
        return res.status(500).json({
            ok: false,
            msg: 'An error was ocurred.'
        })
    }

}


const renewToken = async( req, res = response) => {

    const uid = req.uid;
    const token = await generarJWT( uid );
    const usuario = await Usuario.findById( uid );

    res.json({
        ok: true,
        usuario,
        token
    });

}

const googleAuthController = async (req, res = response) =>{

    try {
        //get token
        const token = req.body.token;

        if(!token){
            return res.status(400).json({
                ok: false,
                msg: "Token is mandatory"
            })
        }

        const googleUser = await verifyGoogleIdToken( token );

        if(!googleUser){
            return res.status(400).json({
                ok: false,
                msg: "User not verify"
            })
        }

        const dbUser = await Usuario.findOne({email:googleUser['email']});
        
        if(!dbUser){
            const user = new Usuario({
                online : false,
                nombre : googleUser['name'],
                email : googleUser['email'],
            })
            const salt = bcrypt.genSaltSync();
            user.password = bcrypt.hashSync( uuidV4(), salt );
            await user.save();
            const token = await generarJWT( user.id );

            return res.status(200).json({
                ok: true,
                user,
                token
            });
        }
        else{ 
            const token = await generarJWT( dbUser.id );
            return res.status(200).json({
                ok: true,
                user: dbUser,
                token
            });
        }

    } catch (error) {
        console.log(error);
        res.status(500).json({
            ok: false,
            msg: 'An error was ocurred.'
        });
    }
}


module.exports = {
    crearUsuario,
    login,
    renewToken,
    googleAuthController
}
