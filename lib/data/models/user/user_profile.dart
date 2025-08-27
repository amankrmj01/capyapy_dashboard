import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? jobTitle;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? website;
  final Map<String, String> socialLinks;

  const UserProfile({
    this.firstName,
    this.lastName,
    this.company,
    this.jobTitle,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
    this.website,
    this.socialLinks = const {},
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    company,
    jobTitle,
    bio,
    avatarUrl,
    phoneNumber,
    website,
    socialLinks,
  ];

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return '';
  }

  String get initials {
    String initials = '';
    if (firstName?.isNotEmpty == true) {
      initials += firstName![0].toUpperCase();
    }
    if (lastName?.isNotEmpty == true) {
      initials += lastName![0].toUpperCase();
    }
    return initials.isNotEmpty ? initials : '?';
  }

  Map<String, dynamic> toJson() => {
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (company != null) 'company': company,
    if (jobTitle != null) 'jobTitle': jobTitle,
    if (bio != null) 'bio': bio,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (website != null) 'website': website,
    'socialLinks': socialLinks,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    firstName: json['firstName'],
    lastName: json['lastName'],
    company: json['company'],
    jobTitle: json['jobTitle'],
    bio: json['bio'],
    avatarUrl: json['avatarUrl'],
    phoneNumber: json['phoneNumber'],
    website: json['website'],
    socialLinks: Map<String, String>.from(json['socialLinks'] ?? {}),
  );

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? bio,
    String? avatarUrl,
    String? phoneNumber,
    String? website,
    Map<String, String>? socialLinks,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}
