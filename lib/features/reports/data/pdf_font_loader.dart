import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// A bundle of loaded PDF fonts for regular and bold weights.
class PdfFontBundle {
  const PdfFontBundle({required this.regular, required this.bold});

  final pw.Font regular;
  final pw.Font bold;
}

/// Loads Vietnamese Unicode fonts from asset bundle for use in PDF generation.
///
/// Font files must be placed in `assets/fonts/` and registered in `pubspec.yaml`.
/// See `assets/fonts/README.md` for instructions on acquiring OFL-licensed fonts.
class PdfFontLoader {
  const PdfFontLoader();

  /// Loads Noto Sans Regular and Bold fonts from the asset bundle.
  ///
  /// Throws an [Exception] if any font file is missing.
  Future<PdfFontBundle> load() async {
    final ByteData regularData = await rootBundle.load(
      'assets/fonts/NotoSans-Regular.ttf',
    );
    final ByteData boldData = await rootBundle.load(
      'assets/fonts/NotoSans-Bold.ttf',
    );

    return PdfFontBundle(
      regular: pw.Font.ttf(regularData),
      bold: pw.Font.ttf(boldData),
    );
  }
}
