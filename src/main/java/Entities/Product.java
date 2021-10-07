package Entities;

import lombok.Data;
import javax.persistence.*;

@Table(name = "Product")
@Data
@Entity
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int p_id;
    private String p_title; //Başlık
    private int p_buyPrice; //Alış Fiyatı
    private int p_salePrice; //Satış Fiyatı
    private int p_code; //Ürün Kodu
    private String p_vat; //KDV
    private String p_unit; //Birim
    private int p_quantity; //Miktar
    private String p_detail; //Ürün Detayı

}
