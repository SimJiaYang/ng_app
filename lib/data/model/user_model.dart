class UserModel {
  int? id;
  String? username;
  String? password;
  String? fullName;
  String? email;
  String? token;
  bool? result;

  UserModel(
      {this.id,
      this.username,
      this.password,
      this.fullName,
      this.email,
      this.token,
      this.result});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
        email: json["email"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "name": fullName,
        "full_name": fullName,
        "token": token,
      };

  Map<String, dynamic> toRegisterJson() => {
        "password": password,
        "email": email,
      };
}
