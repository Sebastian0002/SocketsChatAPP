
const { response } = require('express');
const Message = require('../models/mesagge_schema')

const getChat = async(req, res = response) =>{

    const ownId = req.uid;
    const messagesFrom = req.params.from;

    const messages = await Message.find({
        $or: [{ from: ownId, to: messagesFrom}, {from: messagesFrom, to: ownId}]
    })
    .sort({createdAt : 'desc'})

    res.json({
        ok: true,
        messages
    })

}

module.exports = {
    getChat
}