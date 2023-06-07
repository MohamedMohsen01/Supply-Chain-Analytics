# Supply_Chain_Analytics_Project

## Problem Statement
AtliQ Mart is a growing FMCG manufacturer headquartered in Gujarat, India. It is currently operational in three cities Surat, Ahmedabad and Vadodra. They want to expand to other metro/tier1 cities in the next 2 years.

AtliQ Mart is currently facing a problem where a few key customers did not extend the annual contract due to service issues. Management wants to fix this issue before expanding to other cities and requested their supply chain analytics team to track the ’On time’ and ‘In Full’ delivery service level for all the customers on a daily basis so that they can respond swiftly to these issues.

## Task:
- Design a comprehensive dashboard that provides real-time monitoring of key performance indicators (KPIs) related to order fulfillment. The dashboard should focus on three main metrics: 'On Time%', 'In Full%', and 'OTIF%' on a daily basis and split by cities and then by customer.
- The dashboard should display the actual values of 'On Time%', 'In Full%', and 'OTIF%' alongside their respective targets. The metrics should be color-coded using conditional formatting to indicate whether each metric is above or below its target.
- The dashboard should display the (LIFR%) and (VOFR%) metrics specifically for each product. Additionally, a sparkline can be added next to each product's metrics to visualize their performance trends over time.
- The dashboard should present a matrix visualization that showcases the performance of customers across all the metrics. The matrix should clearly indicate whether the customer's performance is meeting or exceeding the targets.
- The dashboard should allow users to drill down into the (OTIF%) performance over months. It should provide the flexibility to view performance on a weekly and daily basis as well, enabling a detailed analysis of trends and patterns.


## Insight 1

