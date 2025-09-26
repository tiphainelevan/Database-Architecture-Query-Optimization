
-- Table: Client

CREATE TABLE Client (
    ClientID         INT           PRIMARY KEY,
    Address          VARCHAR(100),
    Email            VARCHAR(100),
    PhoneNumber      INT,
    CreatedDate      DATE
);


-- Table: Staff
CREATE TABLE Staff (
    StaffID          INT           PRIMARY KEY,
    StaffRole        VARCHAR(100),
    LicenseNumber    VARCHAR(30),
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    Email            VARCHAR(100),
    PhoneNumber      INT
);


-- Table: ShareHolders
CREATE TABLE shareHolders (
    ShareHolderID    INT           PRIMARY KEY,
    FirstName        VARCHAR(50),
    LastName         VARCHAR(50),
    contactInfo      VARCHAR(100)
);


-- Table: FinancialInstitution
CREATE TABLE FinancialInstitution (
    InstitutionID    INT           PRIMARY KEY,
    Name             VARCHAR(100),
    contact_info     VARCHAR(200)
);


-- Table: LandRegistryOffice
CREATE TABLE LandRegistryOffice (
    OfficeID         INT           PRIMARY KEY,
    Name             VARCHAR(100),
    contact_info     VARCHAR(200),
    address          VARCHAR(200)
);


-- Table: Appointment
CREATE TABLE Appointment (
    AppointmentID    INT           PRIMARY KEY,
    AppointmentDate  DATE,
    Type             VARCHAR(50),
    Notes            TEXT
);


-- Table: Cases
CREATE TABLE Cases (
    CaseID           INT           PRIMARY KEY,
    CaseType         VARCHAR(50),
    Status           VARCHAR(50),
    OpenDate         DATE,
    DueDate          DATE,
    CloseDate        DATE,
    CaseDescription  TEXT
);


-- Table: ParticipatingParty
CREATE TABLE ParticipatingParty (
    PartyID        INT           PRIMARY KEY,
    Address        VARCHAR(100),
    FirstName      VARCHAR(100),
    LastName       VARCHAR(100),
    Email          VARCHAR(100),
    PhoneNumber    INT,
    CreatedDate    DATE,
    PartyType      VARCHAR(50),
    Relationship   VARCHAR(50)
);


-- Table: PartiesParticipating
CREATE TABLE PartiesParticipating (
    PartyID         INT,
    CaseID          INT,
    RoleinCase      VARCHAR(100),
    DateJoined      DATE, 
    InheritanceShare VARCHAR(100),
    Notes           TEXT,
    PRIMARY KEY (PartyID, CaseID),
    FOREIGN KEY (PartyID)  REFERENCES ParticipatingParty(PartyID),
    FOREIGN KEY (CaseID)  REFERENCES Cases(CaseID)
);


-- Table: corporateClient (subtype of Client)
CREATE TABLE corporateClient (
    CorporateID        INT          PRIMARY KEY,
    CompanyName        VARCHAR(100),
    IncorporationDate  DATE,
    BusinessNumber     INT,
    FOREIGN KEY (CorporateID) REFERENCES Client(ClientID)
);


-- Table: individualClient (subtype of Client)
CREATE TABLE individualClient (
    IndividualID   INT         PRIMARY KEY,
    FirstName      VARCHAR(50),
    LastName       VARCHAR(50),
    DoB            DATE,
    FOREIGN KEY (IndividualID) REFERENCES Client(ClientID)
);


-- Table: corporateShareholders
CREATE TABLE corporateShareholders (
    CorporateID         INT        NOT NULL,
    ShareHolderID       INT        NOT NULL,
    OwnershipPercentage DECIMAL(5,2),
    Position            VARCHAR(50),
    PRIMARY KEY (CorporateID, ShareHolderID),
    FOREIGN KEY (CorporateID)  REFERENCES corporateClient(CorporateID),
    FOREIGN KEY (ShareHolderID) REFERENCES shareHolders(ShareHolderID)
);


