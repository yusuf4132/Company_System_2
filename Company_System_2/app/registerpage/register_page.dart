import 'package:company_system_2/api/employeService.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPages extends StatefulWidget {
  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _genderController;
  final _companyNameController = TextEditingController();
  String _selectedRole = 'admin';
  late EmployeeService _employeeService = EmployeeService();

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      if (!_isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geçerli bir e-posta adresi girin!')),
        );
        return; // If the email is invalid, the registration will not continue.
      }
      try {
        // 1. Check if the company name is there
        final employeesWithSameCompany =
            await _employeeService.getEmployeesByCompany(
          _companyNameController.text,
        );

        if (employeesWithSameCompany.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bu şirket adı zaten kayıtlı!')),
          );
          return;
        }

        //2. Save the new employee to MongoDB
        final newEmployee = {
          'name': _nameController.text,
          'surname': _surnameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'gender': _genderController,
          'role': _selectedRole,
          'company': _companyNameController.text,
          'salary': null,
          'expertise': null,
          'department_id': null,
        };

        await _employeeService.insertEmployee(newEmployee);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarılı!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: E-posta zaten kayıtlı! $e')),
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
                'assets/company_system_backimage.jpg'),

            fit: BoxFit
                .cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text("Kayıt Ol",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Ad alanı boş olamaz' : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'Ad',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _surnameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Soyad alanı boş olamaz' : null,
                  decoration: InputDecoration(
                    filled: true, // Arka plan rengini aktif eder
                    fillColor: Colors.blue.shade100,
                    labelText: 'Soyad',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _phoneController,
                  validator: (value) =>
                      value!.isEmpty ? 'Telefon alanı boş olamaz' : null,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [phoneFormatter],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'Telefon Numarası',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
                    hintText: '+90 (555) 123-4567',
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
              SizedBox(height: 10),
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
              SizedBox(height: 10),
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
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Şifre tekrar alanı boş olamaz';
                    } else if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade100,
                    labelText: 'Şifre Tekrarı',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _companyNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Şirket Alanı Boş Bırakılamaz' : null,
                  decoration: InputDecoration(
                    filled: true, // Arka plan rengini aktif eder
                    fillColor: Colors.blue.shade100,
                    labelText: 'Şirket İsmi Girin',
                    labelStyle: TextStyle(color: Colors.black),
                    focusColor: Colors.white,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Cinsiyet Seçimi:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Radio<String>(
                        value: 'Erkek',
                        groupValue: _genderController,
                        onChanged: (value) {
                          setState(() {
                            _genderController = value;
                          });
                        },
                        activeColor:
                            Colors.white,
                        toggleable:
                            true,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        'Erkek',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio<String>(
                        value: 'Kadın',
                        groupValue: _genderController,
                        onChanged: (value) {
                          setState(() {
                            _genderController = value;
                          });
                        },
                        activeColor:
                            Colors.white, 
                        toggleable:
                            true,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        'Kadın',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var phoneFormatter = MaskTextInputFormatter(
    mask: '+90 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }
}
