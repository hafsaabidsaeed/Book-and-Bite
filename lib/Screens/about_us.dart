
import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AboutUsScreen(),
//     );
//   }
// }

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Book & Bite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to Book & Bite, where innovation meets convenience in the heart of our university\'s campus dining experience.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Vision: ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'In a fast-paced academic environment, time is of the essence. That\'s why we\'ve developed a digital ecosystem that empowers you to take control of your dining and printing needs. Our vision is to create a technologically advanced platform that simplifies the entire process, from pre-booking your favorite meals to submitting files for printing – all at your fingertips.',

              ),
              SizedBox(height: 16),
              Text(
                'Enhancing Your Dining Experience: ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                  'Say goodbye to long lines and waiting times at the cafeteria. With Book & Bite, you have the power to pre-book your meals online. Browse through our diverse menu offerings, choose your favorites, and schedule a pickup time that aligns with your busy schedule. Whether it\'s a quick bite between classes or a leisurely lunch, our platform ensures your meal is ready for you, saving you time and hassle.'
              ),
              SizedBox(height: 16),
              Text(
                'Seamless Bookshop Services:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                  'We understand that academic resources are vital to your success. That\'s why we\'ve integrated a bookshop service into our platform. Need to print lecture notes or assignments? Our digital bookshop allows you to upload your files, specify your requirements, and make secure online payments. Receive automated notifications to stay updated on your order status, ensuring you never miss a beat in your academic journey.'
              ),
              SizedBox(height: 16),
              Text(
                'Embracing Technology, Empowering Efficiency:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                  'At Book & Bite, we\'re not just revolutionizing dining and printing – we\'re transforming campus life. Our user-friendly interface and intuitive features make navigating our platform a breeze. Whether you\'re accessing the website or using our accompanying mobile app, you\'ll experience the ease of managing your meals and academic resources like never before.'
                      'Join us on this exciting journey as we pave the way for a modern and technologically advanced campus experience. With Book & Byte, efficiency, convenience, and enhanced dining await you. Welcome to a future where your time matters, and your needs are at the forefront of innovation.'
              ),
              SizedBox(height:  18),
              Text(
                'Book & Bite – Where Your Campus Experience Comes to Life.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
