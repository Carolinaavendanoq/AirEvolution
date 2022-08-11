//INSERT

//Declaración DML
Account cuenta = new Account(Name = 'Mi Primera Cuenta', Phone = '55555');
insert cuenta;
system.debug('Cuenta creada: ' + cuenta);

// 0018a00001tHaCXAA0

// Método
Account cuenta2 = new Account (Name = 'Mi segunda cuenta', Phone = '44');
Database.SaveResult resultado = Database.insert(cuenta2, false);
system.debug('Resultado: ' + resultado);
system.debug('Cuenta 2: ' + cuenta2);
//0018a00001tHaCYAA0

// UPDATE
// Declaracion DML
Account cuenta = new Account(Id= '0018a00001tHaCXAA0', Name = 'Mi Primera Cuenta', Phone = '55555');
cuenta.Name = 'Mi segunda cuenta Act';
try{
    update cuenta;
    system.debug('Cuenta actualizada: ' + cuenta);
}
catch(DmlException dmlE){

}

// Metodo
Account cuenta2 = new Account();
cuenta2.Id = '0018a00001tHaCYAA0';
cuenta2.Name = 'Mi primera cuenta Act';
cuenta2.BillingCity = 'Medellín';
Database.SaveResult resultadoActualizado = Database.update(cuenta2, false);
system.debug('Resultado actualizado: ' + resultadoActualizado );
system.debug('Cuenta 2 actualizada: ' + cuenta2 );

// UPSERT

// Declaracion DML
List<Account> cuentas = new List<Account>();
Account cuenta = new Account();
cuenta.Id = '0018a00001tHaCXAA0';
cuenta.Name = 'Cuenta actualizada por upsert';
cuentas.add(cuenta);

Account cuenta3 = new Account();
cuenta3.Name = 'Mi Cuenta 3';
cuentas.add(cuenta3);
try{
    upsert cuentas;
    system.debug('Resultado de upsert: ' + cuentas);
}
catch(DmlException dmlE){

}

// Metodo
List<Account> cuentas = new List<Account>();
Account cuenta = new Account();
cuenta.Id = '0018a00001tHaCXAA0';
cuenta.Name = 'Cuenta actualizada por el metodo upsert';
cuentas.add(cuenta);

Account cuenta4 = new Account();
cuenta4.Name = 'Mi Cuenta 4';
cuentas.add(cuenta4);
try{
    List<Database.UpsertResult> resultadoActualizado = Database.upsert(cuentas, false);
    system.debug('Resultado de upsert: ' + cuentas);
}
catch(DmlException dmlE){

}

// DELETE

// Declaracion
Account cuenta = new Account();
cuenta.Id = '0018a00001tHaCXAA0';
try{
    delete cuenta;
    system.debug('Cuenta eliminada: ' + cuenta);
}
catch(DmlException dmlE){

}

// Metodo
Account cuenta = new Account();
cuenta.Id = '0018a00001tHaCXAA0';
try{
    Database.delete(cuenta, false);
    system.debug('Cuenta eliminada: ' + cuenta);
}
catch(DmlException dmlE){

}

// UNDELETE

// Declaracion
Account cuenta = new Account();
cuenta.Id = '0018a00001tHaCXAA0';
try{
    undelete cuenta;
    system.debug('Cuenta recuperada: ' + cuenta);
}
catch(DmlException dmlE){

}

// Metodo
Account cuenta = new Account();
cuenta.id = '0018a00001tHaCXAA0';
try{
    Database.undelete(cuenta, false);
    system.debug('Cuenta recuperada: ' + cuenta);
}
catch(DmlException dmlE){

}


// MERGE

// Declaracion
Account cuenta5 = new Account(Name = 'Cuenta 1 para merge', Phone = '22225');
insert cuenta5;
system.debug('Cuenta creada ' + cuenta5);

Account cuenta6 = new Account (Name = 'Cuenta 2 para merge', Phone = '4444');
Database.SaveResult resultado = Database.insert(cuenta6, false);
system.debug('Resultado' + resultado);
system.debug('Cuenta 6 ' + cuenta6);

List <Account> nuevasCuentas = new List <Account>();
cuenta5.id = '';
cuenta5.Name = 'Google';
update cuenta5;

cuenta6.id = '';
cuenta6.Name = 'BMW';
update cuenta6;
nuevasCuentas.add(cuenta6);

try{
    merge cuenta5 nuevasCuentas;
    system.debug('Cuenta con Merge: ' + cuenta5);
}
catch(DmlException dmlE){

}

// Metodo
try{
   List<Database.MergeResult> resultado = Database.merge(cuenta5, nuevasCuentas, false);
    system.debug('Cuenta con Merge: ' + cuenta5);
}
catch(DmlException dmlE){

}
