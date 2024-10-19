const User = require('../models/usuario');
const Mesagge = require('../models/mesagge_schema');


const connectedUser = async( uuid = '' )=>{
    
    const user = await User.findById( uuid );
    user.online = true;
    await user.save();
    
    return user;
}

const disconnectedUser = async ( uuid = '' )=>{
    const user = await User.findById( uuid );
    user.online = false;
    await user.save();

    return user;
}
const saveMessage = async (payload) =>{
    try {
        const message = new Mesagge(payload);
        await message.save();
        
        console.log('save succes');

        return true
    } catch (err) {
        console.log(err);
        return false
    }
}


module.exports = {
    connectedUser,
    disconnectedUser,
    saveMessage
}

