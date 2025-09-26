-- 1. CLIENT INTAKE FORM


-- Query 1: Individual Client Intake Information


-- Objective: Retrieve personal details and all associated case information for individual clients.
SELECT
    cp.ClientID AS Individual_Client_ID,          -- Unique ID of the individual client
    ic.FirstName,                                 -- Client's first name
    ic.LastName,                                  -- Client's last name
    FLOOR(DATEDIFF(CURRENT_DATE, ic.DoB) / 365) AS Age, -- Client's age calculated from date of birth
    ca.CaseDescription,                           -- Description of the associated case
    cp.CaseID,                                    -- Unique ID of the associated case
    cl.Email,                                     -- Client's email address
    cl.PhoneNumber                                -- Client's phone number
FROM Cases AS ca
-- Join cases with their respective participation details
JOIN CaseParticipation AS cp ON cp.CaseID = ca.CaseID
-- Join to get general client information (email, phone)
JOIN Client AS cl ON cl.ClientID = cp.ClientID
-- Join specifically for individual client details (first name, last name, DOB)
JOIN individualClient AS ic ON ic.IndividualID = cl.ClientID;




-- Query 2: Corporate Client Details with Shareholders


-- Objective: Retrieve comprehensive details about corporate clients, their cases, and shareholder information.
SELECT
    cp.CaseID,                                    -- Unique ID of the case
    ca.CaseDescription,                           -- Description of the associated case
    cc.CorporateID,                               -- Unique ID of the corporate client
    cc.CompanyName,                               -- Corporate client's company name
    cl.Email AS Company_Email,                    -- Company's email contact
    cl.PhoneNumber AS Company_PhoneNumber,        -- Company's phone number
    cs.ShareHolderID,                             -- Unique ID of the shareholder
    sh.FirstName AS Shareholder_First_Name,       -- Shareholder's first name
    sh.LastName AS Shareholder_Last_Name,         -- Shareholder's last name
    sh.contactInfo AS Shareholder_contact         -- Shareholder's contact information
FROM Cases AS ca
-- Connect cases to their participation details
JOIN CaseParticipation AS cp ON cp.CaseID = ca.CaseID
-- Retrieve general client information for the corporate entity
JOIN Client AS cl ON cl.ClientID = cp.ClientID
-- Filter specifically to corporate client details
JOIN corporateClient AS cc ON cc.CorporateID = cl.ClientID
-- Retrieve information about corporate shareholders
JOIN corporateShareholders AS cs ON cs.CorporateID = cc.CorporateID
-- Detailed shareholder information
JOIN shareHolders AS sh ON sh.ShareHolderID = cs.ShareHolderID;


-- 2. CASE DETAILS FORM


-- Query 1: Retrieve detailed case information along with the assigned staff details.


-- Objective: Retrieve detailed information for each legal case, including its type, status, relevant dates (open, due, and close dates),
-- and the staff member (e.g., notary) assigned to it. This query provides a comprehensive view of each case along with the associated staff details.
SELECT
    c.CaseID,                      -- Unique identifier of the case
    c.CaseType,                    -- Type of case (e.g., property, inheritance, etc.)
    c.Status,                      -- Current status (e.g., Open, Closed, In Progress)
    c.OpenDate,                    -- Date the case was opened
    c.DueDate,                     -- Expected completion date
    c.CloseDate,                   -- Actual date the case was closed (if applicable)
    ato.StaffID AS Assigned_StaffID,  -- ID of the staff member assigned to the case
    s.StaffRole,                   -- Role of the staff member (e.g., Notary, Assistant)
    s.FirstName AS Staff_First_Name,  -- First name of the assigned staff member
    s.LastName AS Staff_Last_Name     -- Last name of the assigned staff member
FROM Cases AS c
JOIN AssignedTo AS ato ON ato.CaseID = c.CaseID  -- Link each case to its assignment record
JOIN Staff AS s ON s.StaffID = ato.StaffID;      -- Retrieve detailed staff information


