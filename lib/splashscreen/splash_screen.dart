import 'package:flutter/material.dart ';
import 'package:my_app/Home_page.dart';
import 'package:my_app/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final supabase = Supabase.instance.client;

nextscreen() async {
  await Future.delayed(Duration(seconds: 5));                //ai part ta login part dekaibo
  if (supabase.auth.currentSession ==null){                      //jokon user login login nai tokon aita kaj
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginScreen()
      
      ));
     
  }
  else{
     Navigator.pushReplacement(context, MaterialPageRoute(             //replashment use kori karon amra cai j backbutton na takuk jodi push ditam taile back button cole ashto tokon abck e jawar option cole asto
      builder: (context) => HomePage()
            ));
          }
       }

      void initState(){              //aita tokon kaj korbe jokon amra ai screen er upr takbo then aita theke uprer aita te  jabe then if else kaj korbe
        nextscreen();
        super.initState();
      }          



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              // Logo box
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 19, 131),
                  borderRadius: BorderRadius.circular(16),
                ),
                
                
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 60,
                ),
              ),

            const SizedBox(height: 25),

            const Text(
              "LU SkillSwap",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}










