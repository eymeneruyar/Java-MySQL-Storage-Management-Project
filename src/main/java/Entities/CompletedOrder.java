package Entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Data
@Entity
public class CompletedOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int co_id; //Completed order id
    private int c_id; //Customer id
    private int p_id; //Product id
    private String co_nameSurname;
    private String co_ticketNo;
    private int totalPrice;
    private int co_amountPaid; //Ödenen Miktar
    private int co_avail; //Kalan Miktar
    private int paymentStatus; //Ödeme durumu -> Eğer paranın tamamı ödendi ise 1 ödenmediyse 0.
    private String co_date;


}