-- Query 2: Calculate performance insights for staff by determining average case closure time.


-- Objective: Provide performance insights by calculating the average closure time (in days) for cases per staff member.
-- Additionally, display the total number of cases assigned to each staff member.
-- This helps in identifying efficiency and workload distribution among staff.
SELECT
    a.StaffID,                                   -- Unique identifier of the staff member
    s.FirstName,                                 -- First name of the staff member
    s.LastName,                                  -- Last name of the staff member
    s.StaffRole,                                 -- Role within the organization
    COUNT(a.CaseID) AS TotalAssignedCases,       -- Total number of cases assigned to the staff member
    AVG(DATEDIFF(c.CloseDate, c.OpenDate)) AS AvgCaseClosureTime  -- Average duration (in days) to close a case
FROM AssignedTo a
JOIN Cases c ON a.CaseID = c.CaseID               -- Join to access case dates for open and close
JOIN Staff s ON a.StaffID = s.StaffID             -- Join to access staff member details
GROUP BY a.StaffID;                                   -- Aggregate data per staff member


-- 3 REAL ESTATE TRANSACTION FORM


-- Objective: Retrieve details of properties involved in real estate transactions, along with buyer/seller information, transaction values, and participating party details.
SELECT
    p.*,                                            -- All property details involved in the transaction
    cl.ClientID,                                    -- Unique ID of the client (buyer or seller)
    CASE                                            -- Determines if the client is an individual or corporate and returns the appropriate name
        WHEN indiv_cl.IndividualID IS NOT NULL
            THEN CONCAT(indiv_cl.FirstName, ' ', indiv_cl.LastName)
        WHEN corpo_cl.CorporateID IS NOT NULL
            THEN corpo_cl.CompanyName
        ELSE 'Unknown'
    END AS Client_Name,
    t.Amount,                                       -- Transaction amount
    ppy.PartyID AS Participating_PartyID,           -- Unique ID of a participating party in the case
    ppy.Email AS Participating_PartyEmail,          -- Email of the participating party
    ppy.FirstName AS Participating_Party_FirstName, -- First name of the participating party
    ppy.LastName AS Participating_Party_LastName    -- Last name of the participating party
FROM Cases c
-- Connect cases to their corresponding transactions
JOIN Transaction t ON t.CaseID = c.CaseID
-- Specifically for real estate transaction details
JOIN real_estateTransaction rt ON rt.TransactionID = t.TransactionID
-- Property details linked to the real estate transaction
JOIN Property p ON p.PropertyID = rt.PropertyID
-- Link clients participating in each case
JOIN CaseParticipation cp ON cp.CaseID = c.CaseID
JOIN Client cl ON cp.ClientID = cl.ClientID
-- Optional join to retrieve individual client details
LEFT JOIN individualClient indiv_cl ON indiv_cl.IndividualID = cl.ClientID
-- Optional join to retrieve corporate client details
LEFT JOIN corporateClient corpo_cl ON corpo_cl.CorporateID = cl.ClientID
-- Optional joins to include details about any other parties participating in the case
LEFT JOIN PartiesParticipating AS pp ON pp.CaseID = c.CaseID
LEFT JOIN ParticipatingParty AS ppy ON ppy.PartyID = pp.PartyID;


-- 4. ESTATE PLANNING FORM AND EXECUTOR DETAILS


-- Objective: Retrieve executor personal details, associated case information, and financial information relevant to estate planning cases. This query specifically filters for executors.
SELECT
    -- Executor's personal details
    pp.FirstName AS ExecutorFirstName,       -- First name of the executor
    pp.LastName AS ExecutorLastName,         -- Last name of the executor
    pp.Email AS ExecutorEmail,               -- Email of the executor
    pp.PhoneNumber AS ExecutorPhone,         -- Phone number of the executor
    pp.Address AS ExecutorAddress,           -- Address of the executor


    -- Associated case information
    c.CaseID,                                -- Unique ID of the estate planning case
    c.CaseDescription,                       -- Description of the estate planning case


    -- Estate financial details
    et.TotalAssets,                          -- Total assets involved in the estate
    et.TotalLiabilities,                     -- Total liabilities associated with the estate
    et.Amount AS NetAmount                   -- Net value of the estate (assets minus liabilities)


