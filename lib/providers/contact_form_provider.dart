import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

enum FormStatus { idle, sending, success, error }

class ContactFormState {
  const ContactFormState({
    this.name = '',
    this.email = '',
    this.message = '',
    this.nameError,
    this.emailError,
    this.messageError,
    this.status = FormStatus.idle,
  });

  final String name;
  final String email;
  final String message;
  final String? nameError;
  final String? emailError;
  final String? messageError;
  final FormStatus status;

  bool get isValid =>
      nameError == null &&
      emailError == null &&
      messageError == null &&
      name.isNotEmpty &&
      email.isNotEmpty &&
      message.isNotEmpty;

  ContactFormState copyWith({
    String? name,
    String? email,
    String? message,
    String? nameError,
    String? emailError,
    String? messageError,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearMessageError = false,
    FormStatus? status,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      messageError:
          clearMessageError ? null : messageError ?? this.messageError,
      status: status ?? this.status,
    );
  }
}

class ContactFormNotifier extends Notifier<ContactFormState> {
  @override
  ContactFormState build() => const ContactFormState();

  void updateName(String value) {
    state = state.copyWith(
      name: value,
      nameError: value.trim().isEmpty ? 'Name is required' : null,
      clearNameError: value.trim().isNotEmpty,
    );
  }

  void updateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    state = state.copyWith(
      email: value,
      emailError: value.trim().isEmpty
          ? 'Email is required'
          : !emailRegex.hasMatch(value)
              ? 'Enter a valid email'
              : null,
      clearEmailError: emailRegex.hasMatch(value),
    );
  }

  void updateMessage(String value) {
    state = state.copyWith(
      message: value,
      messageError: value.trim().length < 10
          ? 'Message must be at least 10 characters'
          : null,
      clearMessageError: value.trim().length >= 10,
    );
  }

  bool validate() {
    updateName(state.name);
    updateEmail(state.email);
    updateMessage(state.message);
    return state.isValid;
  }

  Future<void> submit() async {
    if (!validate()) return;

    state = state.copyWith(status: FormStatus.sending);

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_74naubi',
          'template_id': 'template_j85ul93',
          'user_id': 'mV0fgQffNiNd1ZP0K',
          'template_params': {
            'user_name': state.name,
            'user_email': state.email,
            'user_message': state.message,
          }
        }),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(status: FormStatus.success);
      } else {
        state = state.copyWith(status: FormStatus.error);
        debugPrint('EmailJS Error: ${response.body}');
      }
    } catch (e) {
      state = state.copyWith(status: FormStatus.error);
      debugPrint('Network Error: $e');
    }

    await Future.delayed(const Duration(seconds: 3));
    state = const ContactFormState();
  }
}

final contactFormProvider =
    NotifierProvider<ContactFormNotifier, ContactFormState>(
  ContactFormNotifier.new,
);
