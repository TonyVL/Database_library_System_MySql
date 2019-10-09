/* Purpose: transaction.
Script Date: April 5th ,2019
Developped by Matthew, Sergei, Levar, Tony
 */
 use JAClib
 ;
 go
 /* this procedure adds a student to the student and members table
 */
 CREATE PROCEDURE customer.AddStudentPR
   @FirstName varchar(25),
   @MiddleName varchar(25),
   @LastName varchar(25),
   @Picture varbinary(max),
   @StudentID nchar(8),
   @StudentNumber tinyint,
   @Address varchar(25),
   @City varchar(25),
   @Province char(2),
   @PostalCode char(10),
   @Phone varchar(16),
   @MemberID nchar(8) output
 AS

 DECLARE @ExpirationDate datetime
 SET @ExpirationDate = DATEADD(year,1,GETDATE())

 -- test for nulls
 IF @FirstName is null OR @LastName is null OR @Address is null OR @City is null
 OR #Province is null or @PostalCode
 BEGIN
   RAISERROR('Field Cannot Be Empty',11,1)
   Return
 END

 /* add new member to the customers.members table then
 add that member as a student */
 begin TRANSACTION
   INSERT customer.Members (FirstName,MiddleName,LastName,Picture)
   VALUES (@FirstName,@MiddleName,@LastName,@Picture)

   -- test
   IF @@ERROR <> 0
     BEGIN
       RAISERROR('Invalid, member not added',11,1)
       ROLLBACK TRANSACTION
       Return
     END

   SET @MemberID = Scope_Identity();

   INSERT customer.Students (MemberID,StudentNumber,Address,City,Province,PostalCode,Phone,ExpirationDate)
   VALUES (@MemberID,@StudentNumber,@Address,@City,@Province,@PostalCode,@Phone,@ExpirationDate)

   -- test
   IF @@ERROR <> 0
     BEGIN
       RAISERROR('Invalid, member not added',11,1)
       ROLLBACK TRANSACTION
       Return
     END
 COMMIT TRANSACTION
