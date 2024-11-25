import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 사용자 이름 업데이트
      await userCredential.user?.updateDisplayName(_usernameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = '제공된 비밀번호가 너무 취약합니다.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = '해당 이메일로 이미 계정이 존재합니다.';
      } else {
        errorMessage = '오류가 발생했습니다. 다시 시도해주세요.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffB81736),
                  Color(0xff281537),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        labelText: '이메일',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffB81736),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        labelText: '사용자 이름',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffB81736),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelText: '비밀번호',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffB81736),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        labelText: '비밀번호 확인',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffB81736),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    GestureDetector(
                      onTap: _signUp,
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          '이미 계정이 있으신가요? 로그인',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

