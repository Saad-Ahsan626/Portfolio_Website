import 'package:flutter/material.dart';

/// Contact details and profile URLs, shared by the nav drawer, footers,
/// About and Contact so they can't drift apart.
class Links {
  Links._();

  static const String email = 'saadahsan039@gmail.com';
  static const String emailUrl = 'mailto:$email';
  static const String github = 'https://github.com/Saad-Ahsan626';
  static const String githubHandle = 'Saad-Ahsan626';
  static const String linkedin = 'https://www.linkedin.com/in/muhammad-saad-ahsan-55201336a/';
  static const String linkedinHandle = 'saad-ahsan';

  static const social = [
    (label: 'GitHub', icon: Icons.terminal, url: github),
    (label: 'LinkedIn', icon: Icons.link_rounded, url: linkedin),
    (label: 'Email', icon: Icons.mail_outline_rounded, url: emailUrl),
  ];
}
