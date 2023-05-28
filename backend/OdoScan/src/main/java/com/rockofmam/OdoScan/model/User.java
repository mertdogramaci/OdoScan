package com.rockofmam.OdoScan.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "users")
@Getter
@Setter
@ToString
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "surname")
    private String surname;

    @Column(name = "phone")
    private String phone;

    @Column(name = "mail", unique = true)
    private String mail;

    @Column(name = "address")
    private String address;

    @OneToMany
    @JoinColumn(name = "vehicle_id", referencedColumnName = "id")
    @ToString.Exclude
    private List<Vehicle> vehicles;

    public User(String name, String surname, String phone, String mail, String address) {
        this.name = name;
        this.surname = surname;
        this.phone = phone;
        this.mail = mail;
        this.address = address;
    }

    public void addVehicle(Vehicle vehicle) {
        vehicles.add(vehicle);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        User user = (User) o;

        if (!id.equals(user.id)) return false;
        if (!name.equals(user.name)) return false;
        if (!surname.equals(user.surname)) return false;
        if (!Objects.equals(phone, user.phone)) return false;
        if (!Objects.equals(mail, user.mail)) return false;
        if (!Objects.equals(address, user.address)) return false;
        return Objects.equals(vehicles, user.vehicles);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + name.hashCode();
        result = 31 * result + surname.hashCode();
        result = 31 * result + (phone != null ? phone.hashCode() : 0);
        result = 31 * result + (mail != null ? mail.hashCode() : 0);
        result = 31 * result + (address != null ? address.hashCode() : 0);
        result = 31 * result + (vehicles != null ? vehicles.hashCode() : 0);
        return result;
    }
}
