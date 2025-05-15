# 📊 AdventureWorks SQL Business Insights

This project contains a series of SQL queries aimed at generating key business insights from the [AdventureWorks](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) database. These queries demonstrate data manipulation, aggregation, and analysis techniques commonly used in business intelligence workflows.

---

## 📁 File Structure

- `AdventureWorks_Queries.sql` – Contains five SQL query blocks solving specific business questions, including revenue analysis, customer segmentation, and product performance.

---

## 🧠 Business Questions Answered

### 1. Top 10 Customers by Revenue
Identifies the top 10 customers based on the total revenue they generated, including their name, shipping country, and city.

### 2. Customer Segmentation by Revenue
Segments customers into four groups (Platinum, Gold, Silver, Bronze) based on their revenue contribution using NTILE window function.

### 3. Products Ordered on the Last Business Day
Lists all products (with their categories) that were ordered by customers on the most recent order date.

### 4. Customer Segments View
Creates a reusable SQL view called `CustomerSegments` that replicates the customer segmentation logic from Question 2.

### 5. Top 3 Selling Products by Category
Finds the top 3 revenue-generating products in each product category using `DENSE_RANK` and aggregation.

---

## 🛠️ Technologies Used

- Microsoft SQL Server (T-SQL)
- AdventureWorksLT schema
- Common Table Expressions (CTEs)
- Window Functions (`NTILE`, `DENSE_RANK`)
- SQL Views
- Aggregate Functions (`SUM`, `GROUP BY`)

---

## 🚀 How to Run

1. Ensure you have access to SQL Server or Azure SQL Database.
2. Download and restore the **AdventureWorksLT** sample database.
3. Open the `AdventureWorks_Queries.sql` file in SQL Server Management Studio (SSMS) or any SQL-compatible IDE.
4. Run each block of code to view insights.

---

## 🧾 Conclusion

This SQL analysis on the AdventureWorks dataset provides several key business insights:

- ✅ **Top Customers**: Identified the top 10 revenue-generating customers for targeted relationship management.
- 🧠 **Segmentation**: Grouped customers into Platinum, Gold, Silver, and Bronze segments to enable personalized marketing strategies.
- 📅 **Recent Activity**: Analyzed products ordered on the last business day for trend detection and performance tracking.
- ♻️ **Reusable View**: Created a `CustomerSegments` view to streamline future queries and analysis.
- 🛍️ **Top Products by Category**: Highlighted the top 3 best-selling products within each category, aiding inventory and promotional strategies.

These insights help stakeholders across marketing, sales, and operations make data-driven decisions to boost efficiency and profitability.

---

## 📌 Notes

- Revenue is calculated using `OrderQty * UnitPrice` or `LineTotal` depending on the context.
- Comments are included in the SQL script for clarity.
- The dataset used is the **SalesLT** schema, a lightweight version of the full AdventureWorks database.

---

## 📬 Contact

If you have any questions or suggestions, feel free to open an issue or reach out via GitHub!

