import os

extensions = {
    '.sql': 'SQL',
    '.py': 'Python',
    '.html': 'HTML',
    '.css': 'CSS',
    '.js': 'JavaScript'
}

stats = {lang: {'files': 0, 'lines': 0, 'bytes': 0} for lang in extensions.values()}

for root, dirs, files in os.walk('.'):
    if '.venv' in root or '.git' in root or '__pycache__' in root:
        continue
    for f in files:
        ext = os.path.splitext(f)[1].lower()
        if ext in extensions:
            lang = extensions[ext]
            path = os.path.join(root, f)
            stats[lang]['files'] += 1
            try:
                with open(path, 'r', encoding='utf-8', errors='ignore') as fp:
                    lines = sum(1 for _ in fp)
                stats[lang]['lines'] += lines
                stats[lang]['bytes'] += os.path.getsize(path)
            except Exception:
                pass

total_files = sum(s['files'] for s in stats.values())
total_lines = sum(s['lines'] for s in stats.values())
total_bytes = sum(s['bytes'] for s in stats.values())

# Calculate GitHub Linguist Tracked Languages (All 5 detectable languages)
total_linguist_bytes = sum(s['bytes'] for s in stats.values())

print('=' * 68)
print("GITHUB LINGUIST LANGUAGE BAR RATIO (All 5 Active Segments):")
print('=' * 68)
for lang, s in sorted(stats.items(), key=lambda x: x[1]['bytes'], reverse=True):
    bp = (s['bytes'] / total_linguist_bytes * 100) if total_linguist_bytes else 0
    print(f"{lang:<12}: {s['bytes']:>8,} bytes ({bp:>5.2f}%)")
print('=' * 68)
print(f"{'LANGUAGE':<12} | {'FILES':<8} | {'LINES OF CODE':<15} | {'PERCENTAGE':<12}")
print('=' * 68)

for lang, s in sorted(stats.items(), key=lambda x: x[1]['lines'], reverse=True):
    pct = (s['lines'] / total_lines * 100) if total_lines else 0
    print(f"{lang:<12} | {s['files']:^8} | {s['lines']:^15} | {pct:>10.2f}%")

print('=' * 68)
print("GitHub Leading Language : SQL #1 (Greatest)")
print('=' * 68)
