import pandas as pd
import numpy as np
from scipy import stats
import statsmodels.api as sm
from google.cloud import bigquery

client = bigquery.Client(project='driiiportfolio')
query = "SELECT * FROM `driiiportfolio.snap_spotlight_growth.vw_user_retention_experiment_summary`"
df = client.query(query).to_dataframe()

# 1. Sample Ratio Mismatch (SRM) Check
observed = df['experiment_group'].value_counts()
expected = [len(df)/2, len(df)/2]
chi2, p_srm = stats.chisquare(f_obs=observed, f_exp=expected)
print(f"SRM Check: Chi2 = {chi2:.4f}, p-value = {p_srm:.4f}")

# 2. Welch's T-Test for D28 Retention
ctrl_d28 = df[df['experiment_group'] == 'Control_Standard_Recs']['retained_d28']
var_d28 = df[df['experiment_group'] == 'Variant_Algorithmic_Exploration']['retained_d28']

t_stat, p_val = stats.ttest_ind(var_d28, ctrl_d28, equal_var=False)
print(f"Welch's T-Test D28 Retention: t-stat = {t_stat:.4f}, p-value = {p_val:.4e}")

# 3. Logistic Regression Modeling
X = df[['avg_watch_completion', 'avg_latency_ms', 'total_shares']]
X = sm.add_constant(X)
y = df['retained_d7']

logit_model = sm.Logit(y, X).fit()
print(logit_model.summary())
