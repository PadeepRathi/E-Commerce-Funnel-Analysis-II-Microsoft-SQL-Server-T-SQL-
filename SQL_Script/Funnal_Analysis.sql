

-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------

SELECT TOP 10 *
FROM AnalysisDB.dbo.user_events;
 ;

 
-------------------------------------------------------------------------------------------------------------------
--- CHECK FORMATE
-------------------------------------------------------------------------------------------------------------------

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'user_events';


-------------------------------------------------------------------------------------------------------------------

--CHANGE THE DATETYPE FROM VARCHAR TP DATETIME

-------------------------------------------------------------------------------------------------------------------

SELECT 
    event_date,
    TRY_CONVERT(datetime2, event_date) AS converted_date
FROM AnalysisDB.dbo.user_events;



-------------------------------------------------------------------------------------------------------------------

--CHECK WHERE IT STARTED TO LAST ENTRY

-------------------------------------------------------------------------------------------------------------------

SELECT
    MIN(TRY_CONVERT(datetime2,event_date)) AS min_date,
    MAX(TRY_CONVERT(datetime2,event_date)) AS max_date
FROM AnalysisDB.dbo.user_events;

 

-------------------------------------------------------------------------------------------------------------------
 
 -- DEFINE SALES FUNNEL AND ITS DIFFERENT STAGES

-------------------------------------------------------------------------------------------------------------------

WITH FUNNEL_STAGES AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
    FROM AnalysisDB.dbo.user_events
    WHERE TRY_CONVERT(datetime2, event_date) >= DATEADD(DAY,-30,'2026-02-03')
)
SELECT *
FROM FUNNEL_STAGES;


-------------------------------------------------------------------------------------------------------------------

--CONVERSION RATES THROUGH THE FUNNEL

-------------------------------------------------------------------------------------------------------------------


WITH FUNNEL_STAGES AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
    FROM AnalysisDB.dbo.user_events
    WHERE TRY_CONVERT(datetime2, event_date) >= DATEADD(DAY,-30,'2026-02-03')
)
SELECT stage_1_views,
 stage_2_cart,
 ROUND(stage_2_cart*100.0/stage_1_views,0) AS view_to_cart_rate, 
 
 stage_3_checkout,
 ROUND(stage_3_checkout*100.0/stage_2_cart,0) AS view_cart_to_checkout_rate,
 
 stage_4_payment,
 ROUND(stage_4_payment*100.0/stage_3_checkout,0) AS view_checkout_to_payment_rate, 
 
 stage_5_purchase,
 ROUND(stage_5_purchase*100.0/stage_4_payment,0) AS view_payemnt_to_purchase_rate,

  ROUND(stage_5_purchase*100.0/stage_1_views,0) AS view_payemnt_to_purchase_rate


FROM FUNNEL_STAGES;


-------------------------------------------------------------------------------------------------------------------

--- FUNNELS BY SOURCE

-------------------------------------------------------------------------------------------------------------------

WITH SOURCE_FUNNEL AS (
 SELECT
 TRAFFIC_SOURCE,

COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase
    FROM AnalysisDB.dbo.user_events
    WHERE TRY_CONVERT(datetime2, event_date) >= DATEADD(DAY,-30,'2026-02-03')
    GROUP BY TRAFFIC_SOURCE

)
SELECT
TRAFFIC_SOURCE,
views,
cart,
purchase,
round(cart *100.0 / views,0) as cart_coversion_rate,
round(purchase *100.0 / views,0) as purchase_coversion_rate,
round(purchase *100.0 / cart,0) as cart_to_purchase_coversion_rate
from SOURCE_FUNNEL
order by purchase desc ;

-------------------------------------------------------------------------------------------------------------------
--- TIME TO CONVERTION ANALYSIS
-------------------------------------------------------------------------------------------------------------------
;
WITH USER_JOURNEY AS (
    SELECT
        user_id,

        MIN(CASE WHEN event_type = 'page_view'
                 THEN TRY_CONVERT(datetime2, event_date) END) AS view_time,

        MIN(CASE WHEN event_type = 'add_to_cart'
                 THEN TRY_CONVERT(datetime2, event_date) END) AS cart_time,

        MIN(CASE WHEN event_type = 'purchase'
                 THEN TRY_CONVERT(datetime2, event_date) END) AS purchase_time

    FROM AnalysisDB.dbo.user_events
    WHERE TRY_CONVERT(datetime2, event_date)
          >= DATEADD(DAY, -30, '2026-02-03')
    GROUP BY user_id

    HAVING MIN(CASE WHEN event_type = 'purchase'
                    THEN event_date END) IS NOT NULL
)

SELECT
    COUNT(*) AS converted_users,

    ROUND(
        AVG(
            CAST(DATEDIFF(MINUTE, view_time, cart_time) AS FLOAT)
        ), 2
    ) AS avg_view_to_cart_minutes,

    ROUND(
        AVG(
            CAST(DATEDIFF(MINUTE, cart_time, purchase_time) AS FLOAT)
        ), 2
    ) AS avg_cart_to_purchase_minutes,

    ROUND(
        AVG(
            CAST(DATEDIFF(MINUTE, view_time, purchase_time) AS FLOAT)
        ), 2
    ) AS avg_total_journey_minutes

FROM USER_JOURNEY;

-------------------------------------------------------------------------------------------------
---REVENUE FUNNEL ANALYSIS
-------------------------------------------------------------------------------------------------
WITH FUNNEL_REVENUE AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors, 
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
        SUM( CASE WHEN event_type = 'purchase' THEN user_id END) AS total_revenue, 
        COUNT( CASE WHEN event_type = 'purchase' THEN user_id END) AS total_order

    FROM AnalysisDB.dbo.user_events
    WHERE TRY_CONVERT(datetime2, event_date) >= DATEADD(DAY,-30,'2026-02-03')
)
SELECT
 total_buyers,
 total_visitors,
 total_revenue,
 total_order,
 total_revenue/total_order as avg_order_value,
 total_revenue/total_buyers as revenue_per_buyer,
 total_revenue/total_visitors as revenue_per_visitor
FROM FUNNEL_REVENUE ;


-------------------------------------------------------------------------------------------------------------------
---END
-------------------------------------------------------------------------------------------------------------------
