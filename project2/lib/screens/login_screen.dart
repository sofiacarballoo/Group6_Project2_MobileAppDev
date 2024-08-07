import 'package:flutter/material.dart';
import 'package:project2/resources/auth_methods.dart';
import 'package:project2/responsive/mobile_screen_layout.dart';
import 'package:project2/responsive/responsive_layout.dart';
import 'package:project2/responsive/web_screen_layout.dart';
import 'package:project2/screens/signup_screen.dart';
import 'package:project2/utils/colors.dart';
import 'package:project2/utils/utils.dart';
import 'package:project2/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key ? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text, 
      password: _passwordController.text
    );

    if(res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );

    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex:2 ),
              Image.asset(
                'assets/logo.png', 
                height:64,
              ),
              const SizedBox(height:64),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height:24),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(height:24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading 
                    ? const Center(
                      child: SizedBox(
                        width: 15.0, // Adjust the size as needed
                        height: 15.0, // Adjust the size as needed
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                        ),
                    ) 
                    : const Text(
                    'Log in',
                    style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical:12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4)
                      ),
                    ),
                    color: blueColor
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(child: Container(), flex:2 ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      "Dont't have an account?",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: const Text(
                        " Sign up.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