FROM Cases c
-- Join to identify parties participating specifically as executors in each case
JOIN PartiesParticipating ppart ON c.CaseID = ppart.CaseID
-- Retrieve detailed personal information for the executor
JOIN ParticipatingParty pp ON ppart.PartyID = pp.PartyID
-- Link to transaction information relevant to the estate
JOIN Transaction t ON c.CaseID = t.CaseID
-- Specific financial details relevant to the estate transaction
JOIN estateTransaction et ON t.TransactionID = et.TransactionID


-- Filtering criteria to include only executors in the estate cases
WHERE ppart.RoleinCase = 'Executor';


-- 5.  CORPORATE SERVICE FORM: CORPORATE CLIENT AND SHAREHOLDERS


-- Objective: Retrieve detailed corporate client information and their associated shareholder details.
SELECT
    -- Corporate client details
    cc.CorporateID,                           -- Unique ID of the corporate client
    cc.CompanyName,                           -- Name of the corporate client
    cc.IncorporationDate,                     -- Date of incorporation of the corporate client
    cc.BusinessNumber,                        -- Business registration number


    -- Shareholder details
    sh.ShareHolderID,                         -- Unique ID of the shareholder
    sh.FirstName AS ShareHolderFirstName,     -- Shareholder's first name
    sh.LastName AS ShareHolderLastName,       -- Shareholder's last name
    cs.OwnershipPercentage,                   -- Percentage of ownership held by the shareholder
    cs.Position                               -- Position held by the shareholder within the company


FROM corporateClient cc
-- Join to connect corporate clients with their shareholders
JOIN corporateShareholders cs ON cc.CorporateID = cs.CorporateID
-- Join to get detailed information about each shareholder
JOIN shareHolders sh ON cs.ShareHolderID = sh.ShareHolderID;


-- 6. APPOINTMENT SCHEDULER FORM


-- Objective: Retrieve detailed information about scheduled appointments, including associated client and staff details.
SELECT
    a.AppointmentID,                         -- Unique ID of the appointment
    a.AppointmentDate,                       -- Date of the appointment
    a.Type,                                  -- Type of appointment (e.g., Consultation, Review)
   
    -- Client details
    c.ClientID,                              -- Unique ID of the client
    c.Email AS ClientEmail,                  -- Email address of the client


    -- Staff details
    s.StaffID,                               -- Unique ID of the staff member
    s.FirstName AS StaffFirstName,           -- First name of the staff member
    s.LastName AS StaffLastName,             -- Last name of the staff member
    s.Email AS StaffEmail                    -- Email address of the staff member


FROM AppointmentParticipation ap
-- Join to retrieve appointment details
JOIN Appointment a ON ap.AppointmentID = a.AppointmentID
-- Join to retrieve client details linked to the appointment
JOIN Client c ON ap.ClientID = c.ClientID
-- Join to retrieve staff details participating in the appointment
JOIN Staff s ON ap.StaffID = s.StaffID;


-- 7. REAL ESTATE SERVICES FORM


-- Objective: Retrieve comprehensive details about real estate services, including service type, property details, financial institutions involved, client information, and the assigned notary.
SELECT
    ret.ServiceType,                           -- Type of real estate service provided (e.g., mortgage registration)
    p.Address AS PropertyAddress,              -- Address of the property involved
    p.LegalDescription,                        -- Legal description of the property
    fi.Name AS FinancialInstitution,           -- Name of the financial institution involved


    -- Client information
    c.ClientID,                                -- Unique ID of the client
    ic.FirstName AS ClientFirstName,           -- Client's first name
    ic.LastName AS ClientLastName,             -- Client's last name


    -- Assigned notary information
    s.StaffID,                                 -- Unique ID of the notary staff member
    s.FirstName AS NotaryFirstName,            -- Notary's first name
    s.LastName AS NotaryLastName               -- Notary's last name


