package com.rockofmam.OdoScan.service;

import com.rockofmam.OdoScan.exception.UserNotFoundException;
import com.rockofmam.OdoScan.model.User;
import com.rockofmam.OdoScan.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    protected User findUserById(Long id) {
        return userRepository.findById(id).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + id)
        );
    }

    public Optional<User> getUserById(Long userId) {
        return userRepository.findById(userId);
    }

    public List<User> getAllUser() {
        return userRepository.findAll();
    }

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public User updateUser(Long userId, User user) {
        User user1 = findUserById(userId);

        if (user1.getId() != null) {
            user1.setName(user.getName());
            user1.setSurname(user.getSurname());
            user1.setPhone(user.getPhone());
            user1.setMail(user.getMail());
            user1.setAddress(user.getAddress());
            user1.setVehicles(user.getVehicles());
        }

        return userRepository.save(user1);
    }

    public void deleteUserById(Long id) {
        userRepository.deleteById(id);
    }
}
