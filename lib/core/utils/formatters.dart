import 'package:intl/intl.dart';

class Formatters {
  static final _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  static final _date = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
  static final _dateOnly = DateFormat('dd MMM yyyy', 'id_ID');

  static String rupiah(num value) => _idr.format(value);
  static String dateTime(DateTime dt) {
    try {
      return _date.format(dt);
    } catch (_) {
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    }
  }

  static String dateOnly(DateTime dt) {
    try {
      return _dateOnly.format(dt);
    } catch (_) {
      return DateFormat('dd MMM yyyy').format(dt);
    }
  }
}
