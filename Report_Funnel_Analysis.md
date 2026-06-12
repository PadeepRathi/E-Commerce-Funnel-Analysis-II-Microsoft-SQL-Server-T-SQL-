# E-Commerce Funnel Analysis Report

**Period:** December 30, 2025 – February 3, 2026  
**Dataset:** 9,381 events | 5,000 unique users  
**Tool:** Microsoft SQL Server (T-SQL)

---

## Executive Summary

This report analyses the full sales funnel for an e-commerce store over a 35-day period. Of the 5,000 users who landed on the site, **826 completed a purchase**, yielding an overall conversion rate of **16.5%** and total revenue of **$87,975**.

The single largest drop-off occurs at the **View → Add to Cart** step, where 68.9% of visitors leave without engaging. Email is the highest-converting traffic source (33.9%), while Social media significantly underperforms (6.9%).

---

## 1. Funnel Stage Breakdown

| Stage | Unique Users | Drop-off | Retained |
|---|---|---|---|
| Page View | 5,000 | — | 100% |
| Add to Cart | 1,553 | −3,447 | 31.1% |
| Checkout Start | 1,103 | −450 | 22.1% |
| Payment Info | 899 | −204 | 18.0% |
| Purchase | 826 | −73 | **16.5%** |

Once users reach the cart, the funnel performs well — cart-to-purchase conversion is **53.2%**. The problem is getting users into the cart in the first place.

---

## 2. Step-by-Step Conversion Rates

| Transition | Rate | Assessment |
|---|---|---|
| View → Cart | 31.1% | ⚠️ Main bottleneck |
| Cart → Checkout | 71.0% | ✅ Healthy |
| Checkout → Payment | 81.5% | ✅ Strong |
| Payment → Purchase | 91.9% | ✅ Excellent |
| **View → Purchase (Overall)** | **16.5%** | — |

The late-stage funnel (checkout onward) is well-optimised. Efforts should focus upstream on product discovery and add-to-cart motivation.

---

## 3. Funnel by Traffic Source

| Source | Visitors | Cart | Purchases | Revenue | Conv. Rate |
|---|---|---|---|---|---|
| Email | 522 | 326 | 177 | $17,877 | **33.9%** |
| Paid Ads | 968 | 358 | 204 | $21,488 | 21.1% |
| Organic | 2,038 | 669 | 343 | $37,280 | 16.8% |
| Social | 1,472 | 200 | 102 | $11,331 | 6.9% |

**Key observations:**

- **Email** converts at nearly 5× the rate of Social. These users arrive with high intent — likely retargeted or loyalty-driven.
- **Paid Ads** delivers strong ROI at 21.1% conversion. The channel brings 968 visitors and earns $21,488 in revenue.
- **Organic** is the largest volume channel (2,038 visitors) and the top revenue contributor ($37,280), though its conversion rate (16.8%) is average.
- **Social** has the highest volume of any paid/owned channel but the worst conversion (6.9%). High bounce rate suggests a landing page or audience-targeting mismatch.

---

## 4. Revenue Summary

| Metric | Value |
|---|---|
| Total Revenue | $87,975 |
| Total Orders | 826 |
| Average Order Value (AOV) | $106.51 |
| Revenue per Buyer | $106.51 |
| Revenue per Visitor | $17.60 |

The AOV of $106.51 is a solid baseline. Revenue per visitor ($17.60) reflects the 16.5% conversion rate — improving this metric by even 2–3 percentage points would meaningfully grow revenue without increasing traffic spend.

---

## 5. Bottleneck Analysis

### Primary Bottleneck: View → Cart (31.1%)

Nearly 7 in 10 visitors leave without adding anything to cart. Possible causes:

- Product pages lack urgency (no stock counters, limited-time badges)
- Pricing perceived as high relative to perceived value
- Poor product imagery or insufficient social proof (reviews, ratings)
- Traffic quality — especially Social — not aligned with the product offering

### Secondary Bottleneck: Cart → Checkout (71.0%)

While 71% is acceptable, the 450 users who abandon cart represent ~$47,900 in potential lost revenue (at AOV). Cart abandonment email flows could recover a meaningful portion of this.

---

## 6. Recommendations

**1. Fix the Social channel funnel**  
Social drives 29% of all visitors but only 12% of revenue. A/B test dedicated landing pages for social campaigns with clearer product-benefit messaging. Consider retargeting social visitors who viewed but didn't add to cart.

**2. Scale email marketing**  
Email converts at 33.9% — the highest of any channel. Invest in growing the email list (pop-ups, post-purchase opt-ins) and increase send frequency to high-intent segments.

**3. Improve product page CTA**  
The View → Cart rate of 31.1% is the single biggest lever. Test: prominent Add to Cart buttons, urgency signals ("Only 3 left"), trust badges, and review counts above the fold.

**4. Launch cart abandonment recovery**  
With 727 users dropping off after adding to cart, even a 20% recovery rate via automated email would yield ~$15,500 in additional revenue per month.

**5. Protect the checkout flow**  
The 81.5% checkout → payment rate and 91.9% payment → purchase rate are strong. Avoid disrupting this part of the UX with unnecessary changes.

---

## Appendix: SQL Queries Used

All queries are in `Funnel_Analysis.sql`. Sections include:

- Data format validation (`INFORMATION_SCHEMA.COLUMNS`)
- Date conversion from VARCHAR using `TRY_CONVERT(datetime2, ...)`
- Funnel stage counts using `COUNT(DISTINCT CASE WHEN ... THEN user_id END)`
- Conversion rate calculations with `ROUND(... * 100.0 / ..., 0)`
- Source-level funnel breakdown using `GROUP BY traffic_source`
- Time-to-convert using `DATEDIFF(MINUTE, view_time, purchase_time)`
- Revenue analysis including AOV and revenue per visitor

---

*Analysis prepared based on `user_events.csv` — 9,381 events from Dec 30, 2025 to Feb 3, 2026.*
