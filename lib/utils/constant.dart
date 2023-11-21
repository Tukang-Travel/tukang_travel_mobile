import 'package:flutter/material.dart';

// const baseURL = 'http://127.0.0.1:8000/api';
const baseURL = 'http://10.0.2.2:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout'; 
const userURL = '$baseURL/user'; 
const userFeeds = '$baseURL/feeds';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const other = 'Something went wrong, try again!';


InputDecoration formInputDecoration(String hint, Icon icon) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    prefixIcon: icon,
    hintText: hint,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(128, 170, 188, 192),
        width: 1.0
      ),
      borderRadius: BorderRadius.circular(20)
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(128, 170, 188, 192),
      ),
      borderRadius: BorderRadius.circular(20)
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20)
    )
  );
}

Container authenticationOption(double w, double h, String auth) {
  return Container(
    width: w * 0.9,
    height: h * 0.07, // one third of the page
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: const DecorationImage(
        image: AssetImage(
          'asset/signup_login_page.jpg'
        ),
        fit: BoxFit.cover
      ),
    ),
    child: Center(
      child: Text(
        auth,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )
      ),
    ),
  );
}

Container primaryButton(double w, double h, String hint, DecorationImage img) {
  return Container(
    width: w * 0.9,
    height: h * 0.07, // one third of the page
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: img,
    ),
    child: 
      Center(
        child: Text(
          hint,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
      ),
  );

  
}