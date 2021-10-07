package Entities;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@Entity
public class View_boxOrder_cuPro {

    @Id
    private int bo_id;
    private int cu_id;
    private String name_surname;
    private String bo_ticketNo;
    private int p_id;
    private String p_title;
    private int p_salePrice;
    private int bo_total;
    private int bo_totalPrice;
    private int bo_status;


}