FROM real_estateTransaction ret
-- Property details linked to the transaction
JOIN Property p ON ret.PropertyID = p.PropertyID
-- Financial institution details involved in the real estate transaction
JOIN FinancialInstitution fi ON ret.InstitutionID = fi.InstitutionID
-- Transaction details for the service
JOIN Transaction t ON ret.TransactionID = t.TransactionID
-- Connect to case details
JOIN Cases cs ON t.CaseID = cs.CaseID
-- Client details associated with the case
JOIN CaseParticipation cp ON cs.CaseID = cp.CaseID
JOIN Client c ON cp.ClientID = c.ClientID
-- Optional join for individual client-specific information
LEFT JOIN individualClient ic ON c.ClientID = ic.IndividualID
-- Notary details assigned to the real estate case
JOIN AssignedTo a ON a.CaseID = cs.CaseID
JOIN Staff s ON a.StaffID = s.StaffID;


-- 8. WILL AND MANDATES FORM


-- Objective: Retrieve detailed information about wills and mandates, including document details, client info, beneficiaries, executors, and special provisions.
SELECT
    d.DocumentID,                               -- Unique identifier of the document (Will/Mandate)
    c.ClientID,                                 -- Unique identifier of the client associated with the document
    ic.FirstName AS ClientFirstName,            -- Client's first name (from individual clients)
    ic.LastName AS ClientLastName,              -- Client's last name (from individual clients)
    d.DocumentType,                             -- Document type indicating 'Will' or 'Mandate'


    -- Beneficiary details: the individual(s) receiving benefits from the document
    ben.FirstName AS BeneficiaryFirstName,
    ben.LastName AS BeneficiaryLastName,
    ben.Email AS BeneficiaryEmail,
    ben.PhoneNumber AS BeneficiaryPhoneNumber,


    -- Executor details: the person(s) responsible for executing the terms of the will/mandate
    ex.FirstName AS ExecutorFirstName,
    ex.LastName AS ExecutorLastName,
    ex.Email AS ExecutorEmail,
    ex.PhoneNumber AS ExecutorPhoneNumber,


    -- Special provisions or additional notes stored with the document
    d.StoragePath AS SpecialProvisions


FROM Documents d
-- Link each document to the respective client
JOIN Client c ON d.ClientID = c.ClientID
-- Fetch client name details if client is an individual
LEFT JOIN individualClient ic ON c.ClientID = ic.IndividualID
-- Connect documents to specific cases to retrieve role-based participants
LEFT JOIN DocumentLibrary dl ON d.DocumentID = dl.DocumentID
-- Identify beneficiaries involved in the specific case
LEFT JOIN CaseParticipation cp_ben ON dl.CaseID = cp_ben.CaseID AND cp_ben.RoleinCase = 'Beneficiary'
LEFT JOIN ParticipatingParty ben ON cp_ben.ClientID = ben.PartyID
-- Identify executors involved in the specific case
LEFT JOIN PartiesParticipating pp_ex ON dl.CaseID = pp_ex.CaseID AND pp_ex.RoleinCase = 'Executor'
LEFT JOIN ParticipatingParty ex ON pp_ex.PartyID = ex.PartyID
-- Only select documents of type 'Will' or 'Mandate'
WHERE d.DocumentType IN ('Will', 'Mandate');


-- 9. SUCCESSION FORM