-- Table: Marriage
CREATE TABLE Marriage (
    MarriageID           INT         PRIMARY KEY,
    Spouse1ClientID      INT         NOT NULL,
    Spouse2ClientID      INT         NOT NULL,
    MarriageDate         DATE,   
    MaritalRegime        VARCHAR(50),
    AdditionalAgreements TEXT,
    FOREIGN KEY (Spouse1ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (Spouse2ClientID) REFERENCES Client(ClientID)
);


-- Table: IdentificationDocuments
CREATE TABLE IdentificationDocuments (
    DocumentID      INT          PRIMARY KEY,
    ClientID        INT          NOT NULL,
    DocumentType    VARCHAR(50),
    StoragePath     VARCHAR(255),
    VerifiedStatus  INT,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);


-- Table: Payment
CREATE TABLE Payment (
    PaymentID       INT           PRIMARY KEY,
    ClientID        INT           NOT NULL,
    Amount          DECIMAL(10,2),
    PaymentDate     DATE,
    PaymentStatus   VARCHAR(50),
    PaymentMethod   VARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);


-- Table: Documents
CREATE TABLE Documents (
    DocumentID         INT          PRIMARY KEY,
    ClientID           INT          NOT NULL,
    DocumentName       VARCHAR(100),
    DocumentType       VARCHAR(50),
    StoragePath        VARCHAR(255),
    VerificationStatus INT,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);


-- Table: Communication
CREATE TABLE Communication (
    CommunicationID    INT          PRIMARY KEY,
    ClientID           INT          NOT NULL,
    StaffID            INT          NOT NULL,
    CommunicationType  VARCHAR(50),
    CommunicationDate  DATE,
    FollowUpDate       DATE,
    Summary            TEXT,
    Body               TEXT,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (StaffID)  REFERENCES Staff(StaffID)
);


-- Table: AppointmentParticipation
CREATE TABLE AppointmentParticipation (
    AppointmentID   INT   NOT NULL,
    ClientID        INT   NOT NULL,
    StaffID         INT   NOT NULL,
    CaseID          INT,  -- optional
    PRIMARY KEY (AppointmentID, ClientID, StaffID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    FOREIGN KEY (ClientID)      REFERENCES Client(ClientID),
    FOREIGN KEY (StaffID)       REFERENCES Staff(StaffID),
    FOREIGN KEY (CaseID)        REFERENCES Cases(CaseID)
);


-- Table: AssignedTo
CREATE TABLE AssignedTo (
    StaffID    INT      NOT NULL,
    CaseID     INT      NOT NULL,
    Date       DATE,
    PRIMARY KEY (StaffID, CaseID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);


-- Table: CaseParticipation
CREATE TABLE CaseParticipation (
    CaseID      INT      NOT NULL,
    ClientID    INT      NOT NULL,
    RoleinCase  VARCHAR(50),
    Date        DATE,
    PRIMARY KEY (CaseID, ClientID),
    FOREIGN KEY (CaseID)   REFERENCES Cases(CaseID),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID)
);


-- Table: DocumentLibrary
CREATE TABLE DocumentLibrary (
    CaseID      INT   NOT NULL,
    ClientID    INT   NOT NULL,
    DocumentID  INT   NOT NULL,
    DateAdded   DATE,
    PRIMARY KEY (CaseID, ClientID, DocumentID),
    FOREIGN KEY (CaseID)    REFERENCES Cases(CaseID),
    FOREIGN KEY (ClientID)  REFERENCES Client(ClientID),
    FOREIGN KEY (DocumentID) REFERENCES Documents(DocumentID)
);


-- Table: Property
CREATE TABLE Property (
    PropertyID         INT           PRIMARY KEY,
    CaseID             INT           NOT NULL,
    Address            VARCHAR(100),
    LegalDescription   VARCHAR(100),
    TitleStatus        VARCHAR(50),
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);


-- Table: Transaction
CREATE TABLE Transaction (
    TransactionID    INT          PRIMARY KEY,
    CaseID           INT          NOT NULL,
    TransactionDate  DATE,
    Amount           DECIMAL(10,2),
    TransactionType  VARCHAR(50),
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);


-- Table: real_estateTransaction
CREATE TABLE real_estateTransaction (
    TransactionID     INT       NOT NULL,
    PropertyID        INT       NOT NULL,
    InstitutionID     INT       NOT NULL,
    MortgageDetails   TEXT,
    MortgageStatus    VARCHAR(50),
    ServiceType       VARCHAR(50),
    PRIMARY KEY (TransactionID),
    FOREIGN KEY (TransactionID)   REFERENCES Transaction(TransactionID),
    FOREIGN KEY (PropertyID)      REFERENCES Property(PropertyID),
    FOREIGN KEY (InstitutionID)   REFERENCES FinancialInstitution(InstitutionID)
);


-- Table: estateTransaction
CREATE TABLE estateTransaction (
    TransactionID    INT        PRIMARY KEY,
    TotalAssets      VARCHAR(50),
    TotalLiabilities VARCHAR(50),
    Amount           VARCHAR(50),
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID)
);

-- 1. Insert fictive values into Client 
INSERT INTO Client (ClientID, Address, Email, PhoneNumber, CreatedDate) VALUES
(1, '123 Maple Street', 'client1@email.com', 1234567890, '2023-01-15'),
(2, '456 Oak Avenue', 'client2@email.com', 1234567891, '2023-02-20'),
(3, '789 Pine Road', 'client3@email.com', 1234567892, '2023-03-10'),
(4, '101 Birch Blvd', 'client4@email.com', 1234567893, '2023-04-05'),
(5, '202 Cedar Way', 'client5@email.com', 1234567894, '2023-05-25'),
(6, '303 Willow Street', 'client6@email.com', 1234567895, '2023-06-30'),
(7, '404 Elm Street', 'client7@email.com', 1234567896, '2023-07-10'),
(8, '505 Redwood Ave', 'client8@email.com', 1234567897, '2023-08-15'),
(9, '606 Maple Blvd', 'client9@email.com', 1234567898, '2023-09-20'),
(10, '707 Oak Rd', 'client10@email.com', 1234567899, '2023-10-05'),
(11, '808 Pine Street', 'client11@email.com', 1234567800, '2023-11-12'),
(12, '909 Cedar Avenue', 'client12@email.com', 1234567801, '2023-12-01'),
(13, '404 Elm Street', 'client7@email.com', 1234567899, '2023-07-10'),
(14, '606 Maple Blvd', 'client9@email.com', 1234567899, '2023-09-20');


-- 2. Insert fictive values into Staff
INSERT INTO Staff (StaffID, StaffRole, LicenseNumber, FirstName, LastName, Email, PhoneNumber) VALUES
(1, 'Managing Notary', 'LM12345', 'John', 'Doe', 'staff1@email.com', 1234567802),
(2, 'Legal Assistant', 'LA67890', 'Jane', 'Smith', 'staff2@email.com', 1234567803),
(3, 'Estate Planning Consultant', 'LC11223', 'Alice', 'Johnson', 'staff3@email.com', 1234567804),
(4, 'Office Administrator', 'LA44556', 'Bob', 'Brown', 'staff4@email.com', 1234567805),
(5, 'Real Estate Transaction Coordinator', 'LC99887', 'Charlie', 'Davis', 'staff5@email.com', 1234567806),
(6, 'Corporate Counsel', 'LM33445', 'David', 'Martinez', 'staff6@email.com', 1234567807),
(7, 'Notary Assistant (Real Estate)', 'LA22334', 'Eva', 'Wilson', 'staff7@email.com', 1234567808),
(8, 'Real Estate Consultant', 'LC66789', 'Fay', 'Taylor', 'staff8@email.com', 1234567809),
(9, 'Office Administrator', 'LA55445', 'George', 'Lee', 'staff9@email.com', 1234567810),
(10, 'Client Relations Coordinator', 'LC22345', 'Hannah', 'Miller', 'staff10@email.com', 1234567811),
(11, 'Estate Planning Manager', 'LM66777', 'Ivy', 'Taylor', 'staff11@email.com', 1234567812),
(12, 'Legal Assistant (Corporate)', 'LA99876', 'Jack', 'Walker', 'staff12@email.com', 1234567813);


-- 3. Insert fictive values into Cases
INSERT INTO Cases (CaseID, CaseType, Status, OpenDate, DueDate, CloseDate, CaseDescription) VALUES
(1, 'Legal', 'Open', '2025-01-01', '2025-12-31', NULL, 'Contract dispute case'),
(2, 'Financial', 'Closed', '2023-02-01', '2023-06-30', '2023-06-28', 'Financial settlement case'),
(3, 'Property', 'Open', '2023-03-01', '2023-09-30', NULL, 'Property purchase case'),
(4, 'Investment', 'Closed', '2023-04-01', '2023-10-15', '2023-09-20', 'Investment planning case'),
(5, 'Legal', 'Open', '2023-05-10', '2023-11-30', NULL, 'Patent infringement case'),
(6, 'Property', 'Closed', '2023-06-01', '2023-07-01', '2023-06-15', 'Real estate dispute case'),
(7, 'Property', 'Open', '2023-07-01', '2023-12-31', NULL, 'Property purchase case'),
(8, 'Financial', 'Closed', '2023-08-10', '2023-12-10', '2023-11-30', 'Business loan case'),
(9, 'Investment', 'Open', '2023-09-01', '2024-05-15', NULL, 'Investment proposal case'),
(10, 'Property', 'Closed', '2023-10-01', '2023-12-01', '2023-11-30', 'Property legal case'),
(11, 'Mariage', 'Open', '2023-11-01', '2024-03-31', NULL, 'Merger Conflict'),
(12, 'Financial', 'Closed', '2023-12-01', '2024-01-31', '2024-01-15', 'Debt settlement case'),
(13, 'Mariage', 'Closed', '2015-06-01', '2015-07-01', '2015-07-01', 'Marriage contract dispute'),
(14, 'Mariage', 'Closed', '2018-08-01', '2018-09-10', '2018-09-10', 'Pre-nuptial agreement registration'),
(15, 'Mariage', 'Open', '2019-03-01', '2019-09-01', NULL, 'Community property arrangement clarification'),
(16, 'Legal', 'Open', '2025-02-01', '2025-12-31', NULL, 'Succession dispute case');


-- 4. Insert fictive values into ParticipatingParty
INSERT INTO ParticipatingParty (PartyID, Address, FirstName, LastName, Email, PhoneNumber, CreatedDate, PartyType, Relationship) VALUES
(1, '123 Maple Street', 'Lucas', 'Harris', 'party1@email.com', 1234567890, '2023-01-10', 'Individual', 'Client'),
(2, '456 Oak Avenue', 'Mia', 'Clark', 'party2@email.com', 1234567891, '2023-02-20', 'Corporate', 'Client'),
(3, '789 Pine Road', 'Ethan', 'Walker', 'party3@email.com', 1234567892, '2023-03-15', 'Individual', 'Witness'),
(4, '101 Birch Blvd', 'Chloe', 'King', 'party4@email.com', 1234567893, '2023-04-05', 'Corporate', 'Supplier'),
(5, '202 Cedar Way', 'Ava', 'Scott', 'party5@email.com', 1234567894, '2023-05-25', 'Individual', 'Defendant'),
(6, '303 Willow Street', 'Noah', 'Young', 'party6@email.com', 1234567895, '2023-06-30', 'Corporate', 'Partner'),
(7, '404 Elm Street', 'Isabella', 'Green', 'party7@email.com', 1234567896, '2023-07-10', 'Individual', 'Attorney'),
(8, '505 Redwood Ave', 'Jackson', 'Adams', 'party8@email.com', 1234567897, '2023-08-15', 'Corporate', 'Consultant'),
(9, '606 Maple Blvd', 'Olivia', 'Baker', 'party9@email.com', 1234567898, '2023-09-20', 'Individual', 'Witness'),
(10, '707 Oak Rd', 'Liam', 'Carter', 'party10@email.com', 1234567899, '2023-10-05', 'Corporate', 'Vendor'),
(11, '808 Pine Street', 'Grace', 'Morris', 'party11@email.com', 1234567800, '2023-11-12', 'Individual', 'Defendant'),
(12, '909 Cedar Avenue', 'Benjamin', 'Rodriguez', 'party12@email.com', 1234567801, '2023-12-01', 'Corporate', 'Supplier'),
(13, '111 New St', 'Thomas', 'Moran', 'party13@email.com', 5551234, '2025-01-01', 'Individual', 'Executor'),
(14, '456 Aylmer St', 'Julie', 'Rase', 'party14@email.com', 1234567891, '2023-10-05', 'Individual', 'Executor');


-- 5. Insert fictive values into PartiesParticipating
INSERT INTO PartiesParticipating (PartyID, CaseID, RoleinCase, DateJoined, InheritanceShare, Notes) VALUES
(1, 1, 'Plaintiff Representative', '2025-01-10', '60%', 'Leading the claim process.'),
(2, 1, 'Corporate Client', '2025-01-12', '40%', 'Joint stakeholder in dispute.'),
(3, 3, 'Witness', '2023-03-18', 'N/A', 'Eyewitness to property transaction.'),
(4, 5, 'Supplier', '2023-05-05', '25%', 'Involved in a supply contract.'),
(5, 5, 'Defendant', '2023-05-07', '75%', 'Accused in patent case.'),
(6, 6, 'Legal Partner', '2023-06-12', 'N/A', 'Represents the co-defendant.'),
(7, 8, 'Executor', '2023-08-15', 'N/A', 'Handling asset distribution'),
(8, 9, 'Executor', '2023-09-10', '30%', 'Debt settlements.'),
(9, 9, 'Witness', '2023-09-11', '20%', 'Testified regarding contract terms.'),
(10, 9, 'Vendor', '2023-09-12', '50%', 'Previous owner of the property.'),
(11, 10, 'Beneficiary', '2023-11-15', '50%', 'Claimant of shared inheritance.'),
(12, 11, 'Co-Beneficiary', '2023-11-16', '50%', 'Equal heir in estate case'),
(13, 1, 'Executor', '2025-01-02', 'N/A', 'Will executor'),
(14, 16, 'Executor', '2025-02-02', 'N/A', 'Executor for succession');


-- 6. Insert fictive values into corporateClient
INSERT INTO corporateClient (CorporateID, CompanyName, IncorporationDate, BusinessNumber) VALUES
(2, 'Tech Innovations Inc.', '2021-01-15', 123456789),
(4, 'Eco Solutions Ltd.', '2020-05-20', 234567890),
(5, 'Green Planet Enterprises', '2022-07-30', 345678901),
(8, 'Global Ventures LLC', '2021-11-10', 456789012),
(11, 'Modern Design Co.', '2020-02-25', 567890123),
(12, 'Future Tech Corp.', '2023-03-18', 678901234);


-- 7. Insert fictive values into individualClient
INSERT INTO individualClient (IndividualID, FirstName, LastName, DoB) VALUES
(1, 'John', 'Doe', '1985-05-10'),
(3, 'Sarah', 'Smith', '1990-08-20'),
(6, 'Michael', 'Johnson', '1995-01-15'),
(7, 'Emily', 'Williams', '1987-04-30'),
(9, 'David', 'Brown', '1992-11-12'),
(10, 'Laura', 'Jones', '1991-03-25'),
(13, 'Jean', 'Lomel', '1995-08-02'),
(14, 'Eric', 'Shen', '1990-09-04');


-- 8. Insert fictive values into shareHolders
INSERT INTO shareHolders (ShareHolderID, FirstName, LastName, contactInfo) VALUES
(1, 'Richard', 'Roe', 'richard@example.com'),
(5, 'Mary', 'Major', 'mary@example.com'),
(7, 'James', 'Bond', 'james@example.com'),
(9, 'Patricia', 'Clark', 'patricia@example.com'),
(11, 'Robert', 'Smith', 'robert@example.com');


-- 8. Insert fictive values into corporateShareholders
INSERT INTO corporateShareholders (CorporateID, ShareHolderID, OwnershipPercentage, Position) VALUES
(2, 1, 50.00, 'CEO'),
(4, 5, 40.00, 'Founder'),
(5, 9, 60.00, 'CEO'),
(8, 1, 55.00, 'Director'),
(11, 7, 20.00, 'COO'),
(12, 11, 50.00, 'CFO');


-- 9. Insert fictive values into Marriage
INSERT INTO Marriage (MarriageID, Spouse1ClientID, Spouse2ClientID, MarriageDate, MaritalRegime, AdditionalAgreements) VALUES
  (1, 1, 3, '2015-06-15', 'Community Property', 'None'),
  (2, 13, 7, '2018-09-10', 'Separation of Property', 'Pre-nuptial agreement'),
  (3, 9, 14, '2019-03-25', 'Community Property', 'None');


-- 10. Insert fictive values into IdentificationDocuments
INSERT INTO IdentificationDocuments (DocumentID, ClientID, DocumentType, StoragePath, VerifiedStatus) VALUES
(1, 1, 'Passport', '/docs/1_passport.jpg', 1),
(2, 2, 'Driver License', '/docs/2_license.jpg', 1),
(3, 3, 'National ID', '/docs/3_nationalid.jpg', 0),
(4, 4, 'Passport', '/docs/4_passport.jpg', 1),
(5, 5, 'Driver License', '/docs/5_license.jpg', 1),
(6, 6, 'National ID', '/docs/6_nationalid.jpg', 0),
(7, 7, 'Passport', '/docs/7_passport.jpg', 1),
(8, 8, 'Driver License', '/docs/8_license.jpg', 1),
(9, 9, 'National ID', '/docs/9_nationalid.jpg', 0),
(10, 10, 'Passport', '/docs/10_passport.jpg', 1),
(11, 11, 'Driver License', '/docs/11_license.jpg', 1),
(12, 12, 'National ID', '/docs/12_nationalid.jpg', 0);


-- 11. Insert fictive values into Payment
INSERT INTO Payment (PaymentID, ClientID, Amount, PaymentDate, PaymentStatus, PaymentMethod) VALUES
(1, 1, 150.00, '2023-01-05', 'Completed', 'Credit Card'),
(2, 2, 250.00, '2023-02-10', 'Completed', 'PayPal'),
(3, 3, 300.00, '2023-03-15', 'Pending', 'Bank Transfer'),
(4, 4, 120.00, '2023-04-01', 'Completed', 'Credit Card'),
(5, 4, 450.00, '2023-05-25', 'Completed', 'PayPal'),
(6, 6, 500.00, '2023-06-30', 'Pending', 'Bank Transfer'),
(7, 6, 200.00, '2023-07-05', 'Completed', 'Credit Card'),
(8, 8, 350.00, '2023-08-10', 'Completed', 'PayPal'),
(9, 9, 600.00, '2023-09-20', 'Pending', 'Bank Transfer'),
(10, 9, 250.00, '2023-10-01', 'Completed', 'Credit Card'),
(11, 11, 100.00, '2023-11-12', 'Completed', 'PayPal'),
(12, 12, 150.00, '2023-12-05', 'Pending', 'Bank Transfer'),
(13, 1, 180.00, '2023-01-20', 'Completed', 'PayPal'),
(14, 2, 220.00, '2023-02-18', 'Pending', 'Credit Card'),
(15, 3, 310.00, '2023-03-25', 'Completed', 'Bank Transfer'),
(16, 5, 400.00, '2023-04-15', 'Completed', 'PayPal'),
(17, 5, 350.00, '2023-04-30', 'Pending', 'Credit Card'),
(18, 7, 275.00, '2023-05-20', 'Completed', 'Credit Card'),
(19, 7, 125.00, '2023-05-28', 'Pending', 'PayPal'),
(20, 8, 390.00, '2023-09-01', 'Completed', 'Bank Transfer'),
(21, 10, 260.00, '2023-10-18', 'Completed', 'PayPal'),
(22, 11, 180.00, '2023-11-20', 'Pending', 'Credit Card'),
(23, 12, 200.00, '2023-12-15', 'Completed', 'Bank Transfer'),
(24, 6, 320.00, '2023-07-15', 'Completed', 'PayPal'),
(25, 1, 200.00, '2025-03-01', 'Pending', 'Credit Card');


-- 12. Insert fictive values into Documents
INSERT INTO Documents (DocumentID, ClientID, DocumentName, DocumentType, StoragePath, VerificationStatus) VALUES
(1, 1, 'Contract 1', 'Contract', '/docs/1_contract.pdf', 1),
(2, 2, 'Agreement 2', 'Agreement', '/docs/2_agreement.pdf', 0),
(3, 3, 'Invoice 3', 'Invoice', '/docs/3_invoice.pdf', 1),
(4, 4, 'Proposal 4', 'Proposal', '/docs/4_proposal.pdf', 1),
(5, 5, 'Report 5', 'Report', '/docs/5_report.pdf', 0),
(6, 6, 'Agreement 6', 'Agreement', '/docs/6_agreement.pdf', 1),
(7, 7, 'Contract 7', 'Contract', '/docs/7_contract.pdf', 0),
(8, 8, 'Invoice 8', 'Invoice', '/docs/8_invoice.pdf', 1),
(9, 9, 'Proposal 9', 'Proposal', '/docs/9_proposal.pdf', 0),
(10, 10, 'Report 10', 'Report', '/docs/10_report.pdf', 1),
(11, 11, 'Agreement 11', 'Agreement', '/docs/11_agreement.pdf', 1),
(12, 12, 'Contract 12', 'Contract', '/docs/12_contract.pdf', 0),
(13, 1, 'Last Will', 'Will', '/docs/13_last_will.pdf', 1),
(14, 1, 'Succession Deed', 'Deed', '/docs/14_succession_deed.pdf', 1),
(15, 2, 'Minute Book 2025', 'Minute Book', '/docs/15_minute_book.pdf', 1);


-- 13. Insert fictive values into Communication 
INSERT INTO Communication (CommunicationID, ClientID, StaffID, CommunicationType, CommunicationDate, FollowUpDate, Summary, Body) VALUES
(1, 1, 1, 'Email', '2023-01-10', '2023-01-12', 'Consultation on new project', 'Discussed details of upcoming project with client.'),
(2, 2, 2, 'Phone', '2023-02-15', '2023-02-17', 'Follow-up on case status', 'Followed up on status of legal case.'),
(3, 3, 3, 'Email', '2023-03-20', '2023-03-22', 'Financial consultation', 'Discussed financial planning and goals with client.'),
(4, 4, 4, 'Phone', '2023-04-10', '2023-04-12', 'Property inquiry', 'Inquired about available properties for purchase.'),
(5, 5, 5, 'Email', '2023-05-05', '2023-05-07', 'Consultation on investment options', 'Explained various investment options to the client.'),
(6, 6, 6, 'Phone', '2023-06-15', '2023-06-17', 'Follow-up on case progress', 'Followed up on client case to check for progress.'),
(7, 7, 7, 'Email', '2023-07-20', '2023-07-22', 'Legal advice request', 'Provided legal advice regarding contract dispute.'),
(8, 8, 8, 'Phone', '2023-08-25', '2023-08-27', 'Property sale discussion', 'Discussed terms of property sale and agreement.'),
(9, 9, 9, 'Email', '2023-09-30', '2023-10-02', 'Investment update', 'Updated client on progress of current investments.'),
(10, 10, 10, 'Phone', '2023-10-12', '2023-10-14', 'Case review', 'Reviewed ongoing case details with the client.'),
(11, 11, 11, 'Email', '2023-11-03', '2023-11-05', 'Financial review', 'Provided a financial overview and suggestions for improvements.'),
(12, 12, 12, 'Phone', '2023-12-05', '2023-12-07', 'Debt settlement consultation', 'Discussed options for debt settlement with client.'),
(13, 1, 1, 'Email', '2025-04-05', '2025-04-10', 'Upcoming follow-up', 'Discussion regarding case progress.');


-- 14. Insert fictive values into Appointment
INSERT INTO Appointment (AppointmentID, AppointmentDate, Type, Notes) VALUES
(1, '2025-01-15', 'Consultation', 'First consultation'),
(2, '2025-02-15', 'Review', 'Follow-up review'),
(3, '2025-03-20', 'Consultation', 'Initial meeting'),
(4, '2025-04-10', 'Consultation', 'Property discussion'),
(5, '2025-05-05', 'Review', 'Case review'),
(6, '2025-06-15', 'Consultation', 'Regular update'),
(7, '2025-07-20', 'Consultation', 'Initial consultation'),
(8, '2025-08-25', 'Review', 'Follow-up meeting'),
(9, '2025-09-30', 'Consultation', 'Discussion of terms'),
(10, '2025-10-12', 'Review', 'Progress review'),
(11, '2025-11-03', 'Consultation', 'Initial consultation'),
(12, '2025-12-05', 'Review', 'Final review');


-- 15. Insert fictive values into AppointmentParticipation
INSERT INTO AppointmentParticipation (AppointmentID, ClientID, StaffID, CaseID) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5),
(6, 6, 6, 6),
(7, 7, 7, 7),
(8, 8, 8, 8),
(9, 9, 9, 9),
(10, 10, 10, 10),
(11, 11, 11, 11),
(12, 12, 12, 12);




