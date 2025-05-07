import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/registerpage/register_page.dart';
import 'package:flutter/material.dart';
import './frame.dart';

class LoginPages extends StatefulWidget {
  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late EmployeeService _employeeService = EmployeeService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      bool isValidUser = await _employeeService.validateUser(email, password);

      if (isValidUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Frames(
                    email: email,
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçersiz email veya şifre')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.blue
                  .withOpacity(0.5),
              BlendMode.luminosity,
            ),
            image: AssetImage(
                './assets/company_system_backimage.jpg'),
            fit: BoxFit
                .cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Giriş Yap",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24)),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? 'E-posta alanı boş olamaz' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'E-posta Adresi',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
                    hintText: 'example@domain.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value!.isEmpty ? 'Şifre alanı boş olamaz' : null,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'Şifre',
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Şifrenizi girin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => _login(),
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 40),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPages()),
                    );
                  },
                  child: Text(
                    "Hesabınız Yok Mu? Hemen Bir Şirket Hesabı Oluşturun",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