-- Objective: Retrieve information related to succession cases, including details of the deceased, executors, heirs, estate financials, and notarized documents.
SELECT
    cs.CaseID,                                  -- Unique identifier for the succession case


    -- Deceased client's personal and contact details
    c.ClientID AS DeceasedClientID,
    ic.FirstName AS DeceasedFirstName,
    ic.LastName AS DeceasedLastName,
    c.Email AS DeceasedEmail,
    c.PhoneNumber AS DeceasedPhoneNumber,


    -- Executor details responsible for managing the deceased's estate
    ex.PartyID AS ExecutorID,
    ex.FirstName AS ExecutorFirstName,
    ex.LastName AS ExecutorLastName,
    ex.Email AS ExecutorEmail,
    ex.PhoneNumber AS ExecutorPhoneNumber,


    -- Heir details: individuals inheriting from the estate
    pp.PartyID AS HeirID,
    pp.FirstName AS HeirFirstName,
    pp.LastName AS HeirLastName,
    pp.Email AS HeirEmail,
    pp.PhoneNumber AS HeirPhoneNumber,


    -- Estate financial details indicating assets, liabilities, and net value
    et.TotalAssets,
    et.TotalLiabilities,
    et.Amount AS NetEstateValue,


    -- Associated document details
    d.DocumentName,
    d.DocumentType,
    d.StoragePath


FROM Cases cs
-- Identify deceased client involved in the case
JOIN CaseParticipation cp_deceased ON cp_deceased.CaseID = cs.CaseID AND cp_deceased.RoleinCase = 'Deceased'
JOIN Client c ON c.ClientID = cp_deceased.ClientID
LEFT JOIN individualClient ic ON c.ClientID = ic.IndividualID
-- Executors linked to the specific succession case
LEFT JOIN PartiesParticipating pp_exec ON pp_exec.CaseID = cs.CaseID AND pp_exec.RoleinCase = 'Executor'
LEFT JOIN ParticipatingParty ex ON ex.PartyID = pp_exec.PartyID
-- Heirs linked to the specific succession case
LEFT JOIN CaseParticipation cp_heir ON cp_heir.CaseID = cs.CaseID AND cp_heir.RoleinCase = 'Heir'
LEFT JOIN ParticipatingParty pp ON pp.PartyID = cp_heir.ClientID
-- Financial details linked via transactions related to estate
LEFT JOIN Transaction t ON t.CaseID = cs.CaseID
LEFT JOIN estateTransaction et ON et.TransactionID = t.TransactionID
-- Document details relevant to the succession case
LEFT JOIN DocumentLibrary dl ON dl.CaseID = cs.CaseID
LEFT JOIN Documents d ON d.DocumentID = dl.DocumentID
-- Filter for legal cases explicitly or cases explicitly mentioning succession
WHERE cs.CaseType = 'Legal' OR cs.CaseDescription LIKE '%succession%';


-- 10. MARRIAGE SERVICE FORM


-- Objective: Gather detailed information about marriages, including spouse details, marriage dates, marital regimes, and additional agreements.
SELECT
    m.MarriageID,                               -- Unique identifier for each marriage record


    -- Spouse 1: personal and property details
    m.Spouse1ClientID,
    ic1.FirstName AS Spouse1FirstName,
    ic1.LastName AS Spouse1LastName,
    c1.Address AS Spouse1Property,


    -- Spouse 2: personal and property details
    m.Spouse2ClientID,
    ic2.FirstName AS Spouse2FirstName,
    ic2.LastName AS Spouse2LastName,
    c2.Address AS Spouse2Property,


    -- Marriage-specific details including date, legal regime, and any additional agreements
    m.MarriageDate,
    m.MaritalRegime,
    m.AdditionalAgreements


FROM Marriage m
-- Connect spouse 1 details
JOIN Client c1 ON m.Spouse1ClientID = c1.ClientID
LEFT JOIN individualClient ic1 ON c1.ClientID = ic1.IndividualID
-- Connect spouse 2 details
JOIN Client c2 ON m.Spouse2ClientID = c2.ClientID
LEFT JOIN individualClient ic2 ON c2.ClientID = ic2.IndividualID;


