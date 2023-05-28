package com.rockofmam.OdoScan.model;

import com.rockofmam.OdoScan.enums.Unit;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Table(name = "odometer_logs")
@Getter
@Setter
@ToString
@NoArgsConstructor
public class OdometerLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "odometer_reading")
    private Long odometer_reading;

    @Column(name = "unit")
    private Unit unit;

    @Column(name = "record_date")
    private Date record_date;

    @ManyToOne(cascade = {CascadeType.ALL})
    @JoinColumn(name = "vehicle_id")
    private Vehicle vehicle;

    public OdometerLog(Long odometer_reading, Unit unit, Date record_date, Vehicle vehicle) {
        this.odometer_reading = odometer_reading;
        this.unit = unit;
        this.record_date = record_date;
        this.vehicle = vehicle;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OdometerLog that = (OdometerLog) o;

        if (!id.equals(that.id)) return false;
        if (!odometer_reading.equals(that.odometer_reading)) return false;
        if (unit != that.unit) return false;
        if (!record_date.equals(that.record_date)) return false;
        return vehicle.equals(that.vehicle);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + odometer_reading.hashCode();
        result = 31 * result + unit.hashCode();
        result = 31 * result + record_date.hashCode();
        result = 31 * result + vehicle.hashCode();
        return result;
    }
}
