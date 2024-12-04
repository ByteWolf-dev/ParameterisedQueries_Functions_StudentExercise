# Handout Parameterized Queries

## What are Parameterized Queries?

Instead of writing values directly into your SQL statement, you can use placeholders `(?, :name, etc.)` and provide the actual values separately. This separation protects your code from SQL injection attacks and improves performance.

## Why Use Them?

### Security: 
They prevent malicious code from being injected into your database.
### Performance: 
Databases can reuse execution plans for queries with the same structure, leading to faster execution.
## How They Work:

Write your SQL statement with placeholders.
Provide the actual values separately using a dedicated API call.
## Exceptions:

### There are a few cases where using actual values might be beneficial for performance:
- Unevenly Distributed Data: 
When searching for specific values with a large difference in frequency (e.g., "todo" vs "done" tasks).
- Partitioning: 
If tables and indexes are split across storage areas based on values.
- LIKE Queries: 
Performance might be slightly affected in some cases.
## Rule of Thumb:

Use parameterized queries whenever possible for both security and performance reasons. Only consider using actual values if you're absolutely certain it benefits performance for a specific scenario.

# Handout Functions

## Starting scenario
Our employee table with a normal index on the LastName

```sql
CREATE TABLE employees (
    employee_id   NUMBER         NOT NULL,
    first_name    VARCHAR2(1000) NOT NULL,
    last_name     VARCHAR2(1000) NOT NULL,
    date_of_birth DATE           NOT NULL,
    phone_number  VARCHAR2(1000) NOT NULL,
    junk          CHAR(1000)     DEFAULT 'JUNK',
    CONSTRAINT employees_pk PRIMARY KEY (employee_id)
);

CREATE INDEX Employee_FirstName_Index ON EMPLOYEES (LAST_NAME);
```
## Example considering Case-Insensitive Searches

### Why the Optimizer Doesn't Use the Index with `UPPER`
When you use a function like `UPPER` on a column in Oracle, the optimizer can't use the index because it relies on the exact values stored in the index. Applying a function transforms the values, making the index unusable.

Example:
```sql
SELECT * FROM employees WHERE UPPER(lastname) = UPPER('smith');
```
Here, the index on `lastname` won't be used because `UPPER(lastname)` doesn't match the stored index values.

### Solutions to Enable Index Usage

1. **Function-Based Index**  
   Create an index on the transformed column:
   ```sql
   CREATE INDEX idx_upper_lastname ON employees (UPPER(lastname));
   ```

2. **Avoid Functions on the Column**  
   Store data in a consistent case (e.g., all uppercase) and query without transformations:
   ```sql
   SELECT * FROM employees WHERE lastname = 'SMITH';
   ```

3. **Transform Input Instead of Column**  
   Apply the function only to the input value:
   ```sql
   SELECT * FROM employees WHERE lastname = UPPER('smith');
   ```

## User Defined Functions

In Oracle, **user-defined functions** (UDFs) can also be used in Function-Based Indexes (FBIs). This enables you to create custom logic for indexing specific transformations or computations, not just relying on standard functions like `UPPER` or `LOWER`. However, these functions must still be **deterministic** to work effectively in an FBI.

### Functions Have to Be Deterministic
For a function to be used in an FBI, it must be deterministic, meaning that for a given input, it will always produce the same output. This consistency is crucial because the database relies on the index storing precomputed values that can be quickly retrieved.

**Example of Non-Deterministic Function:**
```sql
CREATE OR REPLACE FUNCTION GET_AGE(dob DATE) RETURN NUMBER IS
BEGIN
  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, dob) / 12);
END;
```
This function is **non-deterministic** because `SYSDATE` changes every day. As a result, the values in the index would change daily, making the index unreliable.

## Over-Indexing

While indexes are powerful, creating too many indexes on a table (especially on columns that change frequently) can result in performance issues. This is known as **over-indexing**. Each time data is inserted, updated, or deleted, the database must also update the indexes, which can cause overhead.