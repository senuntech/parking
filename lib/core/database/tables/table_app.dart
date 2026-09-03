String settingsTable = '''
          CREATE TABLE settings( 
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              image_path TEXT,
              name TEXT,
              document TEXT,
              phone TEXT,
              type_pix INTEGER, 
              show_pix BOOLEAN, 
              my_pix TEXT,
              text_receipt TEXT,
              is_dark BOOLEAN DEFAULT 0
          )
        ''';

String orderTicket = '''
  CREATE TABLE order_ticket(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    name TEXT, 
    phone TEXT,
    document TEXT,
    model TEXT, 
    plate TEXT,
    created_at DATE DEFAULT CURRENT_TIMESTAMP,
    price DOUBLE,
    discount DOUBLE,
    value_type INTEGER,
    exit_at DATE,
    type_vehicles INTEGER,
    payment_method INTEGER,
    code TEXT,
    FOREIGN KEY(type_vehicles) REFERENCES vehicles(id)
  )
''';
String modelsTicket = '''
  CREATE TABLE vehicles(
    id INTEGER PRIMARY KEY, 
    single_price DOUBLE,
    hourly_rate DOUBLE,
    day_price DOUBLE,
    number_of_vacancies INTEGER,
    type_of_billing INTEGER
  )
''';

String tableVehiclePeriods = '''
  CREATE TABLE vehicle_periods(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vehicle_id INTEGER,
    start_minute INTEGER,
    end_minute INTEGER,
    price DOUBLE,
    is_additional BOOLEAN DEFAULT 0,
    FOREIGN KEY(vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )
''';