--------------------------------------
---- PART 2: REPORT AND ANALYTICS ----
--------------------------------------


-- 1. CASE STATUS REPORT → refer to PART 1, FORM (2) (it is the same expected output)


-- 2. FINANCCIAL AND ACTIVITY REPORT  


-- Query 1: Summary of Payments Received by Client


-- Objective: Calculate the total amount each client has successfully paid.
SELECT
    ClientID,
    SUM(Amount) AS Total_Paid                -- Sum of completed payments
FROM Payment
WHERE PaymentStatus = 'Completed'            -- Only payments marked as completed
GROUP BY ClientID;


-- Query 2: Summary of Outstanding Balances by Client


-- Objective: Calculate total pending payments (amounts still owed) for each client.
SELECT
    ClientID,
    SUM(Amount) AS Total_To_Pay              -- Sum of pending payments
FROM Payment
WHERE PaymentStatus = 'Pending'              -- Only payments still pending
GROUP BY ClientID;


-- Query 3: Total Payments and Most Recent Payment Status by Client


-- Objective: Retrieve the total amount each client has paid, along with their latest payment status and the date of their most recent payment.
SELECT
    p.ClientID,                                -- Unique identifier of the client
    p.PaymentStatus,                           -- Status of the payment (e.g., Completed, Pending)
    SUM(p.Amount) AS TotalPayments,            -- Total sum of all payments made by the client
    MAX(p.PaymentDate) AS MostRecentPaymentDate -- Date when the latest payment occurred
FROM Payment p
GROUP BY
    p.ClientID,
    p.PaymentStatus;                           -- Groups data by client and payment status




-- 3. CLIENT ACTIVITY REPORT


-- Query 1: Client Appoitments Summary


-- Objective: Retrieve client details, count of their appointments, follow-ups, and number of open cases.
SELECT DISTINCT
    Client.ClientID,
    Client.Email,


    -- Count of appointments attended by the client
    (SELECT COUNT(*) FROM AppointmentParticipation
     WHERE AppointmentParticipation.ClientID = Client.ClientID) AS Appointments,


    -- Count of scheduled follow-ups for the client (upcoming)
    (SELECT COUNT(*) FROM Communication
     WHERE Communication.ClientID = Client.ClientID AND Communication.FollowUpDate >= CURRENT_DATE) AS Followups,


    -- Count of currently open cases associated with the client
    (SELECT COUNT(*) FROM Cases
     JOIN CaseParticipation ON Cases.CaseID = CaseParticipation.CaseID
     WHERE CaseParticipation.ClientID = Client.ClientID AND Cases.Status = 'Open'
       AND Cases.DueDate > CURRENT_DATE) AS OpenCases
FROM Client;


-- Query 2: Appointment Summary with Recent Dates


-- Objective: Count total appointments per client and identify the most recent appointment date.
SELECT
    ap.ClientID,
    COUNT(DISTINCT ap.AppointmentID) AS AppointmentCount,   -- Total appointments per client
    MAX(a.AppointmentDate) AS MostRecentAppointmentDate     -- Most recent appointment date
FROM AppointmentParticipation ap
JOIN Appointment a ON ap.AppointmentID = a.AppointmentID
GROUP BY ap.ClientID;


-- Query 3: Clients with Pending Payments and Active Cases (Including Overdue Information)


-- Objective: Identify clients who currently owe payments (payments are pending) and have active (open) legal cases.
-- Calculate the total amount they owe, the intended duration of each case, and how many days overdue a case is, if applicable.
SELECT
    p.ClientID,                                           -- Unique identifier of the client
    c.CaseID,                                             -- Unique identifier of the client's legal case
    SUM(p.Amount) AS TotalPaymentsDue,                    -- Total outstanding amount owed by the client
    DATEDIFF(c.DueDate, c.OpenDate) AS CaseDurationDays,  -- Number of days allocated to complete the case
    CASE
        WHEN CURRENT_DATE > c.DueDate
        THEN DATEDIFF(CURRENT_DATE, c.DueDate)            -- Days overdue if the current date has surpassed the case's due date
        ELSE 0                                            -- If not overdue, return 0
    END AS DaysPastDeadline
