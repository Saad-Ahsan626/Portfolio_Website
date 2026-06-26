import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../providers/contact_form_provider.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/form_field_widget.dart';
import 'widgets/skill_tile.dart';

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  static const _toolkit = [
    (label: 'Flutter', icon: Icons.flutter_dash),
    (label: 'Dart', icon: Icons.code),
    (label: 'Python', icon: Icons.terminal),
    (label: 'Riverpod', icon: Icons.layers_outlined),
    (label: 'Firebase', icon: Icons.cloud_outlined),
    (label: 'Gemini API', icon: Icons.auto_awesome),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final horizontalPadding = isDesktop
        ? AppSpacing.xl
        : isMobile
            ? AppSpacing.md
            : AppSpacing.lg;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.containerMax),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── About Me split panel ─────────────────────────────
            _AboutPanel(isMobile: isMobile, isDesktop: isDesktop),

            const SizedBox(height: AppSpacing.xl),

            // ── Technical Toolkit ────────────────────────────────
            _ToolkitSection(isMobile: isMobile),

            const SizedBox(height: AppSpacing.xl),

            // ── Contact Form ─────────────────────────────────────
            _ContactForm(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About Me Panel
// ─────────────────────────────────────────────────────────────────────────────
class _AboutPanel extends StatelessWidget {
  const _AboutPanel({required this.isMobile, required this.isDesktop});

  final bool isMobile;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('About Me')
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.3, end: 0, duration: 400.ms),
        const SizedBox(height: AppSpacing.md),
        RichText(
          text: TextSpan(
            style: (isMobile
                    ? AppTypography.headlineLgMobile
                    : AppTypography.headlineLg)
                .copyWith(color: AppColors.onSurface),
            children: const [
              TextSpan(text: 'Architecting seamless mobile experiences with '),
              TextSpan(
                text: 'Flutter & AI',
                style: TextStyle(color: AppColors.electricCyan),
              ),
              TextSpan(text: '.'),
            ],
          ),
        ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: AppSpacing.md),
        Text(
          'I am a dedicated Flutter Developer and Computer Science student specializing in building high-performance, cross-platform applications. With a strong foundation in modern state management and an active interest in developing \'Agentic Apps\' powered by AI, I bridge the gap between complex backend logic and fluid user interactions. I am currently preparing for software engineering internships and am always open to discussing mobile product visions.',
          style:
              AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Download CV',
          icon: Icons.download_rounded,
          onPressed: () {},
        ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
      ],
    );

    final visualPanel = _WorkspaceVisual();

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textContent,
          const SizedBox(height: AppSpacing.lg),
          // Extra bottom + left padding to make room for the badge that
          // hangs -24px outside the Stack (clipBehavior: Clip.none).
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.md,
              left: AppSpacing.md,
            ),
            child: visualPanel,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: textContent),
        const SizedBox(width: AppSpacing.xl),
        // Same padding on desktop so the badge doesn't clip against the
        // containing Row's bounds.
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.md,
              left: AppSpacing.md,
            ),
            child: visualPanel,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Workspace visual (right panel with floating badge)
// ─────────────────────────────────────────────────────────────────────────────
class _WorkspaceVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main image placeholder (glass tinted)
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: AspectRatio(
            aspectRatio: 1,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: const Color(0x661E293B),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  child: Container(
                    color: AppColors.surfaceContainerLow,
                    child: Center(
                      child: Icon(
                        Icons.computer_rounded,
                        size: 100,
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(
            begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut),

        // Floating "Available" badge
        Positioned(
          bottom: -AppSpacing.md,
          left: -AppSpacing.md,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x661E293B),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pulsing dot
                    _PulsingDot(),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'AVAIL FOR PROJECTS',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms).slideY(
                begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut),
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(
            begin: 0.8, end: 1.2, duration: 800.ms, curve: Curves.easeInOut)
        .then()
        .fadeIn(begin: 0.5, duration: 800.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Technical Toolkit
// ─────────────────────────────────────────────────────────────────────────────
class _ToolkitSection extends StatelessWidget {
  const _ToolkitSection({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section divider header
        Row(
          children: [
            Text(
              'Technical Toolkit',
              style:
                  AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 6,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.0,
          ),
          itemCount: ContactSection._toolkit.length,
          itemBuilder: (context, index) {
            final item = ContactSection._toolkit[index];
            return SkillTile(
              label: item.label,
              icon: item.icon,
              delay: Duration(milliseconds: index * 80),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Form
// ─────────────────────────────────────────────────────────────────────────────
class _ContactForm extends ConsumerWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  _ContactForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(contactFormProvider);
    final notifier = ref.read(contactFormProvider.notifier);

    // Reset controllers when form resets after success
    ref.listen(contactFormProvider, (prev, next) {
      if (prev?.status == FormStatus.success &&
          next.status == FormStatus.idle) {
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    });

    final isMobile = Responsive.isMobile(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 920),
      child: Center(
        child: Column(
          children: [
            // Heading
            Text(
              "Let's Connect",
              style:
                  AppTypography.headlineLg.copyWith(color: AppColors.onSurface),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Have a vision for a mobile product? Reach out and let\'s discuss '
              'how we can build something exceptional together.',
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.lg),

            // Responsive layout: two-column on desktop, stacked on mobile
            isMobile
                ? Column(
                    children: [
                      // Name
                      FloatingLabelField(
                        label: 'NAME',
                        controller: _nameController,
                        onChanged: notifier.updateName,
                        errorText: formState.nameError,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Email
                      FloatingLabelField(
                        label: 'EMAIL',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: notifier.updateEmail,
                        errorText: formState.emailError,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Message
                      FloatingLabelField(
                        label: 'MESSAGE',
                        controller: _messageController,
                        maxLines: 4,
                        onChanged: notifier.updateMessage,
                        errorText: formState.messageError,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      _SubmitButton(formState: formState, notifier: notifier),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Name
                            FloatingLabelField(
                              label: 'NAME',
                              controller: _nameController,
                              onChanged: notifier.updateName,
                              errorText: formState.nameError,
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Email
                            FloatingLabelField(
                              label: 'EMAIL',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: notifier.updateEmail,
                              errorText: formState.emailError,
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            _SubmitButton(
                                formState: formState, notifier: notifier),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Message
                            FloatingLabelField(
                              label: 'MESSAGE',
                              controller: _messageController,
                              maxLines: 8,
                              onChanged: notifier.updateMessage,
                              errorText: formState.messageError,
                            ),

                            const SizedBox(height: AppSpacing.lg),

                            // Contact metadata / social links
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email',
                                  style: AppTypography.labelCaps.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  'your.email@domain.com',
                                  style: AppTypography.bodyMd
                                      .copyWith(color: AppColors.onSurface),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.formState, required this.notifier});

  final ContactFormState formState;
  final ContactFormNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final isSending = formState.status == FormStatus.sending;
    final isSuccess = formState.status == FormStatus.success;

    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color:
              isSuccess ? AppColors.secondaryContainer : AppColors.electricCyan,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: TextButton(
          onPressed: isSending || isSuccess ? null : notifier.submit,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSending) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'PROCESSING...',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
              ] else if (isSuccess) ...[
                const Icon(Icons.check_circle_outline,
                    size: 18, color: AppColors.onSurface),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'MESSAGE SENT',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ] else ...[
                Text(
                  'INITIATE TRANSMISSION',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.send_rounded,
                    size: 16, color: AppColors.onPrimaryFixed),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
