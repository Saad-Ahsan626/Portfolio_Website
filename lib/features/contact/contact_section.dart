import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/links.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../providers/contact_form_provider.dart';
import '../../shared/widgets/hover_link.dart';
import '../../shared/widgets/pulsing_dot.dart';
import '../../shared/widgets/reveal_on_scroll.dart';
import '../../shared/widgets/section_container.dart';
import 'widgets/contact_field.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionContainer(
      child: RevealOnScroll(id: 'contact', child: _ContactFrame()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bordered two-panel frame: statement + channels | form
// ─────────────────────────────────────────────────────────────────────────────
class _ContactFrame extends StatelessWidget {
  const _ContactFrame();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // Foreground, so the form panel's fill can't cover the frame.
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Design grid: auto-fit minmax(340px, 1fr).
          final twoColumns = constraints.maxWidth >= 340 * 2;
          final panelWidth =
              twoColumns ? (constraints.maxWidth - 1) / 2 : constraints.maxWidth;
          // Name/email sit side by side when the form's inner width fits two
          // minmax(200px) tracks. Decided here because LayoutBuilder can't be
          // used inside IntrinsicHeight.
          final innerWidth =
              panelWidth - _panelPadding(context).horizontal - 2;
          final sideBySide = innerWidth >= 200 * 2 + 26;

          if (!twoColumns) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Statement(stretch: false, innerWidth: innerWidth),
                const Divider(height: 1, thickness: 1, color: AppColors.outlineVariant),
                _ContactForm(stretch: false, sideBySide: sideBySide),
              ],
            );
          }
          // Both panels share the taller one's height, so the channel list
          // and the submit row can sit on the bottom edge. IntrinsicHeight's
          // estimate can land a few pixels short of real layout, so each panel
          // takes up that slack in a flexible gap instead of overflowing.
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Statement(stretch: true, innerWidth: innerWidth),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.outlineVariant),
                Expanded(child: _ContactForm(stretch: true, sideBySide: sideBySide)),
              ],
            ),
          );
        },
      ),
    );
  }
}

EdgeInsets _panelPadding(BuildContext context) =>
    EdgeInsets.all(Responsive.fluid(context, min: 28, vw: 4, max: 56));

class _Statement extends StatelessWidget {
  const _Statement({required this.stretch, required this.innerWidth});

  final bool stretch;

  /// Content width inside the panel padding.
  final double innerWidth;

  static const double _paragraphMaxWidth = 420;

  @override
  Widget build(BuildContext context) {
    final gap = Responsive.fluid(context, min: 28, vw: 4, max: 48);
    final headlineStyle = AppTypography.headlineLg.copyWith(
      fontSize: Responsive.fluid(context, min: 56, vw: 7.5, max: 112),
      height: 0.92,
      letterSpacing: -0.02 * 112,
      color: AppColors.onSurface,
    );

    return Padding(
      padding: _panelPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PulsingDot(color: AppColors.accent),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'OPEN TO FREELANCE & COLLABORATION',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: gap),
          Text.rich(
            TextSpan(
              style: headlineStyle,
              children: const [
                TextSpan(text: 'LET\'S\n'),
                TextSpan(
                  text: 'CONNECT',
                  style: TextStyle(color: AppColors.accent),
                ),
              ],
            ),
          ),
          SizedBox(height: gap),
          // Width capped with padding rather than ConstrainedBox: a max-width
          // constraint is ignored when IntrinsicHeight measures the text, which
          // would under-count its lines.
          Padding(
            padding: EdgeInsets.only(
              right: math.max(0, innerWidth - _paragraphMaxWidth),
            ),
            child: Text(
              'Have a product in mind, whether it\'s a mobile app, a backend or '
              'both? Reach out and let\'s discuss how we can build something '
              'exceptional together.',
              style: AppTypography.bodyLg.copyWith(
                fontSize: Responsive.fluid(context, min: 17, vw: 1.4, max: 20),
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          // Tight flexible gap: at least `gap` when measured, it grows to pin
          // the channels to the bottom and can shrink if the estimate is short.
          if (stretch)
            Expanded(child: SizedBox(height: gap))
          else
            SizedBox(height: gap),
          const _Channels(),
        ],
      ),
    );
  }
}

class _Channels extends StatelessWidget {
  const _Channels();

