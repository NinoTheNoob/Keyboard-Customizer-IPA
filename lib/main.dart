import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const KaomojiApp());
}

const _ink = Color(0xFF17152C);
const _muted = Color(0xFFAAA7C2);
const _accent = Color(0xFFC5A6FF);

class KaomojiApp extends StatefulWidget {
  const KaomojiApp({super.key});

  @override
  State<KaomojiApp> createState() => _KaomojiAppState();
}

class _KaomojiAppState extends State<KaomojiApp> {
  int _selectedTab = 0;
  int _selectedTheme = 0;
  final _inputController = TextEditingController(text: 'hello world');
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static const _themes = <_KeyboardTheme>[
    _KeyboardTheme(
      name: 'Dreamscape',
      colors: [Color(0xFF29213F), Color(0xFF17152C)],
      accent: Color(0xFFC5A6FF),
    ),
    _KeyboardTheme(
      name: 'Ocean',
      colors: [Color(0xFF12384C), Color(0xFF142435)],
      accent: Color(0xFF7DE3E0),
    ),
    _KeyboardTheme(
      name: 'Rose',
      colors: [Color(0xFF4B273D), Color(0xFF241729)],
      accent: Color(0xFFFFA9C9),
    ),
    _KeyboardTheme(
      name: 'Matcha',
      colors: [Color(0xFF34433A), Color(0xFF1D2A27)],
      accent: Color(0xFFB8E0A5),
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _notify(String message) {
    _scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF342E4B),
        ),
      );
  }

  Future<void> _copy(String value, {String message = 'Copied to clipboard'}) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    HapticFeedback.selectionClick();
    _notify(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_selectedTheme];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _ink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: theme.accent,
          brightness: Brightness.dark,
          surface: const Color(0xFF211E38),
        ),
        useMaterial3: true,
        fontFamily: 'System',
      ),
      home: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.colors,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                _AppHeader(accent: theme.accent),
                _TabBar(
                  selectedIndex: _selectedTab,
                  accent: theme.accent,
                  onSelected: (index) => setState(() => _selectedTab = index),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildTab(theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(_KeyboardTheme theme) {
    switch (_selectedTab) {
      case 1:
        return _FontsTab(
          key: const ValueKey('fonts'),
          controller: _inputController,
          accent: theme.accent,
          onCopy: (text) => _copy(text, message: 'Styled text copied'),
        );
      case 2:
        return _BackgroundsTab(
          key: const ValueKey('backgrounds'),
          themes: _themes,
          selectedIndex: _selectedTheme,
          onSelected: (index) => setState(() => _selectedTheme = index),
        );
      default:
        return _KaomojiTab(
          key: const ValueKey('kaomojis'),
          accent: theme.accent,
          onCopy: (text) => _copy(text, message: '$text copied'),
        );
    }
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withValues(alpha: 0.25)),
            ),
            child: Icon(Icons.keyboard_alt_rounded, color: accent),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'little quest',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.6),
                ),
                SizedBox(height: 2),
                Text('YOUR KEYBOARD, YOUR MOOD', style: TextStyle(color: _muted, fontSize: 10, letterSpacing: 1.5)),
              ],
            ),
          ),
          Icon(Icons.auto_awesome, color: accent, size: 20),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selectedIndex,
    required this.accent,
    required this.onSelected,
  });

  final int selectedIndex;
  final Color accent;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Kaomojis', 'Fonts', 'Backgrounds'];
    const icons = [Icons.sentiment_satisfied_alt_rounded, Icons.text_fields_rounded, Icons.palette_outlined];
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF11101F).withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = selectedIndex == index;
            return Expanded(
              child: Semantics(
                selected: selected,
                button: true,
                child: GestureDetector(
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
                    decoration: BoxDecoration(
                      color: selected ? accent.withValues(alpha: 0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icons[index], size: 16, color: selected ? accent : _muted),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            labels[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected ? Colors.white : _muted,
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _KaomojiTab extends StatelessWidget {
  const _KaomojiTab({super.key, required this.accent, required this.onCopy});

  final Color accent;
  final ValueChanged<String> onCopy;

  static const _groups = <String, List<String>>{
    'Happy': ['(˶ᵔ ᵕ ᵔ˶)', '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', '٩(ˊᗜˋ*)و', '(๑˃ᴗ˂)ﻭ', 'ヽ(・∀・)ﾉ', '(*≧ω≦)', 'ദ്ദി(˵ •̀ ᴗ - ˵ ) ✧', 'ꉂ(ˊᗜˋ*)', '♡(˃͈ દ ˂͈ ༶ )'],
    'Love': ['(˘͈ᵕ ˘͈♡)', '(っ˘з(˘⌣˘ )', '♡(｡- ω -)', '( ˘ ³˘)♥', '(´｡• ᵕ •｡`) ♡', '(*♡∀♡)', '♡(˃͈ દ ˂͈ ༶ )', 'ღゝ◡╹)ノ♡', '(♡μ_μ)'],
    'Cute': ['૮₍ ˶ᵔ ᵕ ᵔ˶ ₎ა', '૮₍ ˃ ⤙ ˂ ₎ა', 'ʕ•ᴥ•ʔ', '(ᵕ—ᴗ—)', 'ฅ^•ﻌ•^ฅ', '૮꒰ ˶• ༝ •˶꒱ა', '(｡•́‿•̀｡)', 'ʕっ•ᴥ•ʔっ', '₍^. .^₎⟆'],
    'Sad': ['(╥﹏╥)', '(っ- ‸ - ς)', '(｡•́︿•̀｡)', '(ಥ﹏ಥ)', '(つ﹏<。)', '(╯︵╰,)', '(っ˕ -｡)', '｡°(°.◜ᯅ◝°)°｡', '(ノ_<。)'],
    'Excited': ['(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧', '₍₍ (ง ˙ω˙)ว ⁾⁾', 'ヽ(o＾▽＾o)ノ', '＼(≧▽≦)／', 'ヾ(＾∇＾)', '♪(┌・。・)┌', '٩(◕‿◕｡)۶', '☆*:.｡.o(≧▽≦)o.｡.:*☆', 'ᕕ( ᐛ )ᕗ'],
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('kaomoji-list'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      children: [
        const _SectionHeading(title: 'Pick your feeling', subtitle: 'Tap a kaomoji to copy it instantly'),
        const SizedBox(height: 17),
        for (final group in _groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(group.key.toUpperCase(), style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.6)),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 550 ? 4 : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: group.value.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 9,
                  childAspectRatio: count == 3 ? 1.1 : 1.15,
                ),
                itemBuilder: (context, index) {
                  final kaomoji = group.value[index];
                  return _GlassCard(
                    onTap: () => onCopy(kaomoji),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(kaomoji, style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 21),
        ],
        _InstallKeyboardHint(accent: accent),
      ],
    );
  }
}

class _FontsTab extends StatefulWidget {
  const _FontsTab({
    super.key,
    required this.controller,
    required this.accent,
    required this.onCopy,
  });

  final TextEditingController controller;
  final Color accent;
  final ValueChanged<String> onCopy;

  @override
  State<_FontsTab> createState() => _FontsTabState();
}

class _FontsTabState extends State<_FontsTab> {
  int _selectedStyle = 0;

  static const _styles = [
    ('Bold', _FontStyleType.bold),
    ('Italic', _FontStyleType.italic),
    ('Script', _FontStyleType.script),
    ('Double', _FontStyleType.doubleStruck),
    ('Small caps', _FontStyleType.smallCaps),
    ('Fullwidth', _FontStyleType.fullwidth),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final styled = _transform(widget.controller.text, _styles[_selectedStyle].$2);
        return ListView(
          key: const PageStorageKey('fonts-list'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          children: [
            const _SectionHeading(title: 'Text, but make it ✨', subtitle: 'Type anything and preview your new style'),
            const SizedBox(height: 18),
            TextField(
              controller: widget.controller,
              maxLength: 100,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Type something lovely...',
                filled: true,
                fillColor: const Color(0xFF11101F).withValues(alpha: 0.5),
                prefixIcon: Icon(Icons.edit_rounded, color: widget.accent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                counterStyle: const TextStyle(color: _muted),
              ),
            ),
            const SizedBox(height: 7),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_styles.length, (index) {
                final selected = _selectedStyle == index;
                return ChoiceChip(
                  label: Text(_styles[index].$1),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: widget.accent.withValues(alpha: 0.28),
                  backgroundColor: const Color(0xFF211E38),
                  side: BorderSide(color: selected ? widget.accent.withValues(alpha: 0.6) : Colors.white12),
                  labelStyle: TextStyle(color: selected ? Colors.white : _muted, fontWeight: FontWeight.w600, fontSize: 12),
                  onSelected: (_) => setState(() => _selectedStyle = index),
                );
              }),
            ),
            const SizedBox(height: 18),
            _GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PREVIEW', style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                  const SizedBox(height: 16),
                  SelectableText(
                    styled.isEmpty ? 'Your styled text appears here' : styled,
                    style: TextStyle(fontSize: 23, height: 1.35, color: styled.isEmpty ? _muted : Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: styled.isEmpty ? null : () => widget.onCopy(styled),
              icon: const Icon(Icons.content_copy_rounded, size: 18),
              label: const Text('Copy styled text'),
              style: FilledButton.styleFrom(
                backgroundColor: widget.accent,
                foregroundColor: _ink,
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 11),
            const Text(
              'These styles use Unicode characters, so appearance depends on the app and device you paste into.',
              style: TextStyle(color: _muted, fontSize: 11, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

enum _FontStyleType { bold, italic, script, doubleStruck, smallCaps, fullwidth }

String _transform(String input, _FontStyleType style) {
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const boldUpper = '𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙';
  const boldLower = '𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳';
  const italicUpper = '𝐴𝐵𝐶𝐷𝐸𝐹𝐺𝐻𝐼𝐽𝐾𝐿𝑀𝑁𝑂𝑃𝑄𝑅𝑆𝑇𝑈𝑉𝑊𝑋𝑌𝑍';
  const italicLower = '𝑎𝑏𝑐𝑑𝑒𝑓𝑔ℎ𝑖𝑗𝑘𝑙𝑚𝑛𝑜𝑝𝑞𝑟𝑠𝑡𝑢𝑣𝑤𝑥𝑦𝑧';
  const scriptUpper = '𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩𝒪𝒫𝒬ℛ𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵';
  const scriptLower = '𝒶𝒷𝒸𝒹ℯ𝒻ℊ𝒽𝒾𝒿𝓀𝓁𝓂𝓃ℴ𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏';
  const doubleUpper = '𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ';
  const doubleLower = '𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫';
  const smallCaps = 'ABCDEFGHIJKLMNOPQRSTUVWXYZᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀꜱᴛᴜᴠᴡxʏᴢ';
  const sourceNumbers = '0123456789';
  const fullwidthNumbers = '０１２３４５６７８９';

  final styleUpper = switch (style) {
    _FontStyleType.bold => boldUpper,
    _FontStyleType.italic => italicUpper,
    _FontStyleType.script => scriptUpper,
    _FontStyleType.doubleStruck => doubleUpper,
    _FontStyleType.smallCaps => smallCaps.substring(26),
    _FontStyleType.fullwidth => upper,
  };
  final styleLower = switch (style) {
    _FontStyleType.bold => boldLower,
    _FontStyleType.italic => italicLower,
    _FontStyleType.script => scriptLower,
    _FontStyleType.doubleStruck => doubleLower,
    _FontStyleType.smallCaps => smallCaps.substring(26),
    _FontStyleType.fullwidth => lower,
  };

  return String.fromCharCodes(input.runes.map((rune) {
    final character = String.fromCharCode(rune);
    final upperIndex = upper.indexOf(character);
    if (upperIndex >= 0) {
      return style == _FontStyleType.fullwidth ? 0xFF21 + upperIndex : styleUpper.runes.elementAt(upperIndex);
    }
    final lowerIndex = lower.indexOf(character);
    if (lowerIndex >= 0) {
      return style == _FontStyleType.fullwidth ? 0xFF41 + lowerIndex : styleLower.runes.elementAt(lowerIndex);
    }
    final numberIndex = sourceNumbers.indexOf(character);
    if (numberIndex >= 0 && style == _FontStyleType.fullwidth) {
      return fullwidthNumbers.runes.elementAt(numberIndex);
    }
    if (character == ' ' && style == _FontStyleType.fullwidth) return 0x3000;
    return rune;
  }));
}

class _BackgroundsTab extends StatelessWidget {
  const _BackgroundsTab({
    super.key,
    required this.themes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_KeyboardTheme> themes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('backgrounds-list'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      children: [
        const _SectionHeading(title: 'Set the scene', subtitle: 'Choose a gradient for your keyboard'),
        const SizedBox(height: 20),
        for (var index = 0; index < themes.length; index++) ...[
          _ThemeCard(
            theme: themes[index],
            selected: selectedIndex == index,
            onTap: () => onSelected(index),
          ),
          const SizedBox(height: 13),
        ],
        const SizedBox(height: 9),
        const _InstallKeyboardHint(accent: _accent),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.theme, required this.selected, required this.onTap});

  final _KeyboardTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 105,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: theme.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? theme.accent : Colors.white.withValues(alpha: 0.11), width: selected ? 2 : 1),
            boxShadow: selected ? [BoxShadow(color: theme.accent.withValues(alpha: 0.17), blurRadius: 18, spreadRadius: 1)] : null,
          ),
          child: Row(
            children: [
              Icon(Icons.keyboard_alt_rounded, size: 35, color: theme.accent),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(theme.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Soft gradient · dreamy keys', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: theme.accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstallKeyboardHint extends StatelessWidget {
  const _InstallKeyboardHint({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF11101F).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: accent, size: 19),
          const SizedBox(width: 11),
          const Expanded(
            child: Text(
              'To use the iOS keyboard: install the signed app, then go to Settings → General → Keyboard → Keyboards → Add New Keyboard and choose Kaomoji Keyboard.',
              style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.onTap, this.padding = const EdgeInsets.all(10)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF211E38).withValues(alpha: 0.76),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _KeyboardTheme {
  const _KeyboardTheme({required this.name, required this.colors, required this.accent});

  final String name;
  final List<Color> colors;
  final Color accent;
}
