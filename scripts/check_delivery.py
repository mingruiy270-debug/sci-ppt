"""Compact structural checks; visual fidelity and application reopening remain separate."""
import argparse
import json
import zipfile
from pathlib import Path
from xml.etree import ElementTree as ET


def native_inventory(path):
    result = {}
    ns = {'p': 'http://schemas.openxmlformats.org/presentationml/2006/main'}
    with zipfile.ZipFile(path) as archive:
        for name in archive.namelist():
            if name.startswith('ppt/slides/slide') and name.endswith('.xml'):
                root = ET.fromstring(archive.read(name))
                result[name] = {s.find('p:nvSpPr/p:cNvPr', ns).get('id')
                                for s in root.findall('.//p:sp', ns)}
    return result


def check(pptx, components, baseline=None):
    errors, warnings = [], []
    counts = {'slides': 0, 'text_runs': 0, 'components': 0}
    try:
        with zipfile.ZipFile(pptx) as archive:
            if archive.testzip():
                errors.append('Corrupt PPTX member')
            names = archive.namelist()
            if 'ppt/presentation.xml' not in names:
                errors.append('Missing presentation XML')
            for name in names:
                if name.startswith('ppt/slides/slide') and name.endswith('.xml'):
                    root = ET.fromstring(archive.read(name))
                    counts['slides'] += 1
                    counts['text_runs'] += sum(1 for n in root.iter() if n.tag.endswith('}t') and n.text)
            if not counts['slides']:
                errors.append('No slides')
    except (OSError, zipfile.BadZipFile, ET.ParseError) as exc:
        errors.append(str(exc))
    if baseline and not errors:
        try:
            before, after = native_inventory(baseline), native_inventory(pptx)
            missing = sum(len(ids - after.get(page, set())) for page, ids in before.items())
            if missing:
                errors.append(f'{missing} baseline native shape IDs missing: inspect for raster replacement or ID rewrite')
        except (OSError, zipfile.BadZipFile, ET.ParseError) as exc:
            errors.append(f'Baseline check failed: {exc}')
    if components:
        if not components.is_dir():
            errors.append('Components directory missing')
        else:
            files = list(components.rglob('*'))
            counts['components'] = len([p for p in files if p.suffix.lower() == '.png'])
            try:
                from PIL import Image
            except ImportError:
                Image = None
            for path in files:
                try:
                    if path.suffix.lower() == '.svg':
                        root = ET.parse(path).getroot()
                        if root.tag.split('}')[-1] != 'svg':
                            errors.append(f'{path.name}: invalid SVG root')
                        if any(n.tag.split('}')[-1] in ('image', 'foreignObject') for n in root.iter()):
                            errors.append(f'{path.name}: not pure vector')
                        if not path.with_suffix('.png').exists():
                            errors.append(f'{path.name}: PNG companion missing')
                    elif path.suffix.lower() == '.png':
                        if Image is None:
                            warnings.append('Transparency unverified: Pillow unavailable')
                            continue
                        with Image.open(path) as im:
                            im.load()
                            alpha = im.convert('RGBA').getchannel('A').getextrema()
                            if alpha[0] == 255:
                                errors.append(f'{path.name}: no transparent pixels')
                            elif alpha[1] == 0:
                                errors.append(f'{path.name}: fully invisible')
                except (OSError, ET.ParseError, ValueError) as exc:
                    errors.append(f'{path.name}: {exc}')
    return {'status': 'FAIL' if errors else ('UNVERIFIED' if warnings else 'PASS'),
            'counts': counts, 'errors': errors, 'warnings': sorted(set(warnings))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pptx', type=Path, required=True)
    parser.add_argument('--components', type=Path)
    parser.add_argument('--details', action='store_true')
    parser.add_argument('--baseline', type=Path, help='Optional pre-grouping PPTX; detect native object loss, not visual fidelity')
    args = parser.parse_args()
    result = check(args.pptx, args.components, args.baseline)
    if args.details:
        print(json.dumps(result, ensure_ascii=True, indent=2))
    else:
        print(f"{result['status']}: {result['counts']['slides']} slides; "
              f"{result['counts']['components']} PNG assets. Structural checks only.")
        for issue in (result['errors'] + result['warnings'])[:6]:
            print(issue)
        if len(result['errors']) + len(result['warnings']) > 6:
            print('More issues: use --details')
    return 1 if result['errors'] else (2 if result['warnings'] else 0)


if __name__ == '__main__':
    raise SystemExit(main())
