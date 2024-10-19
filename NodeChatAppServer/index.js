const express = require('express');
const cors = require('cors');
const path = require('path');
const bodyParser = require('body-parser');
require('dotenv').config();

// DB Config
require('./database/config').dbConnection();


// App de Express
const app = express();

app.use(cors());
app.use( express.json() );

const server = require('http').createServer(app);
module.exports.io = require('socket.io')(server);
require('./sockets/socket');



const publicPath = path.resolve( __dirname, 'public' );
// app.use(express.urlencoded({ extended: true, path: publicPath }));
app.use(bodyParser.urlencoded({extended : true}));
app.use( express.static( publicPath ));
app.use(express.json());

app.use( '/api/login', require('./routes/auth') );
app.use( '/api/users', require('./routes/users') );
app.use( '/api/messages', require('./routes/messages') );



server.listen( process.env.PORT, ( err ) => {

    if ( err ) throw new Error(err);
    console.log('Servidor corriendo en puerto', process.env.PORT );
});


