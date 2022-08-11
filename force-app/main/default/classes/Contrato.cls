public with sharing class Contrato {

    public static Contract definirDuracion(Contract contrato) {
        Integer mes = contrato.startDate.month();
        if((contrato.startDate.month() == 1 && contrato.StartDate.day() < 15) || (contrato.startDate.month() == 12 && contrato.StartDate.day() > 20) ){
            throw new contratoException('');
        }

        if(mes >= 1 && mes < 4){
            contrato.ContractTerm = 6;
        }else if((mes >= 4) && (mes < 10)){
            contrato.ContractTerm = 3;
        }else if(mes >= 10 && mes <= 12){
            contrato.ContractTerm = 1;
            contrato.Valor_total__c = contrato.Valor_total__c * 0.85;
        }else {
            // error fecha
        }
        
        insert contrato;

        return contrato;
    }


    public class contratoException extends Exception {}

}