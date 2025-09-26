# Regression Models - Notes

## Linear Regression

### What is Linear Regression?
- **Definition**: Statistical method to model relationship between dependent variable and independent variables
- **Assumption**: Linear relationship between features and target
- **Goal**: Find best-fitting line through data points
- **Output**: Continuous numerical values

### Mathematical Foundation

#### Simple Linear Regression
- **Equation**: y = β₀ + β₁x + ε
- **Components**:
  - y: Dependent variable (target)
  - x: Independent variable (feature)
  - β₀: Intercept (y-value when x=0)
  - β₁: Slope (change in y per unit change in x)
  - ε: Error term (residual)

#### Multiple Linear Regression
- **Equation**: y = β₀ + β₁x₁ + β₂x₂ + ... + βₙxₙ + ε
- **Matrix Form**: y = Xβ + ε
- **Solution**: β = (XᵀX)⁻¹Xᵀy (Normal Equation)

### Assumptions of Linear Regression

1. **Linearity**: Relationship between X and y is linear
2. **Independence**: Observations are independent
3. **Homoscedasticity**: Constant variance of residuals
4. **Normality**: Residuals are normally distributed
5. **No Multicollinearity**: Features are not highly correlated

### Types of Linear Regression

#### Simple Linear Regression
- **Use Case**: One independent variable
- **Example**: Predicting house price based on size
- **Interpretation**: Easy to visualize and understand

#### Multiple Linear Regression
- **Use Case**: Multiple independent variables
- **Example**: Predicting house price based on size, location, age
- **Benefits**: More realistic, captures complex relationships

### Advantages
- **Interpretability**: Easy to understand coefficients
- **Speed**: Fast training and prediction
- **No Hyperparameters**: Simple to implement
- **Baseline**: Good starting point for regression problems
- **Statistical Properties**: Well-understood mathematical foundation

### Limitations
- **Linearity Assumption**: May not capture non-linear relationships
- **Sensitive to Outliers**: Outliers can significantly affect the model
- **Multicollinearity**: Correlated features can cause instability
- **Feature Scaling**: May need preprocessing for optimal performance

### Use Cases
- **Economics**: Demand forecasting, price modeling
- **Finance**: Risk assessment, portfolio optimization
- **Marketing**: Sales prediction, customer lifetime value
- **Healthcare**: Dose-response relationships
- **Engineering**: Quality control, process optimization

### Implementation Considerations
```python
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler

# Feature scaling often helpful
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Fit model
model = LinearRegression()
model.fit(X_scaled, y)

# Coefficients interpretation
print(f"Intercept: {model.intercept_}")
print(f"Coefficients: {model.coef_}")
```

## Logistic Regression

### What is Logistic Regression?
- **Definition**: Statistical method for binary and multi-class classification
- **Purpose**: Predict probability of class membership
- **Output**: Probabilities between 0 and 1
- **Decision**: Use threshold (typically 0.5) to make final classification

### Mathematical Foundation

#### Sigmoid Function
- **Equation**: σ(z) = 1 / (1 + e⁻ᶻ)
- **Properties**:
  - Maps any real number to (0, 1)
  - S-shaped curve
  - Smooth and differentiable
  - σ(0) = 0.5

#### Logistic Function
- **Linear Combination**: z = β₀ + β₁x₁ + β₂x₂ + ... + βₙxₙ
- **Probability**: P(y=1|x) = σ(z) = 1 / (1 + e⁻ᶻ)
- **Odds**: P(y=1) / P(y=0) = eᶻ
- **Log-Odds (Logit)**: ln(odds) = z

### Types of Logistic Regression

#### Binary Classification
- **Use Case**: Two classes (0 or 1, Yes or No)
- **Examples**: Spam detection, medical diagnosis, pass/fail
- **Output**: Single probability P(y=1)

#### Multi-class Classification
- **One-vs-Rest (OvR)**: Train binary classifier for each class
- **Multinomial**: Direct multi-class extension
- **Output**: Probability for each class (sum to 1)

### Advantages
- **Probabilistic Output**: Provides confidence in predictions
- **No Assumptions**: About distribution of features
- **Less Overfitting**: Compared to more complex models
- **Fast**: Efficient training and prediction
- **Interpretable**: Coefficients have clear meaning

### Limitations
- **Linear Decision Boundary**: May not capture complex patterns
- **Sensitive to Outliers**: Extreme values can affect model
- **Feature Scaling**: Benefits from normalized features
- **Large Sample Size**: Needs sufficient data for stable results

### Applications

#### Spam Detection
- **Features**: Email content, sender information, metadata
- **Target**: Spam (1) or Not Spam (0)
- **Benefit**: Probabilistic output helps set thresholds

#### Medical Diagnosis
- **Features**: Symptoms, test results, patient history
- **Target**: Disease present (1) or absent (0)
- **Benefit**: Probability helps assess risk levels

#### Marketing
- **Features**: Customer demographics, purchase history
- **Target**: Will buy (1) or won't buy (0)
- **Benefit**: Target high-probability customers

