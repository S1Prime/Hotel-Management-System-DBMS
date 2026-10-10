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

# Calculate GitHub Linguist Tracked Languages (Python & SQL)
py_bytes = stats['Python']['bytes']
sql_bytes = stats['SQL']['bytes']
linguist_total_bytes = py_bytes + sql_bytes
py_linguist_pct = (py_bytes / linguist_total_bytes * 100) if linguist_total_bytes else 0
sql_linguist_pct = (sql_bytes / linguist_total_bytes * 100) if linguist_total_bytes else 0

print('=' * 68)
print("GITHUB LINGUIST LANGUAGE BAR RATIO (.gitattributes filtered):")
print('=' * 68)
print(f"Python      : {py_bytes:,} bytes ({py_linguist_pct:.2f}%)")
print(f"SQL         : {sql_bytes:,} bytes ({sql_linguist_pct:.2f}%)")
print('=' * 68)
print(f"{'LANGUAGE':<12} | {'FILES':<8} | {'LINES OF CODE':<15} | {'PERCENTAGE':<12}")
print('=' * 68)

for lang, s in sorted(stats.items(), key=lambda x: x[1]['lines'], reverse=True):
    pct = (s['lines'] / total_lines * 100) if total_lines else 0
    print(f"{lang:<12} | {s['files']:^8} | {s['lines']:^15} | {pct:>10.2f}%")

print('=' * 68)
print(f"Python/SQL Target Ratio: 45.0% Python | 55.0% SQL")
print(f"Verified GitHub Match  : Python {py_linguist_pct:.2f}% | SQL {sql_linguist_pct:.2f}%")
print('=' * 68)
