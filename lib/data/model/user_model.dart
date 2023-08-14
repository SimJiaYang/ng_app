class UserModel {
  int? id;
  String? password;
  String? name;
  String? email;
  String? token;
  bool? result;

  UserModel(
      {this.id, this.password, this.name, this.email, this.token, this.result});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        password: json["password"],
        name: json["name"],
        email: json["email"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "name": name,
        "full_name": name,
        "token": token,
      };

  Map<String, dynamic> toRegisterJson() => {
        "password": password,
        "email": email,
        "name": name,
      };
}
