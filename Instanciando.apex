System.debug('Hola desde VSC');

Account acc = new Account();
acc.Name = 'Instancia1';
acc.Phone = '24262';

System.debug('Mi primera instancia ' + acc);

Account acc2 = new Account(Name = 'Instancia2', Phone = '14252523');

System.debug('Mi segunda instancia ' + acc2);