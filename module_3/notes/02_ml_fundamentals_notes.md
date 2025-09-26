# ML Fundamentals - Notes

## Understanding Data

### Key Components
- **Features (X)**: Input variables used to make predictions
  - Also called: attributes, predictors, independent variables
  - Examples: age, income, temperature, pixel values
- **Labels (y)**: Target variable we want to predict
  - Also called: target, response, dependent variable
  - Examples: price, category, probability
- **Observations**: Individual data points or samples
- **Dataset**: Collection of observations

### Types of Data
- **Numerical**: Continuous (height, temperature) or discrete (count, age)
- **Categorical**: Nominal (color, brand) or ordinal (rating, grade)
- **Text**: Unstructured text data requiring special processing
- **Time Series**: Data with temporal dependencies

### Dataset Splits
- **Training Set (60-70%)**: Used to train the model
- **Validation Set (15-20%)**: Used for hyperparameter tuning and model selection
- **Test Set (15-20%)**: Used for final, unbiased evaluation

**Why separate sets?**
- Prevents data leakage
- Provides unbiased performance estimates
- Enables proper hyperparameter tuning

## Bias vs. Variance Tradeoff

### Bias
- **Definition**: Error due to overly simplistic assumptions
- **High Bias**: Model consistently misses relevant patterns
- **Characteristics**: 
  - Underfitting
  - Poor performance on both training and test data
  - Too simple to capture underlying patterns
- **Examples**: Linear model for non-linear data

### Variance
- **Definition**: Error due to sensitivity to small fluctuations in training data
- **High Variance**: Model varies significantly with different training sets
- **Characteristics**:
  - Overfitting
  - Good performance on training data, poor on test data
  - Too complex, memorizes noise
- **Examples**: Deep decision tree, high-degree polynomial

### The Tradeoff
**Total Error = Bias² + Variance + Irreducible Error**

- **Irreducible Error**: Noise in the data that cannot be reduced
- **Goal**: Find optimal balance between bias and variance
- **Sweet Spot**: Model complex enough to capture patterns but simple enough to generalize

### Managing Bias-Variance
- **Reduce Bias**: 
  - Increase model complexity
  - Add more features
  - Reduce regularization
- **Reduce Variance**: 
  - Decrease model complexity
  - Get more training data
  - Add regularization
  - Use ensemble methods

## Underfitting vs. Overfitting

### Underfitting (High Bias)
- **Definition**: Model is too simple to capture underlying patterns
- **Symptoms**:
  - Poor performance on training data
  - Poor performance on test data
  - High training error
  - Training and validation errors are similar but high
- **Solutions**:
  - Increase model complexity
  - Add more features
  - Reduce regularization
  - Train for more epochs

### Overfitting (High Variance)
- **Definition**: Model memorizes training data including noise
- **Symptoms**:
  - Excellent performance on training data
  - Poor performance on test data
  - Low training error, high validation error
  - Large gap between training and validation performance
- **Solutions**:
  - Reduce model complexity
  - Get more training data
  - Add regularization (L1, L2, dropout)
  - Early stopping
  - Cross-validation

### Good Fit
- **Characteristics**:
  - Good performance on both training and test data
  - Small gap between training and validation error
  - Captures underlying patterns without memorizing noise
- **Indicators**:
  - Training and validation curves converge
  - Reasonable performance on unseen data

## Train-Validation-Test Splits

### Purpose of Each Set

#### Training Set
- **Purpose**: Train the model parameters
- **Size**: 60-70% of total data
- **Usage**: Model learns patterns from this data
- **Note**: Model sees this data during training

#### Validation Set
- **Purpose**: Hyperparameter tuning and model selection
- **Size**: 15-20% of total data
- **Usage**: 
  - Compare different models
  - Tune hyperparameters
  - Monitor overfitting during training
- **Note**: Used for decision-making but not parameter learning

#### Test Set
- **Purpose**: Final, unbiased evaluation
- **Size**: 15-20% of total data
- **Usage**: 
  - Estimate real-world performance
  - Final model assessment
- **Note**: Should only be used once at the very end

### Best Practices
1. **Stratification**: Maintain class distribution across splits
2. **Random State**: Set seed for reproducible results
3. **Time Series**: Use temporal splits for time-dependent data
4. **No Data Leakage**: Ensure no information flows from future to past

## Cross-Validation

### K-Fold Cross-Validation
- **Process**:
  1. Divide data into k equal folds
  2. Train on k-1 folds, validate on 1 fold
  3. Repeat k times, each fold serves as validation once
  4. Average results across all folds

### Benefits
- **Better Data Utilization**: Every sample used for both training and validation
- **More Reliable Estimates**: Reduces variance in performance estimates
- **Robust Model Selection**: Less dependent on particular train-validation split

### Types of Cross-Validation
- **K-Fold**: Standard approach, typically k=5 or k=10
- **Stratified K-Fold**: Maintains class distribution in each fold
- **Leave-One-Out (LOO)**: k equals number of samples
- **Time Series Split**: Respects temporal order
- **Group K-Fold**: Ensures samples from same group don't appear in both train and validation

### When to Use
- **Model Selection**: Compare different algorithms
- **Hyperparameter Tuning**: Find optimal parameters
- **Performance Estimation**: Get reliable performance metrics
- **Small Datasets**: Make better use of limited data

## Model Evaluation Best Practices

### Workflow
1. **Split data** into train/validation/test
2. **Use cross-validation** on training data for model selection
3. **Tune hyperparameters** using validation set
4. **Final evaluation** on test set (only once!)
5. **Never touch test set** until final evaluation

### Common Mistakes
- **Data Leakage**: Information from test set influences training
- **Multiple Testing**: Using test set multiple times
- **Improper Splitting**: Not maintaining temporal order in time series
- **Ignoring Class Imbalance**: Not stratifying splits

### Monitoring Training
- **Learning Curves**: Plot training and validation performance over time
- **Early Stopping**: Stop training when validation performance stops improving
- **Regularization**: Add constraints to prevent overfitting

## Key Metrics to Track

### During Training
- **Training Loss**: How well model fits training data
- **Validation Loss**: How well model generalizes
- **Gap Between Losses**: Indicator of overfitting

### For Final Evaluation
- **Test Performance**: Unbiased estimate of real-world performance
- **Confidence Intervals**: Uncertainty in performance estimates
- **Multiple Metrics**: Don't rely on single metric

## Summary

### Critical Concepts
1. **Data Understanding**: Know your features, labels, and data quality
2. **Bias-Variance Tradeoff**: Balance model complexity
3. **Proper Validation**: Use appropriate train/validation/test splits
4. **Cross-Validation**: Get reliable performance estimates
5. **Avoid Overfitting**: Monitor training and use regularization

### Red Flags
- Perfect training accuracy but poor test performance (overfitting)
- Poor performance on both training and test (underfitting)
- Using test set for model selection (data leakage)
- Large gap between training and validation performance

### Next Steps
- Learn about specific ML algorithms
- Practice with real datasets
- Understand evaluation metrics for different problem types
- Explore regularization techniques