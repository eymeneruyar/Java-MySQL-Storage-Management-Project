package Entities;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Data
@Entity
public class BoxOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int bo_id;
    private int bo_customer; //cu_id
    private int bo_product; //p_id
    private int bo_total;
    private String bo_ticketNo;
    private int bo_totalPrice;
    private int bo_status; //0-> Satış tamamlanmadı. 1-> Satış Tamamlandı.
    private String bo_date;


}
