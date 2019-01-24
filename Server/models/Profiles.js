const  mongoose= require('mongoose');
const  timestamp = require('mongoose-timestamp');

const ProfileSchema =new mongoose.Schema({
    name:{
        type :String,
        required:true,
        trim:true
    },
    email: {
        type: String,
        required: true,
        trim: true
    },
    phonenumber: {
        type: String,
        default:0,
    },
    password: {
        type: String,
        default:0,
    }
});

ProfileSchema.plugin(timestamp);

const Profile = mongoose.model('Profile',ProfileSchema);

module.exports= Profile;