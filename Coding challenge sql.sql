-- Task 1: Provide a SQL script that initializes the database for the Job Board scenario �CareerHub�. 
-- Task 3: Define appropriate primary keys, foreign keys, and constraints. 
-- Task 4: Ensure the script handles potential errors, such as if the database or tables already exist.
CREATE DATABASE CareerHub;
USE CareerHub;

-- Task 2:  Create tables for Companies, Jobs, Applicants and Applications. 
CREATE TABLE Companies (
    CompanyID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(255),
    Location VARCHAR(255)
);

CREATE TABLE Jobs (
    JobID INT IDENTITY(101,1) PRIMARY KEY,
    CompanyID INT,
    JobTitle VARCHAR(255),
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL(10, 2),
    JobType VARCHAR(50),
    PostedDate DATETIME,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

CREATE TABLE Applicants (
    ApplicantID INT IDENTITY(1001,1) PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Resume TEXT
);

CREATE TABLE Applications (
    ApplicationID INT IDENTITY(10001,1) PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);

INSERT INTO Companies (CompanyName, Location) VALUES
('Tech Innovations', 'San Francisco'),
('Data Driven Inc', 'New York'),
('GreenTech Solutions', 'Austin'),
('CodeCrafters', 'Boston'),
('HexaWare Technologies', 'Chennai');


INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(1, 'Frontend Developer', 'Develop user-facing features', 'San Francisco', 75000, 'Full-time', '2023-01-10'),
(2, 'Data Analyst', 'Interpret data models', 'New York', 68000, 'Full-time', '2023-02-20'),
(3, 'Environmental Engineer', 'Develop environmental solutions', 'Austin', 85000, 'Full-time', '2023-03-15'),
(1, 'Backend Developer', 'Handle server-side logic', 'Remote', 77000, 'Full-time', '2023-04-05'),
(4, 'Software Engineer', 'Develop and test software systems', 'Boston', 90000, 'Full-time', '2023-01-18'),
(5, 'HR Coordinator', 'Manage hiring processes', 'Chennai', 45000, 'Contract', '2023-04-25'),
(2, 'Senior Data Analyst', 'Lead data strategies', 'New York', 95000, 'Full-time', '2023-01-22');


INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', 'Experienced web developer with 5 years of experience.'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', 'Data enthusiast with 3 years of experience in data analysis.'),
('Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012', 'Environmental engineer with 4 years of field experience.'),
('Bob', 'Brown', 'bob.brown@example.com', '456-789-0123', 'Seasoned software engineer with 8 years of experience.');


INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter) VALUES
(101, 1001, '2023-04-01', 'I am excited to apply for the Frontend Developer position.'),
(102, 1002, '2023-04-02', 'I am interested in the Data Analyst position.'),
(103, 1003, '2023-04-03', 'I am eager to bring my expertise to your team as an Environmental Engineer.'),
(104, 1004, '2023-04-04', 'I am applying for the Backend Developer role to leverage my skills.'),
(105, 1001, '2023-04-05', 'I am also interested in the Software Engineer position at CodeCrafters.');

SELECT* FROM Companies
SELECT*FROM Jobs
SELECT* FROM Applicants
SELECT*FROM Applications

-- Task 5: Write an SQL query to count the number of applications received for each job listing in the 
-- "Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
-- jobs, even if they have no applications.

SELECT Jobs.JobTitle, COUNT(Applications.ApplicationID) AS ApplicationCount
FROM Jobs
LEFT JOIN Applications ON Jobs.JobID = Applications.JobID
GROUP BY Jobs.JobID,JobTitle;

-- Task 6: Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
-- range. Allow parameters for the minimum and maximum salary values. Display the job title, 
-- company name, location, and salary for each matching job.

SELECT Jobs.JobTitle, Companies.CompanyName, Jobs.JobLocation, Jobs.Salary
FROM Jobs
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Jobs.Salary BETWEEN (SELECT min(Salary) FROM Jobs) AND (SELECT max(Salary) FROM Jobs) ;

-- Task 7: Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
-- parameter for the ApplicantID, and return a result set with the job titles, company names, and 
-- application dates for all the jobs the applicant has applied to.

SELECT Jobs.JobTitle, Companies.CompanyName, Applications.ApplicationDate
FROM Applications
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Applications.ApplicantID = ApplicantID;

-- Task 8: Create an SQL query that calculates and displays the average salary offered by all companies for 
-- job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.

SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0;

