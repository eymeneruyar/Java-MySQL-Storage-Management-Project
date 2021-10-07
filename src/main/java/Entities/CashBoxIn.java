package Entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Data
@Entity
public class CashBoxIn {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int cbIn_id;
    private int cbIn_customer; //Ad-Soyad -- ID gelecek Join yapıcaz
    private String cbIn_ticketNo; //Fiş Numarası
    private int cbIn_payAmount; //Ödenen Miktar
    private String cbIn_payDetail;
    private int cbIn_status; // 1 -> Giriş
    private String cbIn_date;

}
