# Vietnamese Unicode Font for PDF Export

This directory holds `.ttf` font files used to render Vietnamese text in PDF reports.

## Required Files

Place the following OFL-licensed font files in this directory:

- `NotoSans-Regular.ttf` — Regular weight
- `NotoSans-Bold.ttf` — Bold weight

## Recommended Source

Download from Google Fonts (OFL license, freely redistributable):

https://fonts.google.com/specimen/Noto+Sans

Direct download links (verify before use):
- Noto Sans Regular: https://fonts.gstatic.com/s/notosans/v36/o-0bIIQdiZQaZLoU1K3D8fQ.woff2 (convert to TTF)
- Or search `Noto Sans` on https://github.com/googlefonts/noto-fonts/releases

Alternative OFL fonts supporting Vietnamese:
- DejaVu Sans: https://dejavu-fonts.org/
- Liberation Sans (if Vietnamese coverage is confirmed)

## Usage

1. Download the `.ttf` files and place them in this `assets/fonts/` directory.
2. Update `pubspec.yaml` to include the fonts:

```yaml
flutter:
  assets:
    - assets/fonts/

  fonts:
    - family: NotoSans
      fonts:
        - asset: assets/fonts/NotoSans-Regular.ttf
        - asset: assets/fonts/NotoSans-Bold.ttf
          weight: 700
```

3. Run `flutter pub get`.
4. The `PdfFontLoader` will load these fonts at runtime for PDF generation.

## License

Font files must be OFL-licensed (SIL Open Font License). Do NOT commit proprietary or unlicensed fonts.
