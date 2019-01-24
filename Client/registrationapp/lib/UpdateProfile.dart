import'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UpdateProfile.dart';
import 'dart:io';
import'LoginForm.dart';
class UpdateProfile extends StatefulWidget{
  UpdateProfile(this._email1,this._password1,this._name1,this._phonenumber1):super();
  final String  _email1;
  final String _password1;
  final String _phonenumber1;
  final String _name1;
  @override
  State createState()=>new UpdateProfileState();
}
class UpdateProfileState extends State<UpdateProfile> with SingleTickerProviderStateMixin{
  String Jsontostring(Map<String,dynamic> json){
    return json["message"];
  }
  var message=new TextEditingController();
  var pn_txc=new TextEditingController();
  var pass_txc=new TextEditingController();
  var name_txc=new TextEditingController();
  final FormKey= new GlobalKey<FormState>();
  String _phonenumber;
  String _password;
  String _name;
  //Animation related
  AnimationController _IconAc;
  Animation<double>_IconA;
  @override
  void initState(){
    setState(() {
      pn_txc.text=widget._phonenumber1;
      pass_txc.text=widget._password1;
      name_txc.text=widget._name1;
      message.text="";
    });

    super.initState();
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
    _IconAc.removeListener(()=>this.setState((){}));
    _IconAc.dispose();

  }
  
  GoBack(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _Update(){

    final form =FormKey.currentState;
    if (form.validate()) {
      form.save();
      PerformUpdate();
      print(message.text);

    }
  }
  PerformUpdate()async{
    String U="http://10.0.2.2:3000/profiles/"+widget._email1;
    http.Response res =await http.put(U,body:{"name":_name,"phonenumber":_phonenumber,"password":_password});
    final message1= Jsontostring(json.decode(res.body));

    setState(() {
      message.text=message1;
    });

  }

//Form related
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
appBar: AppBar(
  title: Text("Profile",textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 35.0),),
  centerTitle: true,
  backgroundColor:Colors.black,
  actions:
  <Widget>[
    CupertinoButton(
      child: Text("logout",style: TextStyle(color: CupertinoColors.destructiveRed),)
      ,onPressed:()=> Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()))
      ,)
  ],
  automaticallyImplyLeading: false,
),
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
                                fontSize: 15.0
                            )
                        )
                    ),

                    child: new Container(

                      child: Form(
                        key: FormKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(widget._email1,style: TextStyle(color: Colors.teal,fontSize: _IconAc.value*45)),
                            new TextFormField(

                            controller: pass_txc,
                              validator:(val)=>val.length<=0?'Insert Password':null,
                              onSaved: (val)=>_password=val,
                              decoration: new InputDecoration(
                                labelText: "Password",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              controller: name_txc,
                              validator:(val)=>val.length<=0?'Insert Password':null,
                              onSaved: (val)=>_name=val,
                              decoration: new InputDecoration(
                                labelText: "User Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              controller: pn_txc,
                              onSaved:(val)=>_phonenumber=val,
                              decoration: new InputDecoration(
                                labelText: "phone Number",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 20.0)),
                            new RaisedButton(
                              color:Colors.teal,
                              textColor: CupertinoColors.lightBackgroundGray,
                              child: Text("Update"),
                              splashColor: CupertinoColors.activeBlue,
                              onPressed: _Update,
                            ),
                            Text(message.text,style: TextStyle(color: Colors.green),)
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