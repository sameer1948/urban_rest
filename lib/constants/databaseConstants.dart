// ignore: file_names
// ignore_for_file: constant_identifier_names
class DatabaseConstants {
  static const String DATABASE_NAME = 'urban.db';
  static const String TABLE_BACKGROUND_COLOR = 'BACKGROUND_COLOR';
  static const String TABLE_TRANSITION = 'TRANSITION';
  static const String TABLE_DURATION_HOUR = 'DURATION_HOUR';
  static const String TABLE_BED = 'BED';
  static const String TABLE_CUSTOMER = 'CUSTOMER';
  static const String TABLE_BOOKING = 'BOOKING';
  static const String TABLE_INVOICE = 'INVOICE';
  static const String TABLE_BED_RATE = 'BED_RATE';

  /// SQL statement for Total Rows of table Bed.
  static const String SELECT_COUNT_FROM = '''SELECT COUNT(*) FROM ''';

  /// SQL statement to create the transitions table.
  static const String CREATE_TABLE_BACKGROUND_COLOR = '''
    CREATE TABLE $TABLE_BACKGROUND_COLOR (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      key TEXT NOT NULL, 
      colorsList TEXT NOT NULL, 
      isActive TEXT NOT NULL
    )
    ''';

  /// SQL statement to create the transitions table.
  static const String CREATE_TABLE_TRANSITION = '''
    CREATE TABLE $TABLE_TRANSITION (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      style TEXT NOT NULL, 
      isActive TEXT NOT NULL
    )
    ''';

  /// SQL statement to create the Duration Hour table.
  static const String CREATE_TABLE_DURATION_HOUR = '''
    CREATE TABLE $TABLE_DURATION_HOUR (
      id INTEGER PRIMARY KEY , 
      key TEXT NOT NULL, 
      value TEXT NOT NULL, 
      status TEXT NOT NULL
    )
    ''';

  /// SQL statement to create the beds table.
  static const String CREATE_TABLE_BED = '''
    CREATE TABLE $TABLE_BED (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      status TEXT NOT NULL CHECK (status IN ('occupied', 'available'))
    )
    ''';

  /// SQL statement to create the customers table.
  static const String CREATE_TABLE_CUSTOMER = '''
    CREATE TABLE $TABLE_CUSTOMER (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT NOT NULL, 
      phone TEXT NOT NULL UNIQUE, 
      address TEXT NOT NULL, 
      securityId TEXT NOT NULL
    )
    ''';

  /// SQL statement to create the Booking table.
  static const String CREATE_TABLE_BOOKING = '''
    CREATE TABLE $TABLE_BOOKING (
      id INTEGER PRIMARY KEY,
      bedId INTEGER NOT NULL,
      customerId INTEGER NOT NULL,
      startTime TEXT NOT NULL,
      endTime TEXT NOT NULL,    
      FOREIGN KEY (bedId) REFERENCES $TABLE_BED(id),
      FOREIGN KEY (customerId) REFERENCES $TABLE_CUSTOMER(id)
      UNIQUE (customerId, bedId, startTime)
    )
    ''';

  /// SQL statement to create the Invoice table.
  static const String CREATE_TABLE_INVOICE = '''
    CREATE TABLE $TABLE_INVOICE (
      id INTEGER PRIMARY KEY,
      bookingId INTEGER NOT NULL,
      amount REAL NOT NULL,
      paymentDate TEXT NOT NULL,
      isPaid INTEGER NOT NULL,
      FOREIGN KEY (bookingId) REFERENCES $TABLE_BOOKING(id)
    )
    ''';

  /// SQL statement to create the Bill Rate table.
  static const String CREATE_TABLE_BED_RATE = '''
    CREATE TABLE $TABLE_BED_RATE (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pricePerHour REAL NOT NULL
    )
    ''';
}
