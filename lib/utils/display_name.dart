import 'package:firebase_auth/firebase_auth.dart';

/// Görünen ad: önce [User.displayName], yoksa e-posta yerel kısmından türetilir.
String displayNameFromUser(User user) {
  final dn = user.displayName?.trim();
  if (dn != null && dn.isNotEmpty) return dn;
  final email = user.email;
  if (email != null && email.contains('@')) {
    final local = email.split('@').first.trim();
    if (local.isEmpty) return 'Kullanıcı';
    return _titleCase(local.replaceAll(RegExp(r'[._-]+'), ' '));
  }
  return 'Kullanıcı';
}

String _titleCase(String s) {
  return s.split(RegExp(r'\s+')).map((w) {
    if (w.isEmpty) return w;
    return w[0].toUpperCase() + w.substring(1).toLowerCase();
  }).join(' ');
}