-- 16. Insert fictive values into AssignedTo
INSERT INTO AssignedTo (StaffID, CaseID, Date) VALUES
(1, 1,'2025-01-01'),
(2, 2,'2023-02-01'),
(3, 3,'2023-03-01'),
(4, 4,'2023-04-01'),
(5, 5, '2023-05-01'),
(6, 6, '2023-06-01'),
(7, 7, '2023-07-01'),
(8, 8, '2023-08-01'),
(9, 9, '2023-09-01'),
(10, 10,'2023-10-01'),
(11, 11,'2023-11-01'),
(12, 12,'2023-12-01');


-- 17. Insert fictive values into CaseParticipation
INSERT INTO CaseParticipation (CaseID, ClientID, RoleinCase, Date) VALUES
(1, 1, 'Plaintiff', '2025-01-01'),
(2, 2, 'Defendant', '2023-02-01'),
(1, 3, 'Beneficiary', '2025-01-05'),
(3, 3, 'Plaintiff', '2023-03-01'),
(3, 4, 'Defendant', '2023-04-01'),
(5, 5, 'Plaintiff', '2023-05-01'),
(6, 6, 'Defendant', '2023-06-01'),
(7, 7, 'Plaintiff', '2023-07-01'),
(8, 8, 'Defendant', '2023-08-01'),
(8, 9, 'Plaintiff', '2023-09-01'),
(10, 10, 'Defendant', '2023-10-01'),
(11, 11, 'Plaintiff', '2023-11-01'),
(11, 12, 'Defendant', '2023-12-01'),
(13, 1, 'Spouse', '2015-06-01'),
(13, 3, 'Spouse', '2015-06-01'),
(14, 5, 'Spouse', '2018-08-01'),
(14, 7, 'Spouse', '2018-08-01'),
(15, 9, 'Spouse', '2019-03-01'),
(15, 11, 'Spouse', '2019-03-01'),
(16, 1, 'Deceased', '2025-02-01'),
(16, 3, 'Heir', '2025-02-03');


