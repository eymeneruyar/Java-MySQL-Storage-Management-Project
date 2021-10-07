package Entities;

import lombok.Data;

import javax.persistence.*;

@Table(name = "User")
@Data
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int us_id;
    private String us_name;
    private String us_surname;

    @Column(unique = true)
    private String us_email;

    @Column(length = 32)
    private String us_password;


}
