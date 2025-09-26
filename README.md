# Database-Architecture-Query-Optimization

> Relational database design and SQL toolkit to manage clients, cases, documents, transactions, and legal workflows for a notarial firm.

---

## 📝 Overview
This repository contains a production-ready SQL schema and queries for a notarial practice managing clients (individual & corporate), cases (real estate, estate, marriage, corporate), appointments, communications, documents, and payments. The model is normalized, role-driven, and designed for rich reporting (case status, financials, compliance). It was developed from a real business scenario for “Lessard et Ahiba Notaires,” covering end-to-end data capture and analytics.

---

## 🎯 Objective • Actions • Tasks • Conclusion

**Objective**
- Build a flexible, normalized database that captures the firm’s operations and supports analytics, reporting, and compliance.

**Actions**
- Modeled the domain with an ERD centered on **Client**, **Case**, and **Document** lifecycles.
- Implemented a full **DDL** (tables, PK/FK, constraints) across client, corporate, estate, real estate, appointments, and communications.
- Authored **DML** seed data for realistic testing.
- Wrote **operational queries** (forms) and **reporting queries** (status, financials, activity, compliance).

**Tasks**
- Generalization: **Client → Individual / Corporate**; **Transaction → RealEstate / Estate**.
- Role-based participation via **CaseParticipation** and **PartiesParticipating**.
- Document handling via **Documents** and **DocumentLibrary** with verification status.
- Financial and operational reporting (payments, overdue cases, document inventory).

**Conclusion**
- A single schema supports many services (estate, marriage, corporate, real estate) without redundancy.
- Role-based modeling simplifies queries, improves maintainability, and enables comprehensive compliance and analytics.

---

## 🏗️ Architecture
See **Deliverables → `ERD_Structure.pdf`** for the full Entity-Relationship Diagram (ERD).

---

## 🔄 How to Reproduce / Test the Code

You don’t need to install a local database to try this project — you can run everything on [DB-Fiddle](https://www.db-fiddle.com/) (open, free, no account required).

1. Go to **[DB-Fiddle](https://www.db-fiddle.com/)**.  
2. Copy the entire content of **`Data_Definition_Language.sql`** into the **Schema SQL** pane (left side).  
3. To test queries, open **`Data_Manipulation_Language.sql`**, copy any query you want, and paste it into the **Query SQL** pane (right side).  
4. Click **Run** → 🎉 results will appear immediately.

---

## 📂 Deliverables

- **ERD** → `Deliverables/ERD_Structure.pdf`  
- **Final Report** → `Deliverables/INSY 437 - Final Project.pdf`  
- **Code** → `SQL_DDL_DML_Codes/` (contains both `Data_Definition_Language.sql` and `Data_Manipulation_Language.sql`)

---

## 🔄 Reproduce or Extend
- Load the schema and queries in DB-Fiddle to replicate all forms and reports from the project brief.
- Adapt roles, statuses, and enums to your practice.
- Extend compliance and analytics by adding new queries, views, or materialized views.

---

