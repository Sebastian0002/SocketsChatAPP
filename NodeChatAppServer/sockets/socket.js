const { validateJWT } = require('../helpers/jwt');
const { io } = require('../index');
const { connectedUser, disconnectedUser, saveMessage} = require('../controllers/sockets');


// Mensajes de Sockets
io.on('connection', (client) => {
    console.log('New client');
    const {connection, uuid} = validateJWT(client.handshake.headers['x-token']);

    if(!connection){ return client.disconnect();}
    connectedUser(uuid);

    client.join(uuid);

    client.on('personal-message', async ( payload ) =>{
        await saveMessage(payload);
        io.to(payload.to).emit('personal-message', payload);
    });

    client.on('disconnect', () => {
        console.log('Client disconnected');
        disconnectedUser(uuid);
    });

});
