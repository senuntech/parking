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
              number_of_vacancies INTEGER,
              hourly_rate DOUBLE,
              day_price DOUBLE,
              single_price DOUBLE,
              text_receipt TEXT
          )
        ''';

String modelsTicket = '''
  CREATE TABLE vehicles(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    name TEXT, 
    whatsapp TEXT,
    document TEXT,
    model_car TEXT, 
    place_car TEXT,
    created_at DATE DEFAULT CURRENT_TIMESTAMP,
    departure_date DATE,
    price DOUBLE,
    discount DOUBLE
  )
''';
