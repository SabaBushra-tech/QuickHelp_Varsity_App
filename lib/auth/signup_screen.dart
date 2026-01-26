// import 'package:flutter/material.dart';
// import 'package:my_app/auth/signup_page.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool isPasswordHidden = true;
//   bool isButtonPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 const SizedBox(height: 40),

//                 // Logo & title
//                 Center(
//                   child: Column(
//                     children: const [
//                       Icon(Icons.school, size: 80, color:  Color.fromARGB(255, 45, 19, 131),),
//                       SizedBox(height: 10),
//                       Text(
//                         "LU SkillSwap",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         "Log in to start swapping skills.",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // Email
//                 const Text("Email", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
//                 const SizedBox(height: 6),
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: "student@university.edu",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 const Text(
//                   "Use your university email",
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),

//                 const SizedBox(height: 20),

//                 // Password
//                 const Text("Password",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
//                 const SizedBox(height: 6),
//                 TextField(
//                   obscureText: !isPasswordHidden,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         isPasswordHidden
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isPasswordHidden = !isPasswordHidden;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     "Forgot Password?",
//                     style: TextStyle(color:  Color.fromARGB(255, 45, 19, 131),),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // Login button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           isButtonPressed ?  Color.fromARGB(255, 49, 41, 97) :  Color.fromARGB(255, 134, 127, 179),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         isButtonPressed = true;
//                       });
//                     },
//                     child: const Text("Log in",style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255),),),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Sign up text
//                 Center(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Don't have an account? ",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                          MaterialPageRoute(builder: (context) =>  SignupPage()),


//                           );
//                         },
                        
                        
//                         child: const Text(
//                           "Sign up",
//                           style: TextStyle(
//                             color:  Color.fromARGB(255, 45, 19, 131),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:my_app/Home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<SignupScreen> {

final email =TextEditingController();
final password =TextEditingController();

bool loading =false;

final supabase = Supabase.instance.client;


//login function

SignupScreen() async{
  setState(() {
    loading =true;
  });
  try{
    final result = await supabase.auth.signUp(email: email.text, password: password.text);
    if(result.user != null && result.session !=null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder :(context) => HomePage()
        
        ),(context) => false);
    }

  } catch(e){
    print(e.toString());
  }
  finally{
    setState(() {
      loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signup_screen'),
      ),
      body:ListView(
        padding: EdgeInsets.all(15),
        children: [

          //email

          TextFormField(
            controller: email,
            decoration: InputDecoration(
              hintText: 'Email'
            ),
          ),
          SizedBox(height: 15,),

          //password

          TextFormField(
            controller: password,
            decoration: InputDecoration(
              hintText: 'password'
            ),
          ),

          SizedBox(height: 20),

          // button
          
          loading?  Center(child: CircularProgressIndicator()):

          ElevatedButton(
            onPressed: () {
              SignupScreen();
            },
            child: Text('Signup')
            ),


            //go to sigin_screen 

            SizedBox(height: 20),
            TextButton(
              onPressed: () {}, 
              child: Text('Already have an account? Login'),
              )
        ],
      ) ,
    );
  }
}