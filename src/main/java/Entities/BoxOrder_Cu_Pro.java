package Entities;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@Entity
public class BoxOrder_Cu_Pro {

    @Id
    private int bo_id;
    private int cu_id;
    private int p_id;
    private String bo_ticketNo;
    @Column(updatable = false)
    private String name_surname;
    private String p_title;
    private int p_salePrice;
    private int bo_total;
    private int bo_totalPrice;
    private int bo_status;


}
