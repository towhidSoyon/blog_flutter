import 'package:blog_app/feature/auth/presentation/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/feature/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if( state is AuthFailure){
      showSnackBar(context, state.message);
    } else if( state is AuthSuccess){
      Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route)=> false);
    }
  },
  builder: (context, state) {
    if (state is AuthLoading){
      return const Loader();
    }
    return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AuthField(hintText: "Email", controller: emailController),
              SizedBox(height: 15),
              AuthField(
                hintText: "Password",
                controller: passwordController,
                isObscureText: true,
              ),
              SizedBox(height: 20),
              AuthGradientButton(text: "Sign In", onPressed: () {
                if(formKey.currentState!.validate()){
                  context.read<AuthBloc>().add(AuthLogin(email: emailController.text.trim(),
                      password: passwordController.text.trim()));
                }
              }),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppPallete.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  },
),
      ),
    );
  }
}
