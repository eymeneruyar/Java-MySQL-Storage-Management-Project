package Entities;


import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@Entity
public class View_CheckOutActions {

    @Id
    private int cu_id;
    private String co_ticketNo;
    private String co_nameSurname;
    private String cu_mobile;
    private String cu_email;
    private int co_amountPaid;
    private int paymentStatus;
    private String co_date;

}
