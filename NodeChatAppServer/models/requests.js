const { Schema, model } = require('mongoose');

const RequestSchema = Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    reason: {
        type: String,
        default: 'not specify'
    },
});

module.exports = model('Request', RequestSchema);