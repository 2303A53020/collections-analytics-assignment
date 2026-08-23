-- =============================================================================
-- STAGING & DATA CLEANING: DEDUPLICATED PAYMENTS
-- Removes duplicate webhook retries and filters strictly for SUCCESS payments
-- =============================================================================
CREATE OR REPLACE TABLE stg_clean_payments AS
WITH ranked_payments AS (
    SELECT 
        payment_id,
        account_id,
        payment_reference,
        amount,
        payment_status,
        payment_method,
        CAST(event_at AS TIMESTAMP) AS event_at_utc,
        ROW_NUMBER() OVER (
            PARTITION BY payment_reference 
            ORDER BY CAST(event_at AS TIMESTAMP) ASC
        ) AS dedupe_rank
    FROM raw_payments
    WHERE payment_status = 'SUCCESS'
)
SELECT 
    payment_id,
    account_id,
    payment_reference,
    amount,
    payment_method,
    event_at_utc
FROM ranked_payments
WHERE dedupe_rank = 1;

-- =============================================================================
-- GOLDEN DATASET MART: ACCOUNT-LEVEL MASTER AGGREGATIONS
-- =============================================================================
CREATE OR REPLACE TABLE golden_dataset_master AS
SELECT 
    a.account_id,
    a.borrower_id,
    a.loan_type,
    a.principal_amount,
    a.outstanding_amount,
    a.dpd,
    a.risk_segment,
    a.status AS account_status,
    COALESCE(p.total_successful_payments, 0) AS total_successful_payments,
    COALESCE(p.total_amount_recovered, 0.0) AS total_amount_recovered
FROM accounts a
LEFT JOIN (
    SELECT 
        account_id,
        COUNT(payment_id) AS total_successful_payments,
        SUM(amount) AS total_amount_recovered
    FROM stg_clean_payments
    GROUP BY account_id
) p ON a.account_id = p.account_id;