-- Task 9: Write an SQL query to identify the company that has posted the most job listings. Display the 
-- company name along with the count of job listings they have posted. Handle ties if multiple 
-- companies have the same maximum count.

SELECT top 1 Companies.CompanyName, COUNT(Jobs.JobID) AS JobCount
FROM Companies
LEFT JOIN Jobs ON Companies.CompanyID = Jobs.CompanyID
GROUP BY Companies.CompanyID,CompanyName
ORDER BY JobCount DESC;

-- Task 10: Find the applicants who have applied for positions in companies located in 'CityX' and have at 
-- least 3 years of experience.

-- Add a new column ExperienceYears to the Applicants table
ALTER TABLE Applicants ADD ExperienceYears INT;

-- Update the ExperienceYears column based on the value extracted from the Resume column
UPDATE Applicants 
SET ExperienceYears = TRY_CAST(SUBSTRING(Resume, CHARINDEX('years of experience', Resume) - 3, 2) AS INT)
WHERE CHARINDEX('years of experience', Resume) > 0
AND TRY_CAST(SUBSTRING(Resume, CHARINDEX('years of experience', Resume) - 3, 2) AS INT) IS NOT NULL;

SELECT DISTINCT Applicants.FirstName, Applicants.LastName
FROM Applicants
INNER JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Companies.Location = 'CityX' AND Applicants.ExperienceYears >= 2;

-- Task 11: Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.
SELECT DISTINCT JobTitle
FROM Jobs
WHERE Salary BETWEEN 60000 AND 80000;

-- Task 12: Find jobs that have not received any applications
SELECT JobTitle, Companies.CompanyName
FROM Jobs
LEFT JOIN Applications ON Jobs.JobID = Applications.JobID
LEFT JOIN Companies ON Jobs.CompanyID =Companies.CompanyID
WHERE Applications.ApplicationID IS NULL;

-- Task 13: Retrieve a list of job applicants along with the companies they have applied to and the positions 
-- they have applied for.

SELECT Applicants.FirstName, Applicants.LastName, Companies.CompanyName, Jobs.JobTitle
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID;

-- Task 14: Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
-- received any applications.

SELECT Companies.CompanyName, COUNT(Jobs.JobID) AS JobCount
FROM Companies
LEFT JOIN Jobs ON Companies.CompanyID = Jobs.CompanyID
GROUP BY Companies.CompanyName;

-- Task 15: List all applicants along with the companies and positions they have applied for, including those 
-- who have not applied.

SELECT Applicants.FirstName, Applicants.LastName, Companies.CompanyName, Jobs.JobTitle
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID;

-- Task 16: Find companies that have posted jobs with a salary higher than the average salary of all jobs.

SELECT Companies.CompanyName, AVG(Jobs.Salary) AS AverageSalary
FROM Companies
INNER JOIN Jobs ON Companies.CompanyID = Jobs.CompanyID
WHERE Jobs.Salary > (SELECT AVG(Salary) FROM Jobs WHERE Salary > 0)
GROUP BY Companies.CompanyID, Companies.CompanyName;

-- Task 17: Display a list of applicants with their names and a concatenated string of their city and state.
ALTER TABLE Companies
ADD[State] varchar(50);

UPDATE Companies
SET [State] = 'California'
WHERE [Location] = 'San Francisco'

UPDATE Companies
SET [State] = 'New York'
WHERE [Location] = 'New York'

UPDATE Companies
SET [State] = 'Texas'
WHERE [Location] = 'Austin'

UPDATE Companies
SET [State] = 'Massachusetts'
WHERE [Location] = 'Boston'

UPDATE Companies
SET [State] = 'Tamil Nadu'
WHERE [Location] = 'Chennai';

SELECT CONCAT(Applicants.FirstName, ' ', Applicants.LastName) AS FullName, CONCAT(Companies.Location, ', ', Companies.State) AS CityState
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID

-- Task 18: Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.
SELECT JobTitle
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

-- Task 19: Retrieve a list of applicants and the jobs they have applied for, including those who have not 
-- applied and jobs without applicants.

SELECT Applicants.FirstName, Applicants.LastName, Companies.CompanyName, Jobs.JobTitle
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID;

-- Task 20: List all combinations of applicants and companies where the company is in a specific city and the 
-- applicant has more than 2 years of experience. For example: city=Chennai

SELECT Applicants.FirstName, Applicants.LastName, Companies.CompanyName, Companies.Location
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Companies.Location = 'Chennai' AND Applicants.ExperienceYears > 2;
