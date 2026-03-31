#!/usr/bin/env python3
import os, re, csv
from pathlib import Path


def get_md_title(path):
    try:
        with open(path, encoding='utf-8') as f:
            for line in f:
                s = line.strip()
                if s.startswith('#'):
                    return re.sub(r'^#+\s*', '', s).strip()
                if s:
                    break
    except Exception:
        pass
    return Path(path).stem.replace('-', ' ').replace('_', ' ').strip()


def get_html_title(path):
    try:
        with open(path, encoding='utf-8') as f:
            txt = f.read(65536)
            m = re.search(r'<h1[^>]*>(.*?)</h1>', txt, re.I | re.S)
            if m:
                return re.sub(r'<[^<]+?>', '', m.group(1)).strip()
            m = re.search(r'<title[^>]*>(.*?)</title>', txt, re.I | re.S)
            if m:
                return re.sub(r'<[^<]+?>', '', m.group(1)).strip()
            m = re.search(r'<h[12][^>]*>(.*?)</h[12]>', txt, re.I | re.S)
            if m:
                return re.sub(r'<[^<]+?>', '', m.group(1)).strip()
    except Exception:
        pass
    return Path(path).stem.replace('-', ' ').replace('_', ' ').strip()


def tokenize(s):
    s = (s or '').lower()
    return set(re.findall(r"\w{2,}", s, re.U))


def jaccard(a, b):
    if not a or not b:
        return 0.0
    inter = a & b
    uni = a | b
    return len(inter) / len(uni) if uni else 0.0


def find_files(root, exts):
    for dirpath, dirs, files in os.walk(root):
        if '.git' in dirpath.split(os.sep):
            continue
        for fn in files:
            if any(fn.lower().endswith(ext) for ext in exts):
                yield os.path.join(dirpath, fn)


def main():
    # base = HelloComp_PREZENTACE
    base = Path(__file__).resolve().parents[1]
    root_parent = base.parent

    # articles root
    articles_root = root_parent / 'CODE_MAHONY' / 'PROJECTS' / 'Hellocomp SEO + COPY'
    if not articles_root.exists():
        # fallback: try without relying on Path joining
        articles_root = Path(str(root_parent) + '/CODE_MAHONY/PROJECTS/Hellocomp SEO + COPY')

    articles = []
    if articles_root.exists():
        for p in find_files(str(articles_root), ['.md']):
            title = get_md_title(p)
            articles.append({'path': os.path.relpath(p, start=str(root_parent)), 'title': title, 'tokens': tokenize(title)})
    else:
        print('Articles root not found:', articles_root)

    videos = []
    # scan HTML and MD files in presentation folder
    for p in find_files(str(base), ['.html', '.md']):
        if p.lower().endswith('.html'):
            title = get_html_title(p)
        else:
            title = get_md_title(p)
        videos.append({'path': os.path.relpath(p, start=str(root_parent)), 'title': title, 'tokens': tokenize(title)})

    # match articles to videos
    rows = []
    for a in articles:
        best = None
        best_score = 0.0
        for v in videos:
            score = jaccard(a['tokens'], v['tokens'])
            if score > best_score:
                best_score = score
                best = v
        if best:
            rows.append((a['path'], a['title'], best['path'], best['title'], '{:.3f}'.format(best_score)))
        else:
            rows.append((a['path'], a['title'], '', '', '0.000'))

    out = base / 'mapping_articles_videos.csv'
    with open(out, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow(['article_path', 'article_title', 'video_path', 'video_title', 'score'])
        for r in rows:
            w.writerow(r)
    print('Wrote', out)

    summary = base / 'mapping_summary.txt'
    with open(summary, 'w', encoding='utf-8') as f:
        f.write('Articles: {}\nVideos: {}\nMappings: {}\n'.format(len(articles), len(videos), len(rows)))
    print('Summary written to', summary)


if __name__ == '__main__':
    main()
