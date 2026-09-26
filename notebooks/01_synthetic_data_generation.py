import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Set random seed for statistical consistency
np.random.seed(42)

NUM_USERS = 25000
NUM_SESSIONS = 100000

# 1. Generate User Dimension Data
user_ids = [f"USR_{100000 + i}" for i in range(NUM_USERS)]
cohort_dates = [datetime(2026, 8, 1) + timedelta(days=int(x)) for x in np.random.randint(0, 30, NUM_USERS)]
exp_group = np.random.choice(['Control_Standard_Recs', 'Variant_Algorithmic_Exploration'], size=NUM_USERS, p=[0.5, 0.5])

df_users = pd.DataFrame({
    'user_id': user_ids,
    'cohort_date': cohort_dates,
    'experiment_group': exp_group
})

# 2. Generate Fact Session Data
session_user_ids = np.random.choice(user_ids, size=NUM_SESSIONS)
session_dates = [datetime(2026, 8, 1) + timedelta(days=int(x), hours=int(y)) 
                 for x, y in zip(np.random.randint(0, 45, NUM_SESSIONS), np.random.randint(0, 24, NUM_SESSIONS))]

watch_completion = np.random.beta(a=2, b=5, size=NUM_SESSIONS)
latency_ms = np.random.exponential(scale=150, size=NUM_SESSIONS) + 100
shares = np.random.poisson(lam=0.2, size=NUM_SESSIONS)

df_sessions = pd.DataFrame({
    'session_id': [f"SES_{1000000 + i}" for i in range(NUM_SESSIONS)],
    'user_id': session_user_ids,
    'session_timestamp': session_dates,
    'watch_completion_rate': np.round(watch_completion, 4),
    'cold_start_latency_ms': np.round(latency_ms, 2),
    'share_count': shares
})

# Export to CSV
df_users.to_csv('dim_users.csv', index=False)
df_sessions.to_csv('fact_user_sessions.csv', index=False)
print("Files dim_users.csv and fact_user_sessions.csv generated successfully.")
