const jwt = require('jsonwebtoken');


const generarJWT = ( uid ) => {

    return new Promise( (resolve, reject) => {

        const payload = { uid };

        jwt.sign( payload, process.env.JWT_KEY, {
            expiresIn: '12h'
        }, ( err, token ) => {

            if ( err ) {
                // no se pudo crear el token
                reject('Cannot create a JWT');

            } else {
                // TOKEN!
                resolve( token );
            }

        })
    });
}

const validateJWT = (token = '') => {
    try {

        const { uid } = jwt.verify( token, process.env.JWT_KEY );
        return {
            'connection' : true,
            'uuid' : uid
        }

    } catch (_) {
        return { 
            'connection' : false,
            'uuid': undefined
        }
    }
}


module.exports = {
    generarJWT,
    validateJWT
}