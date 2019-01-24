import'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UpdateProfile.dart';
import 'dart:io';
class Signup extends StatefulWidget{
  @override
  State createState()=>new SignUpState();
}
class SignUpState extends State<Signup> with SingleTickerProviderStateMixin{
  String _email,_password,_name,_phonenumber;
  final FormKey= new GlobalKey<FormState>();
  String Jsontostring(Map<String,dynamic> json){
    return json["message"];
  }
  var message=new TextEditingController();
  _Signup(){
    final form =FormKey.currentState;
    if (form.validate()) {
      form.save();
      performsignup();
      print(message.text);

    }


  }

  performsignup()async{
    String U="http://10.0.2.2:3000/profiles";

    http.Response res =await http.post(U,body:{"name":_name,"phonenumber":_phonenumber,"password":_password,"email":_email.toLowerCase()});
    final message1= Jsontostring(json.decode(res.body));
    setState(() {
      message.text=message1;
    });
    if(message.text=="Welcome"){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UpdateProfile(_email,_password,_name,_phonenumber)));
    }

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: new Text("Registration",style: TextStyle(color: Colors.teal,fontSize: 35.0)),backgroundColor: Colors.black,centerTitle: true,),

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
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Form(
                        key: FormKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(message.text,style: TextStyle(color: Colors.red)),
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
                            new TextFormField(
                              onSaved:(val)=>_name=val,

                              decoration: new InputDecoration(
                                labelText: "Name",
                              ),
                              keyboardType: TextInputType.text,

                            ),
                            new TextFormField(
                                onSaved:(val)=>_phonenumber=val,
                              decoration: new InputDecoration(
                                labelText: "Phone Number",
                              ),
                              keyboardType: TextInputType.text
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 20.0)),
                            new RaisedButton(
                              color:Colors.teal,
                              textColor: CupertinoColors.lightBackgroundGray,
                              child: Text("SignUp"),
                              onPressed: _Signup,
                              splashColor: CupertinoColors.activeBlue,
                            ),
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