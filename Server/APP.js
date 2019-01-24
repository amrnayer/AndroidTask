const restify=require('restify');
const mongoose= require('mongoose');
const config= require ('./Config');


const server= restify.createServer();

// Middleware
server.use(restify.plugins.bodyParser());

server.listen(config.PORT,()=>{
    mongoose.connect(
        config.MONGODB_URI,
        {useNewUrlParser:true}
        );
});

const dp= mongoose.connection;
dp.on('error',(err)=>console.log(err));

dp.once('open',()=>{
    require('./routes/profiles')(server);
    console.log('server started on port '+config.PORT.toString());
});