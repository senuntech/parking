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
              text_receipt TEXT
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
    number_of_vacancies INTEGER
  )
''';
