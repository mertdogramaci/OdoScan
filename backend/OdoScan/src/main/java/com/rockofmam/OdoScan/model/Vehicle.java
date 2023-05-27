package com.rockofmam.OdoScan.model;

import com.rockofmam.OdoScan.enums.Brand;
import com.rockofmam.OdoScan.enums.VehicleType;
import jakarta.persistence.*;
import lombok.*;

import java.time.Year;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "vehicle")
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vehicle_type")
    private VehicleType vehicleType;

    @Column(name = "brand")
    private Brand brand;

    @Column(name = "model")
    private String model;

    @Column(name = "purchase_year")
    private Year purchaseYear;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

    @OneToMany
    @JoinColumn(name = "odometer_log_id", referencedColumnName = "id")
    @ToString.Exclude
    private List<OdometerLog> odometerLogs;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Vehicle vehicle = (Vehicle) o;

        if (!id.equals(vehicle.id)) return false;
        if (vehicleType != vehicle.vehicleType) return false;
        if (brand != vehicle.brand) return false;
        if (!model.equals(vehicle.model)) return false;
        if (!purchaseYear.equals(vehicle.purchaseYear)) return false;
        if (!user.equals(vehicle.user)) return false;
        return Objects.equals(odometerLogs, vehicle.odometerLogs);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + vehicleType.hashCode();
        result = 31 * result + brand.hashCode();
        result = 31 * result + model.hashCode();
        result = 31 * result + purchaseYear.hashCode();
        result = 31 * result + user.hashCode();
        result = 31 * result + (odometerLogs != null ? odometerLogs.hashCode() : 0);
        return result;
    }
}