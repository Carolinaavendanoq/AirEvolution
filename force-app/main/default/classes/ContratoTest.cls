@isTest
public with sharing class ContratoTest {
    @isTest
    static void contratoTrimestreUno(){
        Contract contrato1 = new Contract(Valor_total__c = 10000, Status = 'Draft', startDate = Date.newInstance(2022,2,3),AccountId = '0018a00001tUNBJAA4'); 

        Contract resultado = Contrato.definirDuracion(contrato1);

        System.assertEquals(6,resultado.ContractTerm);
        System.assert(resultado.Id != null);

    }

    @isTest
    static void trimestreTres(){
        Contract contract = new Contract(Valor_total__c = 100, Status = 'Draft', startDate = Date.newInstance(2022, 11, 14),AccountId = '0018a00001tUNBJAA4' );

        Contract resultado = Contrato.definirDuracion(contract);
        
        System.assertEquals(85, resultado.Valor_total__c);
    }
}