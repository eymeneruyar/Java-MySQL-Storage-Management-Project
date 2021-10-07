package Entities;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class View_CashBoxInCompletedOrder {

    @Id
    private int cbIn_id;
    private String co_nameSurname;
    private String co_ticketNo;
    private int cbIn_payAmount; //Ödenen Miktar
    private String cbIn_payDetail;

}
