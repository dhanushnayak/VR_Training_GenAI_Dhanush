# Classification Models - Notes

## Decision Trees

### What are Decision Trees?
- **Definition**: Tree-like model that makes decisions by splitting data based on feature values
- **Structure**: Root node → Internal nodes → Leaf nodes
- **Process**: Follow path from root to leaf based on feature values
- **Output**: Class prediction at leaf node

### How Decision Trees Work

#### Tree Structure
- **Root Node**: Starting point, contains all data
- **Internal Nodes**: Decision points based on feature tests
- **Branches**: Outcomes of feature tests
- **Leaf Nodes**: Final predictions (class labels)

#### Decision Process
1. Start at root node
2. Evaluate feature condition
3. Follow appropriate branch
4. Repeat until reaching leaf node
5. Return leaf node's prediction

### Splitting Criteria

#### Gini Index (Gini Impurity)
- **Formula**: Gini = 1 - Σ(pᵢ)²
- **Range**: [0, 0.5] for binary classification
- **Interpretation**: 
  - 0 = Pure node (all same class)
  - 0.5 = Maximum impurity (equal class distribution)
- **Use**: Default in many implementations

#### Entropy
- **Formula**: Entropy = -Σ pᵢ log₂(pᵢ)
- **Range**: [0, log₂(classes)]
- **Interpretation**:
  - 0 = Pure node
  - Higher values = More mixed classes
- **Use**: Information theory based

#### Information Gain
- **Formula**: IG = Entropy(parent) - Σ(|child|/|parent|) × Entropy(child)
- **Purpose**: Measure reduction in entropy after split
- **Goal**: Maximize information gain
- **Use**: Often used with entropy

### Advantages of Decision Trees
- **Interpretability**: Easy to understand and visualize
- **No Assumptions**: No assumptions about data distribution
- **Handle Mixed Data**: Both numerical and categorical features
- **Feature Selection**: Automatically selects important features
- **Non-linear**: Can capture non-linear relationships
- **Missing Values**: Can handle missing data

### Limitations of Decision Trees
- **Overfitting**: Tend to memorize training data
- **Instability**: Small data changes can create very different trees
- **Bias**: Favor features with more levels
- **Linear Boundaries**: Splits are axis-parallel
- **Difficulty with Linear Relationships**: May need many splits

### Pruning
- **Purpose**: Reduce overfitting by removing unnecessary branches
- **Pre-pruning**: Stop growing tree early (max_depth, min_samples_split)
- **Post-pruning**: Remove branches after tree is built
- **Cost Complexity Pruning**: Balance tree size and accuracy

### Hyperparameters
- **max_depth**: Maximum depth of tree
- **min_samples_split**: Minimum samples required to split
- **min_samples_leaf**: Minimum samples in leaf node
- **max_features**: Number of features to consider for splits
- **criterion**: Splitting criterion (gini, entropy)

## Random Forest

### What is Random Forest?
- **Definition**: Ensemble method that combines multiple decision trees
- **Principle**: "Wisdom of crowds" - many weak learners create strong learner
- **Process**: Train multiple trees on different subsets, average predictions
- **Type**: Bagging (Bootstrap Aggregating) ensemble

### How Random Forest Works

#### Bootstrap Sampling
1. Create multiple bootstrap samples from training data
2. Each sample has same size as original dataset
3. Sampling with replacement (some samples appear multiple times)
4. Each tree trained on different bootstrap sample

#### Random Feature Selection
- At each split, randomly select subset of features
- Typical choice: √(total features) for classification
- Reduces correlation between trees
- Increases diversity in ensemble

#### Prediction Process
- **Classification**: Majority vote from all trees
- **Regression**: Average of all tree predictions
- **Probability**: Average of predicted probabilities

### Advantages of Random Forest
- **Reduced Overfitting**: Averaging reduces variance
- **Robust**: Less sensitive to outliers and noise
- **Feature Importance**: Provides feature importance scores
- **Handles Missing Values**: Can estimate missing values
- **Parallel Training**: Trees can be trained independently
- **Good Default Performance**: Often works well out-of-the-box

### Limitations of Random Forest
- **Less Interpretable**: Harder to understand than single tree
- **Memory Usage**: Stores multiple trees
- **Prediction Time**: Slower than single tree
- **Still Can Overfit**: With very deep trees
- **Bias**: Can be biased toward categorical variables with many categories

### Bagging (Bootstrap Aggregating)

#### Concept
- **Goal**: Reduce variance of high-variance models
- **Method**: Train multiple models on bootstrap samples
- **Combination**: Average predictions (regression) or vote (classification)
- **Benefit**: More stable and robust predictions

#### Why Bagging Works
- **Variance Reduction**: Average of independent estimates has lower variance
- **Bias**: Remains approximately the same
- **Overfitting**: Reduced through averaging
- **Generalization**: Better performance on unseen data

### Feature Importance

#### How It's Calculated
1. For each tree, measure decrease in impurity from each feature
2. Average across all trees
3. Normalize to sum to 1
4. Higher values indicate more important features

