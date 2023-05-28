package com.rockofmam.OdoScan.model;

import com.rockofmam.OdoScan.enums.Unit;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

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
    private Long odometerReading;

    @Column(name = "unit")
    private Unit unit;

    @Column(name = "record_date")
    private LocalDateTime recordDate;

    @ManyToOne(cascade = {CascadeType.ALL})
    @JoinColumn(name = "vehicle_id")
    private Vehicle vehicle;

    public OdometerLog(Long odometerReading, Unit unit, LocalDateTime recordDate, Vehicle vehicle) {
        this.odometerReading = odometerReading;
        this.unit = unit;
        this.recordDate = recordDate;
        this.vehicle = vehicle;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OdometerLog that = (OdometerLog) o;

        if (!id.equals(that.id)) return false;
        if (!odometerReading.equals(that.odometerReading)) return false;
        if (unit != that.unit) return false;
        if (!recordDate.equals(that.recordDate)) return false;
        return vehicle.equals(that.vehicle);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + odometerReading.hashCode();
        result = 31 * result + unit.hashCode();
        result = 31 * result + recordDate.hashCode();
        result = 31 * result + vehicle.hashCode();
        return result;
    }
}
