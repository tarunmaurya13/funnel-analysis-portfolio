"""
Simulated A/B test: contextual welcome banner for youtube.com-referred sessions
Sized per power analysis: ~4,049 sessions per arm (alpha=0.05, power=0.80,
baseline=1.3%, target=2.0%)

Clearly labeled as SIMULATED data for portfolio purposes.
"""
import numpy as np
import pandas as pd
from statsmodels.stats.proportion import proportions_ztest, proportion_confint

np.random.seed(42)  # reproducible

# Sample sizes matching the power analysis
n_control = 4049
n_treatment = 4049

# Baseline (control) product-view rate = actual measured rate
control_rate = 0.013

# Simulated true effect: banner lifts rate to 2.0% (the MDE we powered for)
treatment_rate = 0.020

# Simulate binary outcomes (1 = viewed a product page, 0 = did not)
control_conversions = np.random.binomial(1, control_rate, n_control)
treatment_conversions = np.random.binomial(1, treatment_rate, n_treatment)

control_successes = control_conversions.sum()
treatment_successes = treatment_conversions.sum()

# Two-proportion z-test (one-sided: testing for improvement)
count = np.array([treatment_successes, control_successes])
nobs = np.array([n_treatment, n_control])
z_stat, p_value = proportions_ztest(count, nobs, alternative='larger')

# Confidence intervals for each rate
control_ci = proportion_confint(control_successes, n_control, alpha=0.05, method='wilson')
treatment_ci = proportion_confint(treatment_successes, n_treatment, alpha=0.05, method='wilson')

control_observed_rate = control_successes / n_control
treatment_observed_rate = treatment_successes / n_treatment
lift = treatment_observed_rate - control_observed_rate
relative_lift = (lift / control_observed_rate) * 100

print("=== SIMULATED A/B TEST RESULTS ===")
print(f"Control:   n={n_control}, conversions={control_successes}, rate={control_observed_rate:.4f} (95% CI: {control_ci[0]:.4f}-{control_ci[1]:.4f})")
print(f"Treatment: n={n_treatment}, conversions={treatment_successes}, rate={treatment_observed_rate:.4f} (95% CI: {treatment_ci[0]:.4f}-{treatment_ci[1]:.4f})")
print(f"Absolute lift: {lift:.4f} ({lift*100:.2f} percentage points)")
print(f"Relative lift: {relative_lift:.1f}%")
print(f"Z-statistic: {z_stat:.4f}")
print(f"P-value (one-sided): {p_value:.6f}")
print(f"Statistically significant at alpha=0.05: {p_value < 0.05}")

# Save raw simulated session-level data for transparency/reproducibility
df = pd.DataFrame({
    'session_id': [f'ctrl_{i}' for i in range(n_control)] + [f'treat_{i}' for i in range(n_treatment)],
    'group': ['control'] * n_control + ['treatment'] * n_treatment,
    'viewed_product': np.concatenate([control_conversions, treatment_conversions])
})
df.to_csv('/home/claude/funnel-analysis-portfolio/analysis/ab_test_simulated_sessions.csv', index=False)
print(f"\nSaved {len(df)} simulated session rows to ab_test_simulated_sessions.csv")
