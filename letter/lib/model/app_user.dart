
class AppUser {
  final String userId;
  String eMail;
  String? username;
  String? phoneNumber;
  String? profileURL;

  AppUser(this.profileURL, this.phoneNumber, this.username,{required this.userId, required this.eMail});

  Map<String, dynamic> getUserMap() {
    return {
      'UserId' : userId,
      'UserEmail' : eMail,
      'Username' : username ?? '',
      'PhoneNumber' : phoneNumber ?? '',
      'UserProfile' : profileURL ?? ''
    };
  }

  AppUser.fromMap(Map<String, dynamic> map):
      userId = map['UserId'],
      eMail = map['UserEmail'],
      username = map['Username'],
      phoneNumber = map['PhoneNumber'],
      profileURL = map['UserProfile'];

  String get id => userId;

  @override
  String toString() {
    return """
    Id: $id,
    Name: $username
    E-mail: $eMail
    Phone number: $phoneNumber
    ProfileURL: $profileURL
    """;
  }

}
