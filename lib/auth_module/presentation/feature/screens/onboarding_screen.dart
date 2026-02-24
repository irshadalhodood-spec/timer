import 'package:employee_track/base_module/presentation/components/custom_button/button.dart';
import 'package:employee_track/base_module/presentation/components/padding/app_padding.dart';
import 'package:employee_track/base_module/presentation/util/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/presentation/components/custom_text_form_field/custom_text_form_field.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/curve_bottom_clipper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _urlController.text = AppConstants.dummyInviteUrl;
    _usernameController.text = AppConstants.dummyUsername;
    _passwordController.text = AppConstants.dummyPassword;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        if (state is AuthStateFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              SingleChildScrollView(
                physics: const RangeMaintainingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Center(child: _buildCard(context)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.smallCornerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    translation.of('login.organization_setup'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  AppPadding(),
                  Text(
                    translation.of('login.invite_organization_url'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  AppPadding(),
                  _buildInput(
                    controller: _urlController,
                    hint: translation.of('login.invite_url_hint'),
                    keyboardType: TextInputType.url,
                    validator: (value) => Validate.value(value),
                  ),

                  AppPadding(),
                  _buildOrDivider(context),
                  const SizedBox(height: 24),
                  Text(
                    translation.of('login.title'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  AppPadding(),
                  _buildInput(
                    controller: _usernameController,
                    hint: translation.of('login.username'),
                    keyboardType: TextInputType.name,
                    validator: (value) => Validate.value(value),
                  ),
                  AppPadding(),
                  _buildInput(
                    controller: _passwordController,
                    hint: translation.of('login.password'),
                    obscureText: _obscurePassword,
                    validator: (value) => Validate.value(value),
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  AppPadding(),
                  PrimaryButton(
                        onTap: () async {
                          await _pasteUrl();
                          _submitUrl();
                          _submitLogin();
                        },
                        text: translation.of('login.login_button'),
                        isLoading: context.watch<AuthBloc>().isLoading
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return CustomTextFormField(
      controller: controller,
      hintText: hint,
      textInputType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      validator: validator,
      suffix: suffix,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderDecoration: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            translation.of('login.and'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
      ],
    );
  }

  void _submitUrl() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    context.read<AuthBloc>().add(AuthOrganizationUrlSubmitted(url: url));
  }

  Future<void> _pasteUrl() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text != null && text.isNotEmpty) {
      _urlController.text = text;
    }
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      AuthLoginRequested(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }
}
