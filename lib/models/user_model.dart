class UserModel {
  // atribut
  String? uid, name, username, email, userType;

  /* constructor object yang 
  bertujuan untuk menginisialisasi atribut 
  agar tidak bernilai NULL */
  UserModel(
    this.uid, this.name, this.username, this.email, this.userType
  );

  /*
    salah satu contoh fungsi 
    untuk mendapatkan data objek User
  */
  // factory UserModel.fromJson(Map<String, dynamic> data){
  //   return UserModel(
  //     username: data['user']['username'],
  //     email: data['user']['email'],
  //     password: data['user']['password'],
  //     profile: data['user']['profile'],
  //     userType: data['user']['user_type'],
  //     token: data['token'],
  //     loginType: data['user']['login_type'],
  //   );
  // }
  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'type': userType
    };
  }
}