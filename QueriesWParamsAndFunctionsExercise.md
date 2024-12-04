
# Exercise: Indexing and Function-Based Indexing with Deterministic Functions

## Objective
In this exercise, you will practice creating and using regular indexes, function-based indexes, and understanding how deterministic functions are required for indexing. You’ll also explore how these indexes can optimize query performance.

---

## Part 1: Regular Indexes

### Scenario:
You are working with a database containing an `EMPLOYEES` table, which includes the columns `EMPLOYEE_ID`, `FIRST_NAME`, `LAST_NAME`, and `EMAIL`.

### Task:
1. Create a regular index on the `FIRST_NAME` column of the `EMPLOYEES` table.
2. Write a query to search for employees with the first name `John`.
3. Run an `EXPLAIN PLAN` before and after creating the index to compare query performance.

---

## Part 2: Function-Based Indexes

### Scenario:
You need to perform case-insensitive searches for employees first names. The query uses the `UPPER()` function to transform the `FIRST_NAME` column to uppercase for the comparison.

### Task:
1. Write a query that uses the `UPPER()` function to search for employees by their first name, case-insensitively.
2. Run an `EXPLAIN PLAN` for the query **without any indexes**.
3. Create a function-based index on the `UPPER(FIRST_NAME)` column.
4. Re-run the `EXPLAIN PLAN` after creating the index to compare the results.

---

## Part 3: Ensuring Determinism for Indexing

### Scenario:
You have a function that calculates the age of employees based on their `BIRTH_DATE`, and you wish to index this result to improve search performance for employees by age.

### Task:
1. Write a query to search for employees by their calculated age using the `BIRTH_DATE` column.
2. Create a function to calculate the age based on `BIRTH_DATE`.
3. Attempt to create a function-based index using the `AGE` function.
4. Run an `EXPLAIN PLAN` for the query before and after creating the index.

**Hint:** The function-based index may not work if the function is **non-deterministic**, as using `SYSDATE` will cause it to return different results at different times.

---

## Part 4: Notes on Indexing and Determinism

- Regular indexes speed up queries by creating a quick lookup table for a column.
- Function-based indexes enable indexing on columns that are used in functions, like `UPPER()`, but the function must be deterministic.
- A **deterministic** function always returns the same result for the same inputs. For example, `SYSDATE` is non-deterministic because it changes every time the function is called.

---

# Exercise: Test Speed Difference When Using Parameterized Queries

### Scenario:
You are working for a company and want to show a coworker how much faster it is to use Parameterized Queries under the right circumstances, just to prove a point. You already have an Oracle DB with an employees test set on your laptop set up.

### Task:
Write two PL/SQL scripts. Both should execute a query 1000 times, where the value of the "WHERE = value" part is different in each execution. In one loop, you use bind parameters, and in the other, you should just use string concatenation. In the end, run both scripts and check how long they took to execute.

### Hints:
- Create a variable with a random text using `v_name := DBMS_RANDOM.STRING('u', 1) || DBMS_RANDOM.STRING('l', DBMS_RANDOM.VALUE(2, 10));`
- You can use a bind parameter like this in Oracle: `WHERE first_name = :v_name' using v_name`.