-- 18. Insert fictive values into DocumentLibrary
INSERT INTO DocumentLibrary (CaseID, ClientID, DocumentID, DateAdded) VALUES
(1, 1, 1, '2025-01-05'),
(2, 2, 2, '2023-02-10'),
(3, 3, 3, '2023-03-15'),
(4, 4, 4, '2023-04-10'),
(5, 5, 5, '2023-05-25'),
(6, 6, 6, '2023-06-30'),
(7, 7, 7, '2023-07-05'),
(8, 8, 8, '2023-08-10'),
(9, 9, 9, '2023-09-20'),
(10, 10, 10, '2023-10-01'),
(11, 11, 11, '2023-11-12'),
(12, 12, 12, '2023-12-05'),
(1, 1, 13, '2025-01-20'),
(16, 1, 14, '2025-02-05');


-- 19. Insert fictive values into Property
INSERT INTO Property (PropertyID, CaseID, Address, LegalDescription, TitleStatus) VALUES
(3, 3, '789 Pine Rd', 'Residential Property', 'Under Dispute'),
(6, 6, '303 Willow St', 'Commercial Property', 'Encumbered'),
(7, 7, '404 Elm St', 'Residential Property', 'Clear Title'),
(10, 10, '707 Oak Rd', 'Residential Property', 'Clear Title');


