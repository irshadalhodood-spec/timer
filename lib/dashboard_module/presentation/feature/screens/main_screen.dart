import 'package:employee_track/base_module/presentation/util/locale_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../auth_module/presentation/feature/bloc/auth_bloc.dart';
import '../../../../base_module/domain/entities/app_theme_singleton.dart';
import '../../../../base_module/domain/entities/translation.dart';
import '../../../../base_module/domain/repositories/sync_queue_repository.dart';
import '../../../../base_module/presentation/core/values/app_constants.dart';
import '../../../../base_module/presentation/feature/network/blocs/network_bloc.dart';
import '../../../../base_module/presentation/feature/theming/bloc/theme_bloc.dart';
import '../../../../base_module/presentation/feature/translation/bloc/translation_bloc.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../../../../employee_track/presentation/feature/screens/analytics_tab_screen.dart';
import 'home_screen.dart';
import '../../../../organization_module/presentation/feature/screens/organization_tab_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPendingCount();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Iconsax.timer, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, networkState) {
              final isOnline = networkState == const NetworkState.online();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOnline ? Icons.cloud_done : Icons.cloud_off,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    if (_pendingCount > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LocaleDigitsText(
                          '$_pendingCount ${translation.of('sync.pending_sync')}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                             
                                
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Iconsax.setting_2,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          AnalyticsTabScreen(),
          OrganizationTabScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) _loadPendingCount();
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home),
            label: translation.of('dashboard.home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.graph),
            label: translation.of('dashboard.analytics'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.people),
            label: translation.of('dashboard.employees'),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => BlocBuilder<TranslationBloc, TranslationState>(
        builder: (ctx, __) {
          final theme = Theme.of(ctx);
          final colorScheme = theme.colorScheme;
          final bottomPadding = MediaQuery.of(ctx).padding.bottom + 24;
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 16),
                    child: Text(
                      translation.of('settings.title'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SettingsSection(
                    title: translation.of('settings.theme'),
                    icon: Iconsax.sun_1,
                    child: BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (ctx, _) {
                        final current = appTheme.themeType;
                        return Column(
                          children: [
                            SettingsTile(
                              icon: Iconsax.sun_1,
                              label: translation.of('settings.theme_light'),
                              selected: current == ThemeType.light,
                              onTap: () {
                                ctx.read<ThemeBloc>().add(const ChangeTheme(themeType: ThemeType.light));
                              },
                            ),
                            SettingsTile(
                              icon: Iconsax.moon,
                              label: translation.of('settings.theme_dark'),
                              selected: current == ThemeType.dark,
                              onTap: () {
                                ctx.read<ThemeBloc>().add(const ChangeTheme(themeType: ThemeType.dark));
                              },
                            ),
                            SettingsTile(
                              icon: Iconsax.mobile,
                              label: translation.of('settings.theme_system'),
                              selected: current == ThemeType.system,
                              onTap: () {
                                ctx.read<ThemeBloc>().add(const ChangeTheme(themeType: ThemeType.system));
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SettingsSection(
                    title: translation.of('settings.language'),
                    icon: Iconsax.global,
                    child: BlocBuilder<TranslationBloc, TranslationState>(
                      builder: (ctx, _) {
                        final current = translation.selectedLocale?.languageCode ?? 'en';
                        return Column(
                          children: [
                            SettingsTile(
                              icon: Iconsax.global,
                              label: translation.of('settings.language_en'),
                              selected: current == 'en',
                              onTap: () {
                                ctx.read<TranslationBloc>().add(const ChangeLanguage(language: 'en', save: true));
                              },
                            ),
                            SettingsTile(
                              icon: Iconsax.global,
                              label: translation.of('settings.language_ar'),
                              selected: current == 'ar',
                              onTap: () {
                                ctx.read<TranslationBloc>().add(const ChangeLanguage(language: 'ar', save: true));
                              },
                            ),
                            
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(ctx);
                        ctx.read<AuthBloc>().add(AuthLogoutRequested());
                        Navigator.of(ctx, rootNavigator: true).pushNamedAndRemoveUntil(
                          '/onboarding',
                          (_) => false,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                        child: Row(
                          children: [
                            Icon(Iconsax.logout, color: colorScheme.error, size: 24),
                            const SizedBox(width: 16),
                            Text(
                              translation.of('login.logout'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadPendingCount() async {
    if (!mounted) return;
    final repo = context.read<SyncQueueRepository>();
    final count = await repo.pendingCount();
    if (mounted) setState(() => _pendingCount = count);
  }
}
