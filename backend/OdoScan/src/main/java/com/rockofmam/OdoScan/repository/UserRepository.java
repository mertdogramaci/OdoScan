package com.rockofmam.OdoScan.repository;

import com.rockofmam.OdoScan.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
