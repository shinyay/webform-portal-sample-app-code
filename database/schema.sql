SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF DB_NAME() NOT LIKE 'WebFormsWorkshop[_]%'
BEGIN
    RAISERROR ('Only a dedicated WebFormsWorkshop database may be initialized.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
END;

IF OBJECT_ID('dbo.WorkshopMetadata', 'U') IS NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.tables WHERE is_ms_shipped = 0)
    BEGIN
        RAISERROR ('An unmarked database with existing tables cannot be initialized.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    CREATE TABLE dbo.WorkshopMetadata
    (
        id int NOT NULL CONSTRAINT PK_WorkshopMetadata PRIMARY KEY,
        marker nvarchar(80) NOT NULL,
        seed_applied bit NOT NULL,
        CONSTRAINT CK_WorkshopMetadata_Id CHECK (id = 1)
    );
    INSERT INTO dbo.WorkshopMetadata (id, marker, seed_applied)
        VALUES (1, N'webform-portal-sample-app/v1', 0);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.WorkshopMetadata WITH (UPDLOCK, HOLDLOCK)
               WHERE id = 1 AND marker = N'webform-portal-sample-app/v1')
BEGIN
    RAISERROR ('The workshop database marker does not match.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
END;

IF OBJECT_ID('dbo.Requests', 'U') IS NULL
BEGIN
    IF (SELECT seed_applied FROM dbo.WorkshopMetadata WHERE id = 1) = 1
    BEGIN
        RAISERROR ('A seeded database is missing its Requests table.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    CREATE TABLE dbo.Requests
    (
        id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Requests PRIMARY KEY,
        title nvarchar(80) NOT NULL,
        applicant nvarchar(40) NOT NULL,
        department varchar(16) NOT NULL,
        kind varchar(16) NOT NULL,
        details nvarchar(1000) NOT NULL,
        status varchar(16) NOT NULL,
        created_at datetime NOT NULL,
        CONSTRAINT CK_Requests_Title CHECK (DATALENGTH(title) BETWEEN 2 AND 160
            AND DATALENGTH(title) = DATALENGTH(LTRIM(RTRIM(title)))),
        CONSTRAINT CK_Requests_Applicant CHECK (DATALENGTH(applicant) BETWEEN 2 AND 80
            AND DATALENGTH(applicant) = DATALENGTH(LTRIM(RTRIM(applicant)))),
        CONSTRAINT CK_Requests_Details CHECK (DATALENGTH(details) BETWEEN 20 AND 2000
            AND DATALENGTH(details) = DATALENGTH(LTRIM(RTRIM(details)))),
        CONSTRAINT CK_Requests_Department CHECK (department IN ('engineering', 'sales', 'corporate', 'design')),
        CONSTRAINT CK_Requests_Kind CHECK (kind IN ('equipment', 'training', 'remote')),
        CONSTRAINT CK_Requests_Status CHECK (status IN ('pending', 'approved', 'rejected'))
    );
    CREATE INDEX IX_Requests_CreatedAt ON dbo.Requests (created_at DESC, id DESC);
END;
COMMIT TRANSACTION;
