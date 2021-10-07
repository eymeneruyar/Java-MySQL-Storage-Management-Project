package Entities;

import lombok.Data;

import javax.persistence.*;

@Data
@Entity
public class boxOfOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int bod_id;
    @Column(unique = false)
    private int bo_id;
    private int cu_id;
    private int p_id;
    private String bo_ticketNo;
    private String name_surname;
    private String p_title;
    private int p_salePrice;
    private int bo_total;
    private int bo_totalPrice;
    private int bo_status;

}
