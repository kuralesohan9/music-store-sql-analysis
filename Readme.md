# 🎵 Music Store Data Analysis (SQL)

## 📌 Overview
This project analyzes a fictional **Music Store** database to answer business-related questions using **pure SQL**.  
It explores **sales**, **customers**, **artists**, and **genres** to uncover valuable business insights.  

The dataset is based on the [Chinook Database](https://github.com/lerocha/chinook-database), which simulates a digital music store containing details about customers, employees, invoices, tracks, artists, and more.

---

## 🗂 Dataset Structure
The database contains the following tables:

| Table Name       | Description |
|------------------|-------------|
| **employee**     | Employee details, levels, and roles |
| **customer**     | Customer information including location |
| **invoice**      | Invoice headers with billing info |
| **invoice_line** | Invoice details for each purchased track |
| **album2**       | Album information |
| **artist**       | Artist details |
| **genre**        | Music genres |
| **media_type**   | Media formats (MP3, AAC, etc.) |
| **playlist**     | Playlists created |
| **track**        | Track details including length and genre |

---

## 📊 Analysis Categories

### **1️⃣ Base Analysis**
- Find the senior-most employee  
- Identify the country with the most invoices  
- Retrieve the top 3 highest invoice totals  
- Find the city with the highest total revenue  
- Identify the customer who spent the most money  

### **2️⃣ Moderate Analysis**
- List all Rock music listeners  
- Find the top 10 Rock artists by track count  
- Retrieve tracks longer than the average song length  

### **3️⃣ Advanced Analysis**
- Find spending by each customer on the best-selling artist  
- Determine the most popular music genre per country  
- Find the highest-spending customer in each country  

---

## ⚙️ Technologies Used
- **Database:** MySQL  
- **Tool:** MySQL Workbench  
- **Concepts Applied:**
  - Joins (`INNER JOIN`, `LEFT JOIN`)
  - Subqueries
  - Common Table Expressions (**CTEs**)
  - Window Functions (`ROW_NUMBER`)
  - Aggregate Functions (`SUM`, `AVG`, `COUNT`)

---


