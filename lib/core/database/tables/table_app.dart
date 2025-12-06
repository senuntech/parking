String settingsTable = '''
          CREATE TABLE settings( 
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              imagePath TEXT,
              name TEXT,
              document TEXT,
              phone TEXT,
              typePix INTEGER, 
              modelCar TEXT,
              plateCar TEXT,
              textReceipt TEXT,
              showPix BOOLEAN, 
              myPix TEXT
          )
        ''';

String modelsTicket = '''
  CREATE TABLE ticket(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    name TEXT, 
    departure TEXT,
    destination TEXT,
    price DOUBLE
  )
''';

String orderTicket = '''
  CREATE TABLE order_ticket(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    created_at DATE DEFAULT CURRENT_TIMESTAMP,
    customer_name TEXT, 
    departure TEXT,
    destination TEXT,
    customer_discount DOUBLE,
    price DOUBLE
  )
''';