#### Types of Importance
- **Gini Importance**: Based on Gini impurity decrease
- **Permutation Importance**: Based on performance decrease when feature is shuffled
- **Drop-Column Importance**: Performance decrease when feature is removed

#### Use Cases
- **Feature Selection**: Remove low-importance features
- **Domain Understanding**: Understand which features matter
- **Model Debugging**: Identify unexpected important features

### Hyperparameters

#### Tree-Related
- **n_estimators**: Number of trees (more is usually better)
- **max_depth**: Maximum depth of trees
- **min_samples_split**: Minimum samples to split
- **min_samples_leaf**: Minimum samples in leaf

#### Random Forest Specific
- **max_features**: Features to consider at each split
- **bootstrap**: Whether to use bootstrap sampling
- **oob_score**: Whether to use out-of-bag samples for validation

### Out-of-Bag (OOB) Error
- **Concept**: Use samples not in bootstrap for validation
- **Benefit**: No need for separate validation set
- **Calculation**: For each sample, predict using trees that didn't see it
- **Use**: Estimate generalization error during training

## Implementation Examples

### Decision Tree
```python
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split

# Create and train model
dt = DecisionTreeClassifier(
    max_depth=5,
    min_samples_split=20,
    min_samples_leaf=10,
    random_state=42
)
dt.fit(X_train, y_train)

# Make predictions
predictions = dt.predict(X_test)
probabilities = dt.predict_proba(X_test)
```

### Random Forest
```python
from sklearn.ensemble import RandomForestClassifier

# Create and train model
rf = RandomForestClassifier(
    n_estimators=100,
    max_depth=10,
    min_samples_split=5,
    min_samples_leaf=2,
    max_features='sqrt',
    random_state=42
)
rf.fit(X_train, y_train)

# Feature importance
importance = rf.feature_importances_
feature_names = X.columns
importance_df = pd.DataFrame({
    'feature': feature_names,
    'importance': importance
}).sort_values('importance', ascending=False)
```

## Comparison: Decision Tree vs Random Forest

### Decision Tree
**Pros**:
- Highly interpretable
- Fast training and prediction
- Handles mixed data types
- No feature scaling needed
- Automatic feature selection

**Cons**:
- Prone to overfitting
- Unstable (high variance)
- Biased toward certain features
- May not capture linear relationships well

### Random Forest
**Pros**:
- Reduced overfitting
- More stable predictions
- Better generalization
- Feature importance scores
- Robust to outliers

**Cons**:
- Less interpretable
- More memory usage
- Slower prediction
- More hyperparameters to tune

## Best Practices

### For Decision Trees
1. **Control Complexity**: Use max_depth, min_samples_split
2. **Validate Carefully**: Use cross-validation to detect overfitting
3. **Visualize Tree**: Plot tree to understand decisions
4. **Prune Appropriately**: Balance complexity and performance

### For Random Forest
1. **Start with Defaults**: Often work well out-of-the-box
2. **Tune n_estimators**: More trees usually better (diminishing returns)
3. **Monitor OOB Score**: Use for model validation
4. **Feature Importance**: Use to understand and select features

### General Guidelines
1. **Data Preprocessing**: Handle missing values, encode categoricals
2. **Feature Engineering**: Create meaningful features
3. **Cross-Validation**: Use for reliable performance estimates
4. **Ensemble Methods**: Consider combining with other models

## Use Cases

### Decision Trees
- **Interpretability Required**: Medical diagnosis, loan approval
- **Rule Extraction**: Need to explain decisions
- **Quick Prototyping**: Fast baseline model
- **Mixed Data Types**: Numerical and categorical features

### Random Forest
- **High Performance**: When accuracy is primary concern
- **Feature Selection**: Identify important variables
- **Robust Predictions**: Noisy or incomplete data
- **Baseline Model**: Good starting point for many problems

## Common Applications

### Healthcare
- **Decision Trees**: Diagnostic rules, treatment protocols
- **Random Forest**: Disease prediction, drug discovery

### Finance
- **Decision Trees**: Credit scoring rules, fraud detection
- **Random Forest**: Risk assessment, algorithmic trading

### Marketing
- **Decision Trees**: Customer segmentation rules
- **Random Forest**: Churn prediction, recommendation systems

### Technology
- **Decision Trees**: Feature engineering, rule-based systems
- **Random Forest**: Click-through rate prediction, spam detection

## Summary

### Key Concepts
1. **Decision Trees**: Interpretable, prone to overfitting
2. **Random Forest**: Ensemble of trees, more robust
3. **Bagging**: Reduces variance through averaging
4. **Feature Importance**: Understand variable significance

### When to Use
- **Decision Tree**: Need interpretability, simple baseline
- **Random Forest**: Need performance, feature importance

### Best Practices
- Control tree complexity to prevent overfitting
- Use cross-validation for reliable evaluation
- Leverage feature importance for insights
- Consider ensemble methods for better performance

### Next Steps
- Practice with different datasets
- Learn about other tree-based methods (Gradient Boosting, XGBoost)
- Explore advanced techniques (feature engineering, hyperparameter tuning)
- Study ensemble methods in depth