  static const _channels = [
    (label: 'Email', value: Links.email, url: Links.emailUrl),
    (label: 'GitHub', value: Links.githubHandle, url: Links.github),
    (label: 'LinkedIn', value: Links.linkedinHandle, url: Links.linkedin),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        children: [
          for (final (index, channel) in _channels.indexed)
            HoverLink(
              onTap: () => launchUrl(Uri.parse(channel.url)),
              semanticLabel: '${channel.label}: ${channel.value}',
              builder: (context, color, hovered) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  top: 18,
                  bottom: 18,
                  left: hovered ? 8 : 0,
                ),
                decoration: BoxDecoration(
                  border: index < _channels.length - 1
                      ? const Border(
                          bottom: BorderSide(color: AppColors.outlineVariant),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Text(
                      channel.label.toUpperCase(),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: channel.value),
                            TextSpan(
                              text: '  ↗',
                              style: AppTypography.codeSm.copyWith(color: color),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                        style: AppTypography.bodyMd.copyWith(color: color, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form panel
// ─────────────────────────────────────────────────────────────────────────────
class _ContactForm extends ConsumerStatefulWidget {
  const _ContactForm({required this.stretch, required this.sideBySide});

  final bool stretch;
  final bool sideBySide;

  @override
  ConsumerState<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<_ContactForm> {
  // Controllers live in State so rebuilds (e.g. window resize crossing a
  // breakpoint) never wipe the visitor's typed text.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(contactFormProvider);
    final notifier = ref.read(contactFormProvider.notifier);

    // Clear the inputs once a sent message resets the form.
    ref.listen(contactFormProvider, (prev, next) {
      if (prev?.status == FormStatus.success &&
          next.status == FormStatus.idle) {
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    });

    final nameField = ContactField(
      label: 'Name',
      placeholder: 'Your name',
      controller: _nameController,
      onChanged: notifier.updateName,
      errorText: formState.nameError,
      maxLength: ContactFormNotifier.maxNameLength,
      autofillHints: const [AutofillHints.name],
      textInputAction: TextInputAction.next,
    );
    final emailField = ContactField(
      label: 'Email',
      placeholder: 'you@company.com',
      controller: _emailController,
      onChanged: notifier.updateEmail,
      errorText: formState.emailError,
      maxLength: ContactFormNotifier.maxEmailLength,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
    );

    return Container(
      color: AppColors.panel,
      padding: _panelPadding(context),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SEND A MESSAGE',
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                Text(
                  '${formState.filledCount}/3 FIELDS',
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 26),
            if (widget.sideBySide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: nameField),
                  const SizedBox(width: 26),
                  Expanded(child: emailField),
                ],
              )
            else ...[
              nameField,
              const SizedBox(height: 26),
              emailField,
            ],
            const SizedBox(height: 26),
            ContactField(
              label: 'Message',
              placeholder: 'Tell me about the product you have in mind',
              controller: _messageController,
              onChanged: notifier.updateMessage,
              errorText: formState.messageError,
              maxLength: ContactFormNotifier.maxMessageLength,
              lines: 6,
            ),
            if (widget.stretch)
              const Expanded(child: SizedBox(height: 26))
            else
              const SizedBox(height: 26),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                Text(
                  _hint(formState.status),
                  style: AppTypography.labelSm.copyWith(
                    color: formState.status == FormStatus.error
                        ? AppColors.error
                        : AppColors.onSurfaceVariant,
                    letterSpacing: 0.14 * 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _SubmitButton(
                  status: formState.status,
                  onPressed: notifier.submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _hint(FormStatus status) => switch (status) {
        FormStatus.success => 'I usually reply within 24 hours.',
        FormStatus.error => 'Couldn\'t send. Check your connection and try again.',
        FormStatus.throttled => 'Message already sent. Please wait a minute.',
        FormStatus.sending || FormStatus.idle => 'All fields required.',
      };
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.status, required this.onPressed});

  final FormStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      FormStatus.sending => 'Transmitting...',
      FormStatus.success => 'Message sent',
      FormStatus.error => 'Transmission failed',
      FormStatus.throttled => 'Please wait',
      FormStatus.idle => 'Initiate transmission',
    };
    final isIdle = status == FormStatus.idle;
    final isSuccess = status == FormStatus.success;

    return ElevatedButton(
      // Disabled while a send is in flight or a result is showing.
      onPressed: isIdle ? onPressed : () {},
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        foregroundColor: const WidgetStatePropertyAll(AppColors.onAccent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (isSuccess) return AppColors.onSurface;
          if (status == FormStatus.error) return AppColors.error;
          if (isIdle &&
              (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused))) {
            return AppColors.onSurface;
          }
          return AppColors.accent;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        mouseCursor: WidgetStatePropertyAll(
          isIdle ? SystemMouseCursors.click : SystemMouseCursors.basic,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == FormStatus.sending) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.onAccent,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(label.toUpperCase(), style: AppTypography.labelCaps),
          const SizedBox(width: 14),
          Text('→', style: AppTypography.labelCaps.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
