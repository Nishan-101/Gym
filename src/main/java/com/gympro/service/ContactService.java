package com.gympro.service;

import com.gympro.dao.ContactInquiryDAO;
import com.gympro.model.ContactInquiry;

import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for Contact Inquiries.
 */
public class ContactService {

    private final ContactInquiryDAO dao = new ContactInquiryDAO();

    public boolean              saveInquiry(ContactInquiry ci)   throws SQLException { return dao.insert(ci); }
    public List<ContactInquiry> getAllInquiries()                 throws SQLException { return dao.findAll(); }
    public boolean              markAsRead(int id)               throws SQLException { return dao.markRead(id); }
}
