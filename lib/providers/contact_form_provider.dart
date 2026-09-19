import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

enum FormStatus { idle, sending, success, error, throttled }

class ContactFormState {
  const ContactFormState({
    this.name = '',
    this.email = '',
    this.message = '',
    this.nameError,
    this.emailError,
    this.messageError,
    this.showErrors = false,
    this.status = FormStatus.idle,
  });

  final String name;
  final String email;
  final String message;
  final String? nameError;
  final String? emailError;
  final String? messageError;

  /// Errors stay hidden until the first submit, then update live.
  final bool showErrors;
  final FormStatus status;

  bool get isValid =>
      nameError == null &&
      emailError == null &&
      messageError == null &&
      name.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      message.trim().isNotEmpty;

  /// Drives the "n/3 FIELDS" counter in the form header.
  int get filledCount => [name, email, message]
      .where((value) => value.trim().isNotEmpty)
      .length;

  ContactFormState copyWith({
    String? name,
    String? email,
    String? message,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? messageError,
    bool? showErrors,
    FormStatus? status,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      nameError: nameError != null ? nameError() : this.nameError,
      emailError: emailError != null ? emailError() : this.emailError,
      messageError: messageError != null ? messageError() : this.messageError,
      showErrors: showErrors ?? this.showErrors,
      status: status ?? this.status,
    );
  }
}

class ContactFormNotifier extends Notifier<ContactFormState> {
  static const maxNameLength = 100;
  static const maxEmailLength = 254;
  static const maxMessageLength = 5000;
  static const minMessageLength = 10;

  /// Minimum gap between two sends from the same visitor session.
  static const sendCooldown = Duration(seconds: 60);

  /// Contact API on the site's own origin. It only exists on Cloudflare Pages
  /// (or `npx wrangler pages dev`), not under `flutter run`.
  static const contactEndpoint = '/api/contact';

  static final _emailRegex = RegExp(r'^[\w\-\.+]+@([\w\-]+\.)+[A-Za-z]{2,}$');

  DateTime? _lastSentAt;

  @override
  ContactFormState build() => const ContactFormState();

  static String? validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Enter your name';
    if (trimmed.length > maxNameLength) return 'Name is too long';
    return null;
  }

  static String? validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Enter your email';
    if (trimmed.length > maxEmailLength || !_emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email, like you@company.com';
    }
    return null;
  }

  static String? validateMessage(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Enter a message';
    if (trimmed.length < minMessageLength) {
      return 'Add a little more detail (at least $minMessageLength characters)';
    }
    if (trimmed.length > maxMessageLength) return 'Message is too long';
    return null;
  }

  void updateName(String value) {
    state = state.copyWith(
      name: value,
      nameError: state.showErrors ? () => validateName(value) : null,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(
      email: value,
      emailError: state.showErrors ? () => validateEmail(value) : null,
    );
  }

  void updateMessage(String value) {
    state = state.copyWith(
      message: value,
      messageError: state.showErrors ? () => validateMessage(value) : null,
    );
  }

  bool validate() {
    state = state.copyWith(
      showErrors: true,
      nameError: () => validateName(state.name),
      emailError: () => validateEmail(state.email),
      messageError: () => validateMessage(state.message),
    );
    return state.isValid;
  }

  Future<void> submit() async {
    if (state.status != FormStatus.idle) return;
    if (!validate()) return;

    final lastSentAt = _lastSentAt;
    if (lastSentAt != null &&
        DateTime.now().difference(lastSentAt) < sendCooldown) {
      state = state.copyWith(status: FormStatus.throttled);
      await Future.delayed(const Duration(seconds: 4));
      state = state.copyWith(status: FormStatus.idle);
      return;
    }

    state = state.copyWith(status: FormStatus.sending);

    try {
      // Same-origin Cloudflare Pages Function (functions/api/contact.js),
      // which holds the Brevo key and sends the email.
      final response = await http.post(
        Uri.base.resolve(contactEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': state.name.trim(),
          'email': state.email.trim(),
          'message': state.message.trim(),
        }),
      );

      if (response.statusCode == 200) {
        _lastSentAt = DateTime.now();
        state = state.copyWith(status: FormStatus.success);
      } else {
        state = state.copyWith(status: FormStatus.error);
        if (kDebugMode) {
          debugPrint('Contact endpoint ${response.statusCode}: ${response.body}');
        }
      }
    } catch (e) {
      state = state.copyWith(status: FormStatus.error);
      if (kDebugMode) debugPrint('Contact request failed: $e');
    }

    final failed = state.status == FormStatus.error;
    await Future.delayed(const Duration(seconds: 3));
    if (failed) {
      // Keep the visitor's text so they can simply retry.
      state = state.copyWith(status: FormStatus.idle);
    } else {
      state = const ContactFormState();
    }
  }
}

final contactFormProvider =
    NotifierProvider<ContactFormNotifier, ContactFormState>(
  ContactFormNotifier.new,
);
