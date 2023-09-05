// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_chatapp/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _login = true;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  File? _selectedImage;
  var authenticating = false;

  // void _submit() {
  //   final valid = _formKey.currentState!.validate();
  //   if (valid) {
  //     _formKey.currentState!.save();
  //     print(_enteredEmail);
  //     print(_enteredPassword);
  //   } else {
  //     print('LOG IN FAILED !!');
  //   }
  // }

  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    // if (!valid || !_login && _selectedImage == null) {
    //   return;
    // }

    _formKey.currentState!.save();
    try {
      setState(() {
        authenticating = true;
      });
      if (_login) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        // final storageRef = FirebaseStorage.instance
        //     .ref()
        //     .child('user_images')
        //     .child('${userCredentials.user!.uid}.jpg');
        // storageRef.putFile(_selectedImage!);
        // final imageUrl = await storageRef.getDownloadURL();
        // print(imageUrl);
      }
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? 'Authentication Failed!',
            ),
          ),
        );
      }
      setState(() {
        authenticating = false;
      });
    }
    // if (_login) {
    //   // log users in
    // } else {
    //   try {
    //     final userCredentials = await _firebase.createUserWithEmailAndPassword(
    //       email: _enteredEmail,
    //       password: _enteredPassword,
    //     );
    //     print(userCredentials);
    //   } on FirebaseAuthException catch (error) {
    //     // if (error.code == 'email-already-in-use') {
    //     //   //....
    //     // }
    //     if (context.mounted) {
    //       ScaffoldMessenger.of(context).clearSnackBars();
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             error.message ?? 'Authentication Failed!',
    //           ),
    //         ),
    //       );
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                // color: Colors.yellow,
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_login)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return ('Please enter a valid email');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return ('Password must not be less than 6 characters');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          // if (!_login)
                          //   TextFormField(
                          //     decoration: InputDecoration(
                          //       labelText: 'Username',
                          //       labelStyle: TextStyle(
                          //         color: Theme.of(context).colorScheme.primary,
                          //       ),
                          //     ),
                          //     obscureText: true,
                          //   ),
                          const SizedBox(height: 12),
                          if (authenticating) const CircularProgressIndicator(),
                          if (!authenticating)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                elevation: 1.5,
                              ),
                              onPressed: _submit,
                              child: Text(_login ? 'Log In' : 'Sign up'),
                            ),
                          if (!authenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _login = !_login;
                                });
                              },
                              child: Text(_login
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