### Implementation
```python
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler

# Scale features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Fit model
model = LogisticRegression()
model.fit(X_scaled, y)

# Predictions
probabilities = model.predict_proba(X_test)
predictions = model.predict(X_test)
```

## Evaluation Metrics

### Regression Metrics

#### Mean Squared Error (MSE)
- **Formula**: MSE = (1/n) Σ(yᵢ - ŷᵢ)²
- **Properties**:
  - Always positive
  - Penalizes large errors more
  - Same units as y²
- **Use Case**: When large errors are particularly bad

#### Root Mean Squared Error (RMSE)
- **Formula**: RMSE = √MSE
- **Properties**:
  - Same units as target variable
  - Interpretable scale
  - Sensitive to outliers
- **Use Case**: Most common regression metric

#### Mean Absolute Error (MAE)
- **Formula**: MAE = (1/n) Σ|yᵢ - ŷᵢ|
- **Properties**:
  - Same units as target variable
  - Less sensitive to outliers
  - Linear penalty for errors
- **Use Case**: When outliers shouldn't dominate

#### R-squared (R²)
- **Formula**: R² = 1 - (SS_res / SS_tot)
- **Range**: (-∞, 1], where 1 is perfect fit
- **Interpretation**: Proportion of variance explained
- **Use Case**: Model comparison, goodness of fit

### Classification Metrics

#### Confusion Matrix
```
                Predicted
                0    1
Actual    0    TN   FP
          1    FN   TP
```
- **True Positive (TP)**: Correctly predicted positive
- **True Negative (TN)**: Correctly predicted negative
- **False Positive (FP)**: Incorrectly predicted positive (Type I error)
- **False Negative (FN)**: Incorrectly predicted negative (Type II error)

#### Accuracy
- **Formula**: Accuracy = (TP + TN) / (TP + TN + FP + FN)
- **Range**: [0, 1], where 1 is perfect
- **Use Case**: Balanced datasets
- **Limitation**: Misleading with imbalanced classes

#### Precision
- **Formula**: Precision = TP / (TP + FP)
- **Interpretation**: Of predicted positives, how many are actually positive?
- **Use Case**: When false positives are costly
- **Example**: Spam detection (don't want to mark good emails as spam)

#### Recall (Sensitivity)
- **Formula**: Recall = TP / (TP + FN)
- **Interpretation**: Of actual positives, how many did we catch?
- **Use Case**: When false negatives are costly
- **Example**: Disease detection (don't want to miss sick patients)

#### F1-Score
- **Formula**: F1 = 2 × (Precision × Recall) / (Precision + Recall)
- **Properties**: Harmonic mean of precision and recall
- **Range**: [0, 1], where 1 is perfect
- **Use Case**: Balance between precision and recall

#### ROC-AUC
- **ROC Curve**: True Positive Rate vs False Positive Rate
- **AUC**: Area Under the ROC Curve
- **Range**: [0, 1], where 0.5 is random, 1 is perfect
- **Use Case**: Binary classification performance across all thresholds
- **Benefit**: Threshold-independent metric

### Choosing the Right Metric

#### For Regression
- **RMSE**: Most common, penalizes large errors
- **MAE**: When outliers shouldn't dominate
- **R²**: For model comparison and interpretation

#### For Classification
- **Accuracy**: Balanced datasets, equal cost of errors
- **Precision**: When false positives are costly
- **Recall**: When false negatives are costly
- **F1-Score**: Balance precision and recall
- **ROC-AUC**: Overall performance across thresholds

### Practical Considerations

#### Class Imbalance
- **Problem**: Accuracy can be misleading
- **Solutions**: 
  - Use precision, recall, F1-score
  - Consider class weights
  - Use stratified sampling

#### Business Context
- **Cost-Sensitive**: Consider cost of different error types
- **Threshold Tuning**: Adjust based on business requirements
- **Multiple Metrics**: Don't rely on single metric

#### Model Comparison
- **Cross-Validation**: Use CV for reliable metric estimates
- **Statistical Tests**: Test for significant differences
- **Domain Knowledge**: Consider practical significance

## Summary

### Linear Regression
- **Best For**: Continuous target, linear relationships
- **Strengths**: Interpretable, fast, good baseline
- **Weaknesses**: Assumes linearity, sensitive to outliers
- **Use Cases**: Price prediction, demand forecasting

### Logistic Regression
- **Best For**: Binary/multi-class classification
- **Strengths**: Probabilistic output, interpretable, robust
- **Weaknesses**: Linear decision boundary, needs feature scaling
- **Use Cases**: Spam detection, medical diagnosis, marketing

### Key Takeaways
1. **Choose Right Model**: Linear for regression, logistic for classification
2. **Check Assumptions**: Especially linearity and independence
3. **Preprocess Data**: Scale features, handle outliers
4. **Use Appropriate Metrics**: Match metrics to problem type and business needs
5. **Validate Properly**: Use train/validation/test splits and cross-validation

### Next Steps
- Practice with real datasets
- Learn about regularization (Ridge, Lasso)
- Explore polynomial features for non-linear relationships
- Study advanced regression techniques (Elastic Net, Bayesian regression)