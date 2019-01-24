import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UpdateProfile.dart';
import 'Signup.dart';
class LoginPage extends StatefulWidget{
  @override
  State createState()=>new LoginPageState();
}
class Profile {
  String phonenumber;
  String password;
  String name;
  String email;
  Profile(var json){
    this.email=json["email"];
    this.name= json["name"];
    this.password=json["password"];
    this.phonenumber=json["phonenumber"];
  }
}




class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  Profile P;
  final TextC=new TextEditingController();
  final FormKey= new GlobalKey<FormState>();
  String _email;
  String _password;
  //Animation related
  AnimationController _IconAc;
  Animation<double>_IconA;
  @override
  void initState(){
    super.initState();
    setState(() {
      TextC.text="";
    });
    //Icon Animation States
    _IconAc=new AnimationController(
        vsync: this,
        duration: new Duration(microseconds: 500)
    );
    _IconA=new CurvedAnimation(
        parent: _IconAc,
        curve: Curves.easeOut
    );
    _IconA.addListener(()=>this.setState((){}));
    _IconAc.forward();
    //Text State controller

  }
//Print Server Response

  @override
  void dispose(){

    super.dispose();
    TextC.dispose();
    _IconAc.removeListener(()=>this.setState((){}));
    _IconAc.dispose();

  }
  _submit(){

    final form =FormKey.currentState;
      if (form.validate()) {
        form.save();
        performlogin();
        print(TextC.text);

      }






  }
//get message from server
  String Jsontostring(Map<String,dynamic> json){
    return json["message"];
  }
//check for email and password in our data
  performlogin()async{


    String U="http://10.0.2.2:3000/profiles/"+_email.toLowerCase()+"/"+_password.toString();
    http.Response res= await http.get(U);
      final message= Jsontostring(json.decode(res.body));
      setState(() {
        TextC.text=message;
      });

    if(TextC.text=="Valid") {
      String Uf="http://10.0.2.2:3000/profiles/"+_email.toString();
      http.Response res1= await http.get(Uf);
      P=new Profile(json.decode(res1.body)[0]);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UpdateProfile(P.email,P.password,P.name,P.phonenumber)));
      setState(() {
        TextC.text="";
      });
    }
  }
  gosignup(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Signup()));

  }


//Form related
    @override
    Widget build(BuildContext context) {
      return new Scaffold(
  appBar: AppBar(automaticallyImplyLeading: false, title: new Text("Login",style: TextStyle(color: Colors.teal,fontSize: 35.0)),backgroundColor: Colors.black,centerTitle: true,),

          backgroundColor: Colors.black,
          body:new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image(image: new AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                    color: Colors.black87,
                    colorBlendMode: BlendMode.darken
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Theme(
                      data: new ThemeData(
                          brightness: Brightness.dark
                          ,primarySwatch: Colors.teal,
                          inputDecorationTheme:new InputDecorationTheme(
                              labelStyle: new TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20.0
                              )
                          )
                      ),

                      child: new Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: FormKey,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(TextC.text,style: TextStyle(color: Colors.red),),
                              new TextFormField(
                                validator:(val)=>!val.contains('@')?'Wrong Email':null,
                                onSaved: (val)=>_email=val,
                                decoration: new InputDecoration(
                                  labelText: "Email",
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              new TextFormField(
                                validator:(val)=>val.length<=0?'Wrong Password':null,
                                onSaved:(val)=>_password=val,

                                decoration: new InputDecoration(
                                  labelText: "Password",
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                              ),
                              new Padding(padding: const EdgeInsets.only(top: 20.0)),
                              new RaisedButton(
                                color:Colors.teal,
                                textColor: CupertinoColors.lightBackgroundGray,
                                child: Text("Login"),
                                onPressed:_submit,
                                splashColor: CupertinoColors.activeBlue,
                              ),
                              new CupertinoButton(child: Text("SignUp here",style: TextStyle(color: Colors.tealAccent
                              ),), onPressed: gosignup)

                            ],
                          ),
                        ),
                      ),
                    ) ,
                  ],
                )
              ]
          )
      );
  }



}