-- 20. Insert fictive values into Transaction
INSERT INTO Transaction (TransactionID, CaseID, TransactionDate, Amount, TransactionType) VALUES
(1, 1, '2025-01-05', 1000.00, 'Cheque'),
(2, 2, '2023-02-10', 1500.00, 'Credit Card'),
(3, 3, '2023-03-15', 2000.00, 'Transfer'),
(4, 4, '2023-04-10', 2500.00, 'Cash'),
(5, 5, '2023-05-25', 3000.00, 'Cheque'),
(6, 6, '2023-06-30', 3500.00, 'Credit Card'),
(7, 7, '2023-07-05', 4000.00, 'Transfer'),
(8, 8, '2023-08-10', 4500.00, 'Cash'),
(9, 9, '2023-09-20', 5000.00, 'Cheque'),
(10, 10, '2023-10-01', 5500.00, 'Credit Card'),
(11, 11, '2023-11-12', 6000.00, 'Transfer'),
(12, 12, '2023-12-05', 6500.00, 'Cash'),
(13, 16, '2025-04-05', 3000.00, 'Credit Card');


-- 21. Insert fictive values into FinancialInstitution
INSERT INTO FinancialInstitution (InstitutionID, Name, contact_info) VALUES
(1, 'First National Bank', 'contact@fnb.com'),
(2, 'Global Finance Corp', 'info@globalfinance.com'),
(3, 'Mortgage Solutions Inc.', 'support@mortgagesolutions.com');


-- 22. Insert fictive values into real_estateTransaction
INSERT INTO real_estateTransaction (TransactionID, PropertyID, InstitutionID, MortgageDetails, MortgageStatus, ServiceType) VALUES
(3, 3, 3, 'Refinance existing mortgage', 'Approved', 'Property Refinance'),
(6, 6, 3, 'Discharging mortgage on full payment', 'Completed', 'Mortgage Discharge'),
(7, 7, 1, 'New 10-year mortgage at 4%', 'Approved', 'Mortgage Registration'),
(10, 10, 1, 'Legal advisory session', 'N/A', 'Professional Consultation');


-- 23. Insert fictive values into estateTransaction
INSERT INTO estateTransaction (TransactionID, TotalAssets, TotalLiabilities, Amount) VALUES
	(1, '11000000', '5500000', '5500000'),
	(2, '12000000', '16485986', '3000000'),
    (4, '27481044', '35920576', '6000000'),
    (8, '13367777', '24567954', '6000000'),
	(9, '23588000', '23343340', '3000000'),
(13, '455500000', '56000', '5677777');
