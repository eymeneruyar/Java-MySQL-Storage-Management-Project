package Entities;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Table(name = "Customer")
@Data
@Entity
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int cu_id;

    private String cu_name;
    private String cu_surname;
    private String cu_company_title;
    private long cu_code;
    private int status;
    private int cu_tax_number;
    private String cu_tax_administration;
    @Column(length = 500)
    private String cu_address;
    private String cu_mobile;
    private String cu_phone;
    @Column(length = 500)
    private String cu_email;
    @Column(length = 32)
    private String cu_password;
    private Date cu_date;

    /*
    *Bu anotation (fetch) eklenmediği zaman Müşteri tablo görüntülemede
    * 500 hatası alıyoruz. Bu hatayı anlamak içi 3 şeyi bilmemiz gerekir.
    * Session; bir uygulama ile veritabanı arasındaki konuşmayı temsil eden bir kalıcılık bağlamıdır.
    * Lazy Loading; nesnenin kodda erişilene kadar Oturum bağlamına yüklenmeyeceği anlamına gelir.
    * Proxy Object; Hibernate, yalnızca nesneyi ilk kullandığımızda veritabanına ulaşacak dinamik bir Proxy Nesnesi alt sınıfı oluşturur.
    * Bu hata, bir proxy nesnesi kullanarak veritabanından tembel yüklü bir nesne almaya çalıştığımız,
    * ancak Hazırda Bekletme oturumunun zaten kapalı olduğu anlamına gelir.
    */
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.DETACH)
    private List<BoxOrder> boxOrder;


}
