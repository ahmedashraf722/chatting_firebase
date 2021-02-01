import 'dart:io';

import 'package:chat_firebase/image_picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String password,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool _isLoading;

  const AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _userName = "";
  File _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please add image..."),
        backgroundColor: Theme.of(context).errorColor,
      ));

      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _email.trim(),
        _userName.trim(),
        _password.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerUserName.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      key: ValueKey('user name'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (val) => _userName = val,
                      controller: _controllerUserName,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Please enter password at least 7 characters';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                    controller: _controllerPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    SizedBox(
                      width: 100,
                      height: 35,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _isLogin ? "Login" : "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        color: Colors.pinkAccent,
                        onPressed: _submit,
                      ),
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create new account"
                            : "I have already an account",
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
