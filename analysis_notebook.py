import pandas as pd
import numpy as np

# Load Raw Inputs
payments = pd.read_csv('payments.csv')
accounts = pd.read_csv('accounts.csv')
targeting = pd.read_csv('daily_targeting.csv')

# Data Cleaning & Forensics
payments['event_at_utc'] = pd.to_datetime(payments['event_at'], utc=True)
clean_payments = payments[payments['payment_status'] == 'SUCCESS'].drop_duplicates(
    subset=['payment_reference'], keep='first'
)

print(f"Raw Payments Total: ₹{payments[payments['payment_status']=='SUCCESS']['amount'].sum()/1e7:.2f} Cr")
print(f"Clean Payments Total: ₹{clean_payments['amount'].sum()/1e7:.2f} Cr")

# Counterfactual Difference-in-Differences (DiD) Analysis
p_agg = clean_payments.groupby('account_id')['amount'].sum().reset_index()
did_df = targeting.merge(accounts, on='account_id').merge(p_agg, on='account_id', how='left')
did_df['amount'] = did_df['amount'].fillna(0)

did_df['post'] = (pd.to_datetime(did_df['target_date']) >= '2026-04-01').astype(int)
did_df['treated'] = did_df['recommended_channel'].isin(['WHATSAPP', 'VOICE_BOT']).astype(int)

did_matrix = did_df.groupby(['treated', 'post'])['amount'].mean().unstack()
did_effect = (did_matrix.loc[1, 1] - did_matrix.loc[1, 0]) - (did_matrix.loc[0, 1] - did_matrix.loc[0, 0])

print(f"DiD Estimated Strategy Shift Impact: ₹{did_effect:.2f} per account")
