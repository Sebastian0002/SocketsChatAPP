const { response } = require("express");
const User = require("../models/usuario");
const Request = require("../models/requests");

const getUsers = async (req,res = response)=>{

    const users = await User
        .find({ _id : { $ne : req.uid }})
        .sort('-online')

    return res.status(200).json({
        'ok': true,
        'msg': "users get",
        users
    });

}

const requestDeleteUser = async (req,res = response)=>{

    const {email} = req.body;
    const existUser = await User.findOne({ email });
    const existRequest = await Request.findOne({ email });
    if(!existUser) 
        return res.status(400).json({
            ok: false,
            msg: "DON'T_EXIST_USER"
    });
    
    if(existRequest) 
        return res.status(400).json({
            ok: false,
            msg: "REQUEST_ALREADY_CREATED"
    });

    const request = new Request( req.body );
    await request.save();

    return res.status(200).json({
        ok: true,
        request,
    });

}

module.exports = {
    getUsers,
    requestDeleteUser
}

