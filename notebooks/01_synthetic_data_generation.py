import os
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

def generate_spotlight_experiment_data(
    num_users=25000,
    num_sessions=150000,
    random_seed=42,
    # Treatment parameters
    d28_treatment_effect=-0.025,       # Simulated latent D28 retention drop
    shares_treatment_effect=0.35,       # Simulated positive short-term share gain
    dissatisfaction_base_rate=0.03,     # Baseline user negative feedback rate
    variant_dissatisfaction_mult=1.85   # Spike in frustration / uninstall proxies
):
    np.random.seed(random_seed)
    
    # 1. User Cohort Generation
    user_ids = [f"usr_{str(i).zfill(6)}" for i in range(1, num_users + 1)]
    start_date = datetime(2026, 8, 1)
    
    cohort_dates = [start_date + timedelta(days=int(np.random.exponential(scale=7))) for _ in range(num_users)]
    device_os = np.random.choice(['iOS', 'Android'], size=num_users, p=[0.58, 0.42])
    region = np.random.choice(['US_WEST', 'US_EAST', 'EU_WEST', 'APAC'], size=num_users, p=[0.40, 0.30, 0.18, 0.12])
    
    # Random experiment assignment (50/50 split)
    experiment_group = np.random.choice(
        ['Control_Standard_Recs', 'Variant_Algorithmic_Exploration'],
        size=num_users,
        p=[0.50, 0.50]
    )
    
    dim_users = pd.DataFrame({
        'user_id': user_ids,
        'cohort_date': cohort_dates,
        'device_os': device_os,
        'region': region,
        'experiment_group': experiment_group
    })
    
    # 2. Session Data Generation with Granular Guardrails
    session_records = []
    user_group_map = dict(zip(dim_users['user_id'], dim_users['experiment_group']))
    user_cohort_map = dict(zip(dim_users['user_id'], dim_users['cohort_date']))
    
    for _ in range(num_sessions):
        uid = np.random.choice(user_ids)
        grp = user_group_map[uid]
        c_date = user_cohort_map[uid]
        
        # Session timing within 30 days of cohort onboard
        days_offset = int(np.random.triangular(left=0, mode=4, right=30))
        sess_ts = c_date + timedelta(days=days_offset, hours=int(np.random.uniform(0, 24)))
        
        # Base Latency & Watch Completion (Independent of long-term retention)
        avg_watch_completion = np.clip(np.random.beta(a=2, b=5 if grp == 'Control_Standard_Recs' else 4.8), 0.05, 1.0)
        avg_latency_ms = int(np.random.normal(loc=210 if grp == 'Control_Standard_Recs' else 218, scale=35))
        
        # Short-term Engagement: Shares (Spikes in Variant)}
        shares_lambda = 0.85 if grp == 'Control_Standard_Recs' else (0.85 * (1 + shares_treatment_effect))
        total_shares = np.random.poisson(lam=shares_lambda)
        
        # Guardrail Metric: Negative Feedback / Uninstall Proxy Signal
        dissatisfaction_prob = dissatisfaction_base_rate * (variant_dissatisfaction_mult if grp == 'Variant_Algorithmic_Exploration' else 1.0)
        negative_feedback_flag = 1 if np.random.rand() < dissatisfaction_prob else 0
        
        session_records.append({
            'session_id': f"sess_{np.random.randint(10000000, 99999999)}",
            'user_id': uid,
            'session_timestamp': sess_ts,
            'avg_watch_completion': round(float(avg_watch_completion), 4),
            'avg_latency_ms': max(50, avg_latency_ms),
            'total_shares': int(total_shares),
            'negative_feedback_flag': negative_feedback_flag
        })
        
    fact_user_sessions = pd.DataFrame(session_records)
    
    # Save datasets locally for BigQuery staging
    os.makedirs('data', exist_ok=True)
    dim_users.to_csv('data/dim_users.csv', index=False)
    fact_user_sessions.to_csv('data/fact_user_sessions.csv', index=False)
    print("Synthetic dataset successfully re-generated with guardrail telemetry.")
    return dim_users, fact_user_sessions

if __name__ == "__main__":
    generate_spotlight_experiment_data()
