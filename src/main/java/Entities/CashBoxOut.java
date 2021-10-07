package Entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Data
@Entity
public class CashBoxOut {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int cbOut_id;
    private String cbOut_title;
    private int cbOut_payType;
    private int cbOut_payAmount;
    private String cbOut_payDetail;
    private int cbOut_status; // 2 -> Çıkış
    private String cbOut_date;

}
