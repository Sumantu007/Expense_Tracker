package com.expensetracker.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Transaction {

    private int id;
    private int userId;
    private String entryType;
    private String title;
    private String category;
    private BigDecimal amount;
    private Date entryDate;
    private String notes;

    // A simple constructor is useful when reading rows from MySQL.
    public Transaction(int id, int userId, String entryType, String title,
            String category, BigDecimal amount, Date entryDate, String notes) {
        this.id = id;
        this.userId = userId;
        this.entryType = entryType;
        this.title = title;
        this.category = category;
        this.amount = amount;
        this.entryDate = entryDate;
        this.notes = notes;
    }

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getEntryType() { return entryType; }
    public String getTitle() { return title; }
    public String getCategory() { return category; }
    public BigDecimal getAmount() { return amount; }
    public Date getEntryDate() { return entryDate; }
    public String getNotes() { return notes; }
}
