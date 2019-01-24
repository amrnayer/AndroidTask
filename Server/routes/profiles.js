const errors = require('restify-errors');
const Profile = require('../models/Profiles');
module.exports= server=> {
// get all profiles
     server.get('/profiles',async (req, res, next) => {
        try {
            const profiles = await Profile.find({});
            res.send(profiles);
            next();
        }catch (err)
        {
            return next(new errors.InvalidContentError(err));
        }
        });
    //Get Profile with email
    server.get('/profiles/:email',async (req, res, next) => {
        try {
            const profiles = await Profile.find({email:req.params.email});
            res.send(profiles);
            next();
        }catch (err)
        {
            return next(new errors.InvalidContentError(err));
        }
        });



    //get single profile
    server.get('/profiles/:email/:password',async (req, res, next) => {
        try {
            const Prof= await Profile.find({email:req.params.email,password: req.params.password});
            const emailV= await Profile.find({email:req.params.email});
            var vsize=Prof.toString().length;
            var esize=emailV.toString().length;
            if(vsize>0){
               res.send(200,{message:"Valid"});
               console.log(Prof);
               next();}
               else if(esize>0){
                res.send(404,{message:"wrong password"});

                next();



            }
            else {
                res.send(404,{message:"Wrong Email"});
                next();

            }
        }catch (err)
        {
            return next(new errors.InternalError("not ok man "));

        }

    });





    // Post Profile
    server.post('/profiles', async(req,res,next)=>{
        //check for json
        const {name,email,phonenumber,password}=req.body;
        const profiles = await Profile.find({email:email});
        const newP = new Profile({
            name: name,
            email: email,
            phonenumber: phonenumber,
            password: password
        });
       
        var s=profiles.toString().length;
        try{

            if(s==0) {
                const newprofile = await newP.save();
                res.send(201,{message:"Welcome"});
                next();
            }
            else {
                console.log(profiles);
                res.send(404,{message:"email is already exist"});
                next();

            }

        }catch (err) {
            return next(new errors.InternalError("not ok"));

        }






    });
//Update profile
    server.put('/profiles/:email', async(req,res,next)=>{
        //check for json
        


        try{
            const Updatedprofile=await Profile.findOneAndUpdate({email:req.params.email},req.body);
            res.send(200,{message:"Updated"});
            next();


        }catch (err) {
            return next(new errors.InternalError("not ok"));

        }






    });

};
