package Entities;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@Entity
public class ReportCOA {

    @Id
    private int cu_id;
    private int cbIn_status;
    private String COA_startDate;
    private String COA_endDate;

}
