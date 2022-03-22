import 'package:crud_lp/models/database_model.dart';
import 'package:crud_lp/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();

    bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final _auth = ref.watch(authenticationProvider);
          Future<void> _onPressedFunction() async {
            if (!_formKey.currentState!.validate()) {
              return;
            }

             loading();
            await _auth
                .signInWithEmailAndPassword(
                    _email.text.toString(), _password.text.toString(), context)
                .whenComplete(() => _auth.authStateChange.listen((event) async {

                      if (event == null) {
                         loading();
                       return;
                      }

                    }));


          }

          Future<void> _loginWithGoogle() async {
              loading();
            await _auth
                .signInWithGoogle(context)
                .whenComplete(() => _auth.authStateChange.listen((event) async {
                      if (event == null) {
                        loading();
                        return;
                      }
                    }));
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Center(child:
                         Container(
                             height: MediaQuery.of(context).size.height/5,
                             width: MediaQuery.of(context).size.height/6,
                             child:Image.asset('assets/images/icon.png'))),
                        const Spacer(flex: 1),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: _email,
                            autocorrect: true,
                            enableSuggestions: true,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Email address',
                              hintStyle: const TextStyle(color: Colors.black54),
                              icon: Icon(Icons.email_outlined,
                                  color: Colors.blue.shade700, size: 24),
                              alignLabelWithHint: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: _password,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.black54),
                              icon: Icon(CupertinoIcons.lock_circle,
                                  color: Colors.blue.shade700, size: 24),
                              alignLabelWithHint: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:_isLoading
                      ? const Center(
                      child: CircularProgressIndicator())
                      : Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 32.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child: MaterialButton(
                                    onPressed: _onPressedFunction,
                                    child: const Text(
                                      'Log in',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    textColor: Colors.blue.shade700,
                                    textTheme: ButtonTextTheme.primary,
                                    minWidth: 100,
                                    padding: const EdgeInsets.all(18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          color: Colors.blue.shade700),
                                    ),
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 32.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child:
                            MaterialButton(
                              onPressed: _loginWithGoogle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [

                                  FaIcon(FontAwesomeIcons.google),
                                  Text(
                                    ' Login with Google',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              textColor: Colors.blue.shade700,
                              textTheme: ButtonTextTheme.primary,
                              minWidth: 100,
                              padding: const EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: Colors.blue.shade700),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      )),
                )
              ],
            ),
          );
        }),
      ),
    );
  }


  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}