FROM Payment p
-- Link payments to clients participating in cases
JOIN CaseParticipation cp ON p.ClientID = cp.ClientID
-- Link case participation to case details
JOIN Cases c ON cp.CaseID = c.CaseID
WHERE
    p.PaymentStatus = 'Pending'                           -- Filter only pending (unpaid) payments
    AND p.PaymentDate < CURRENT_DATE                      -- Ensure payment due date is in the past
    AND c.Status = 'Open'                                 -- Consider only active/open cases
GROUP BY
    p.ClientID,
    c.CaseID;                                             -- Group results by client and their case


-- 4. DOCUMENT INVENTORY REPORT


-- Objective: List all documents with clear indication of their current status (Draft, Final, Archived).
SELECT
    DocumentID,                                             -- Unique ID of the document
    DocumentName,                                           -- Name of the document
    DocumentType,                                           -- Type/category of the document
    CASE VerificationStatus                                 -- Interpret numeric verification status
        WHEN 0 THEN 'Draft'
        WHEN 1 THEN 'Final'
        WHEN 2 THEN 'Archived'
        ELSE 'Unknown'
    END AS DocumentStatus                                   -- Human-readable document status
FROM Documents;


-- 5. REAL ESTATE TRANSACTION REPORT


-- Objective: Comprehensive overview of real estate transactions including property details, mortgage information, transaction specifics, and financial institutions involved.
SELECT
    rt.TransactionID,                                      
    rt.ServiceType,                                         -- Type of real estate service provided
    rt.MortgageDetails,                                     -- Description/details of mortgage
    rt.MortgageStatus,                                      -- Status of the mortgage (e.g., approved, completed)


    t.TransactionDate,                                      -- Date when the transaction occurred
    t.Amount,                                               -- Amount involved in the transaction
    t.TransactionType,                                      -- Payment method/type (e.g., cheque, transfer)


    p.PropertyID,                                           -- Unique ID of the property
    p.Address AS PropertyAddress,                           -- Address of the involved property
    p.LegalDescription,                                     -- Legal description/classification of the property
    p.TitleStatus,                                          -- Current title status of the property


    fi.Name AS FinancialInstitutionName,                    -- Name of the associated financial institution
    fi.contact_info AS InstitutionContact                   -- Contact information of financial institution


FROM real_estateTransaction rt
JOIN Transaction t ON rt.TransactionID = t.TransactionID    -- Link transactions to real estate transactions
JOIN Property p ON rt.PropertyID = p.PropertyID             -- Property details associated with the transaction
JOIN FinancialInstitution fi ON rt.InstitutionID = fi.InstitutionID; -- Financial institution details


-- 6. COMPLIANCE REPORT


-- Objective: List corporate clients' compliance-related documents such as minute books and regulatory filings, their verification statuses, and storage locations.
SELECT
    cc.CompanyName,                            -- Name of corporate client
    cc.BusinessNumber,                         -- Unique business identifier
    d.DocumentType,                            -- Type of compliance document
    d.DocumentName,                            -- Name of the document             d.VerificationStatus,                          -- Verification Status
    d.StoragePath,                             -- Location of the document
    d.ClientID                                 -- Client ID for tracking
FROM corporateClient cc
-- Link corporateClient to general Client table to retrieve associated documents
JOIN Client c ON cc.CorporateID = c.ClientID
-- Link to documents table to fetch corporate compliance-related files
JOIN Documents d ON c.ClientID = d.ClientID
-- Focus only on compliance-related document types
WHERE d.DocumentType IN ('Minute Book', 'Regulatory Filing');