![photo_6035148883560086843_y](https://github.com/MohamedMohsen01/Supply_Chain_Analytics_Project/assets/109850173/7dae2959-18e5-4e07-b29b-09fe83954999)


- AtliQMarts's product demand is almost equally distributed in all three cities, i.e., Vadodara, Surat and Ahmedabad.
- The most in-demand Category from the customers' side is 'Dairy' with 38K Orders, followed by Foods. The most demanding product is Milk, with 3.7M quantities sold, followed by Curd with 3.2M.
- Vadodara City's demand is being declined month by month.
- AtliQ Marts has received a total of 57K Orders, in which 13M Quantities have been sold.
- All the KPIs i.e., OTIF%, OT%, and IF% are much below their respective targets.
- OTIF% is lagging by almost 55% each month, with the highest being in April with 56.51%.
- OT% is lagging by almost 31%each month, with being highest in June and May with 32.04%.
- IF% is lagging by almost 30% each month, with being highest in June with 32%
- We are running good with VOFR% but need improvement in LIFR%.

## Insight 2

![photo_6035148883560086840_w](https://github.com/MohamedMohsen01/Supply_Chain_Analytics_Project/assets/109850173/53976fc9-055c-40e0-be0a-70bc20b845ea)

![photo_6035148883560086841_y](https://github.com/MohamedMohsen01/Supply_Chain_Analytics_Project/assets/109850173/b5094d99-624e-4a26-a323-b8f75c4c7fae)

- OTIF% was best performing in August and July with (29.39%) and (29.35%), with Vadodara being the poorest performer in June with (27.1%). The customers with the -lowest OTIF% were 'CoolBLue', 'Acclaimed Stores', and 'Lotus Mart'.
- OT% needs massive improvement since it was the best performing in March (59.6%), and Surat was the best performer in July and March with (62.08%) and (62.04%). The customers with the lowest OT% were again the same as were in OTIF%.
- IF% was at its lowest in June (52.04%), with Vadodara with its poorest performance (50.39%). The customers with the lowest IF% were 'Elite Mart', 'Sorefoz Mart', and 'Info Stores'.
- LIFR% and VOFR% were nearly constant through the months, but VOFR% was performing well compared to LIFR%. This means we were supplying enough quantities ordered but failed to deliver specific products due to the unavailability of an inefficient supply chain.
- Delay in Delivery was highest for "1 day' followed by 2 and 3 Days. DID was highest for Ghee, Butter, Curd and Milk, which should be improved because these products are one of the most in-demand products.

## Insight 3

![photo_6035148883560086842_y](https://github.com/MohamedMohsen01/Supply_Chain_Analytics_Project/assets/109850173/0ad9d0f4-770e-4735-9d2e-1e322896e200)


- If we analyze OTIF%, OT%, and IF% citywide, we see that there are 7 customers with whom we have the lowest performance. They are 'Lotus Mart', 'Acclaimed Stores', 'Vijay Stores', 'CoolBlue', 'Info Stores', ' Sorefoz Mart', and 'Elite Mart'.
- These customer issues should be addressed first with top priority because 3 account for the maximum orders from the rest of the customers.
- It can be seen that customers with good LIFR% and VOFR% have ultimately scored pretty well in OTIF%, OT%, and IF%. This means that having required products in enough quantities can benefit the customers to receive orders on time with total amounts.
- Almost all the products have equal demand (Unlike Category) and VOFR%. But products such as 'AM Butter 250', 'AM Biscuits 250', 'AM Tea 250', and 'AM Ghee 250' have low LIFR%, which means they are in demand, but due to unavailability of products or broken supply chain, the products are not being able to ship. We need to be ready with the forecasted demand.
- With 458K products undelivered to customers, 'Lotus Mart' is at the top of the product list. Unfortunately. Vadodara tops the list with168K products left to be delivered.
- Undelivered of the requested product can have a severe effect on customer satisfaction. Vadodara being our2nd most significant market, we cannot afford the inefficient supply chain to hamper the customer renewal of contract.
- According to data insights, the customers with whom we should start working to renew the contracts are Acclaimed Stores, Lotus Mart, CoolBlue, and Vijay Stores.


## Recommendations

- OTIF is a 'Hard' metric from customer's point of view, but we are unable to meet the customer's demand both by quantity ordered and timely delivery in all the cities. We are trailing with an average of 36.6% in all cities, which is hampering the reliability of customer.
- VOFR is performing good compared to LIFR in all the cities which means we are unable to deliver all requested products from customers. So, we should be prepared with inventory beforehand. At least in the demand season.
- 'Delayin Delivery* has been a major problem in all cities. We were able to deliver 18% of order before agreed delivery date. But, for so many orders were unable deliver 'On Time'. The delay is seen for1,2, and 3 days with an average of 1.21 days.
- Vadodara, being our biggest market, has much efficient supply chain compared to other two cities since COCD in Ahmedabad and Surat is very high. We should have serious attention to this particular case.
- Customers who are our biggest client and facing serious issues and heir issues should be resolved first: Acclaimed Stores, CoolBlue and Lotus Mart.


- Almost all the products have their VOIF above 96% which if a good thing. Whereas LIF has been pretty low for ail the products.
- Milk being our one of the highest selling and ordered product, we need to have serious attention towards its availability in stock to improve its LIFR and reduce 'Delay in Delivery, followed by Butter and Curd.
- We need to manage our inventory with our previous data by analysis when we have high demand when we have demand loss. Different query or question, you products have different demand seasons. August is seen as the demand dropping season so we can manage our inventory accordingly.
- Some of the mostly affected customers which are repeating in every products category are Acclaimed Stores, Lotus Mart, CoolBlue, and Vijay Stores. We need to concentrate first on their service improvement and satisfaction.

For additional project details, please feel free to visit this link:[Power BI Link](https://app.powerbi.com/view?r=eyJrIjoiMzNmOGI3MWQtOTUxNC00OTEzLWFjMTQtN2EzODRiYWI2YzFiIiwidCI6IjMzODU0OWQ1LThiMDgtNDdlMS1iOGQyLWJlNTIwZTJiM2FkNSJ9)
