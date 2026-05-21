#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns


# In[2]:


df = pd.read_csv(r"D:\Project\amazon_sales_cleaned.csv")


# In[3]:


df.head()


# In[4]:


print(df.columns)


# In[5]:


df.dtypes


# In[10]:


df['order_date'] = pd.to_datetime(
    df['order_date'],
    format='%d-%m-%Y'
)


# In[11]:


print(df['order_date'].head())


# In[12]:


df['Month'] = df['order_date'].dt.month_name()


# # Create Revenue Column

# In[13]:


df["Revenue"] = (
    (df["quantity"] * df["unit_price"])
    - df["discount"]
)


# # Create Estimated Cost Column

# In[14]:


df["Estimated_Cost"] = (
    df["quantity"] * df["unit_price"]
) * 0.70


# # Create Profit Column

# In[15]:


df["Profit"] = (
    df["Revenue"]
    - (
        df["Estimated_Cost"]
        + df["shipping_cost"]
        + df["tax"]
    )
)


# In[16]:


df.head()


# In[17]:


# Total Sales
total_sales = df['total_amount'].sum()
print(total_sales)


# In[18]:


# Average Order Value
avg_order = df['total_amount'].mean()
print(avg_order)


# # TOTAL REVENUE
# 

# In[20]:


total_revenue = df['Revenue'].sum()
print("\nTOTAL REVENUE :", total_revenue)


# # TOTAL PROFIT

# In[21]:


total_profit = df['Profit'].sum()
print("TOTAL PROFIT :", total_profit)


# # TOP SELLING PRODUCTS

# In[22]:


top_products = (
    df.groupby('product_name')['quantity']
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print("\nTOP SELLING PRODUCTS")
print(top_products)


# # STATE WISE SALES

# In[23]:


state_sales = (
    df.groupby('state')['Revenue']
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print("\nTOP 10 STATES BY SALES")
print(state_sales)


# # MONTHLY SALES TREND

# In[24]:


monthly_trend = (
    df.groupby(df['order_date'].dt.to_period('M'))['Revenue']
    .sum()
)

monthly_trend.index = monthly_trend.index.astype(str)

plt.figure(figsize=(14,6))
monthly_trend.plot(marker='o')
plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.show()


# # TOP 10 PRODUCTS

# In[28]:


plt.figure(figsize=(12,6))
top_products.plot(kind='bar')
plt.title("Top 10 Selling Products")
plt.xlabel("Product Name")
plt.ylabel("Quantity Sold")
plt.xticks(rotation=45)
plt.show()


# In[29]:


category_sales = df.groupby('category')['total_amount'].sum()

category_sales.plot(kind='pie', autopct='%1.1f%%')

plt.title("Category Sales Distribution")

plt.show()


# In[30]:


numeric_df = df.select_dtypes(include=np.number)

sns.heatmap(numeric_df.corr(), annot=True)

plt.title("Correlation Heatmap")

plt.show()


# In[32]:


df.to_csv("D:\Project\Amazon_sales_Data_analysis_Project.csv", index=False)


# In[ ]:




