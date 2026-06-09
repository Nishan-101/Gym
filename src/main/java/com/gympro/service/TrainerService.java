package com.gympro.service;

import com.gympro.dao.TrainerDAO;
import com.gympro.model.Trainer;

import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for Trainer management.
 */
public class TrainerService {

    private final TrainerDAO trainerDAO = new TrainerDAO();

    public List<Trainer> getAllTrainers()           throws SQLException { return trainerDAO.findAll(); }
    public List<Trainer> getActiveTrainers()        throws SQLException { return trainerDAO.findActive(); }
    public Trainer       getTrainerById(int id)     throws SQLException { return trainerDAO.findById(id); }
    public boolean       addTrainer(Trainer t)      throws SQLException { return trainerDAO.insert(t) > 0; }
    public boolean       updateTrainer(Trainer t)   throws SQLException { return trainerDAO.update(t); }
    public boolean       deleteTrainer(int id)      throws SQLException { return trainerDAO.delete(id); }
    public boolean       emailExists(String email)  throws SQLException { return trainerDAO.emailExists(email); }
    public int           getTotalTrainers()         throws SQLException { return trainerDAO.countActive(); }
}
