class UserModel {
  // atribut
  int? id;
  String? username, email, password, profile, userType, token, loginType;

  /* constructor object yang 
  bertujuan untuk menginisialisasi atribut 
  agar tidak bernilai NULL */
  UserModel({
    this.id, this.username, this.email, 
    this.password, this.profile, this.userType, this.token, this.loginType
  });

  /*
    salah satu contoh fungsi 
    untuk mendapatkan data objek User
  */
  factory UserModel.fromJson(Map<String, dynamic> data){
    return UserModel(
      id: data['user']['id'],
      username: data['user']['username'],
      email: data['user']['email'],
      password: data['user']['password'],
      profile: data['user']['profile'],
      userType: data['user']['user_type'],
      token: data['token'],
      loginType: data['user']['login_type'],
    );
  }
}