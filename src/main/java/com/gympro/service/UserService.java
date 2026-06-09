package com.gympro.service;

import com.gympro.dao.UserDAO;
import com.gympro.model.User;
import com.gympro.util.DateUtil;
import com.gympro.util.PasswordUtil;
import com.gympro.util.ValidationUtil;

import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for User business logic.
 * Delegates all data access to UserDAO.
 */
public class UserService {

    private final UserDAO userDAO = new UserDAO();

    /** Register a new member. Returns generated ID or -1. */
    public int registerUser(User user) throws SQLException {
        user.setRole("member");
        user.setStatus("pending");
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
        return userDAO.insert(user);
    }

    /** Authenticate by email + plain password. Returns User or null. */
    public User login(String email, String plainPassword) throws SQLException {
        User user = userDAO.findByEmail(email);
        if (user == null) return null;
        if (!"approved".equals(user.getStatus())) return null;
        return PasswordUtil.verifyPassword(plainPassword, user.getPassword()) ? user : null;
    }

    public User getUserById(int userId)          throws SQLException { return userDAO.findById(userId); }
    public List<User> getUsersByRole(String role) throws SQLException { return userDAO.findByRole(role); }
    public List<User> getPendingUsers()           throws SQLException { return userDAO.findPending(); }

    public boolean updateProfile(User user)                        throws SQLException { return userDAO.updateProfile(user); }
    public boolean updateUserStatus(int id, String status)         throws SQLException { return userDAO.updateStatus(id, status); }
    public boolean deleteUser(int id)                              throws SQLException { return userDAO.delete(id); }

    public boolean changePassword(int userId, String newPassword) throws SQLException {
        return userDAO.updatePassword(userId, PasswordUtil.hashPassword(newPassword));
    }

    public boolean updateProfilePhoto(int userId, String fileName) throws SQLException {
        return userDAO.updateProfilePhoto(userId, fileName);
    }

    public boolean emailExists(String email) throws SQLException { return userDAO.emailExists(email); }
    public boolean phoneExists(String phone) throws SQLException { return userDAO.phoneExists(phone); }
    public int     getTotalMembers()         throws SQLException { return userDAO.countApprovedMembers(); }
}