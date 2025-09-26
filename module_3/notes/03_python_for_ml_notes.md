# Python for Machine Learning - Notes

## NumPy for Numerical Computing

### Core Concepts
- **ndarray**: N-dimensional array object, foundation of NumPy
- **Vectorization**: Operations on entire arrays without explicit loops
- **Broadcasting**: Operations between arrays of different shapes
- **Memory Efficiency**: Contiguous memory layout for fast operations

### Essential Operations

#### Array Creation
```python
import numpy as np

# From lists
arr = np.array([1, 2, 3, 4])
matrix = np.array([[1, 2], [3, 4]])

# Special arrays
zeros = np.zeros((3, 3))
ones = np.ones((2, 4))
identity = np.eye(3)
random = np.random.randn(2, 3)
range_arr = np.arange(0, 10, 2)
linspace = np.linspace(0, 1, 5)
```

#### Array Properties
- `shape`: Dimensions of array
- `dtype`: Data type of elements
- `size`: Total number of elements
- `ndim`: Number of dimensions

#### Mathematical Operations
- **Element-wise**: `+`, `-`, `*`, `/`, `**`
- **Aggregations**: `sum()`, `mean()`, `std()`, `min()`, `max()`
- **Linear Algebra**: `dot()`, `matmul()`, `linalg.inv()`, `linalg.det()`

### ML Applications
- **Data Representation**: Store datasets as arrays
- **Mathematical Operations**: Efficient computations
- **Matrix Operations**: Linear algebra for ML algorithms
- **Random Sampling**: Generate synthetic data

## Pandas for Data Manipulation

### Core Data Structures
- **Series**: 1D labeled array
- **DataFrame**: 2D labeled data structure (like Excel spreadsheet)

### Essential Operations

#### Data Loading
```python
import pandas as pd

# From various sources
df = pd.read_csv('data.csv')
df = pd.read_excel('data.xlsx')
df = pd.read_json('data.json')
df = pd.read_sql(query, connection)
```

#### Data Exploration
```python
# Basic info
df.head()          # First 5 rows
df.tail()          # Last 5 rows
df.info()          # Data types and memory usage
df.describe()      # Statistical summary
df.shape           # Dimensions
df.columns         # Column names
df.dtypes          # Data types
```

#### Data Cleaning
```python
# Handle missing values
df.isnull().sum()           # Count missing values
df.dropna()                 # Remove rows with missing values
df.fillna(value)            # Fill missing values
df.interpolate()            # Interpolate missing values

# Remove duplicates
df.drop_duplicates()

# Data type conversion
df['column'].astype('int')
pd.to_datetime(df['date'])
pd.to_numeric(df['number'])
```

#### Data Manipulation
```python
# Filtering
df[df['column'] > value]
df.query('column > value')

# Sorting
df.sort_values('column')
df.sort_index()

# Grouping
df.groupby('category').mean()
df.groupby(['cat1', 'cat2']).agg({'col1': 'mean', 'col2': 'sum'})

# Adding columns
df['new_col'] = df['col1'] + df['col2']
df['new_col'] = df['col'].apply(lambda x: x * 2)
```

### ML Applications
- **Data Loading**: Import datasets from various formats
- **Data Cleaning**: Handle missing values, outliers
- **Feature Engineering**: Create new features from existing ones
- **Data Exploration**: Understand data distribution and relationships

## Matplotlib for Visualization

### Basic Plot Types
```python
import matplotlib.pyplot as plt

# Line plot
plt.plot(x, y)

# Scatter plot
plt.scatter(x, y)

# Bar plot
plt.bar(categories, values)

# Histogram
plt.hist(data, bins=20)

# Box plot
plt.boxplot(data)
```

### Customization
```python
# Labels and titles
plt.xlabel('X Label')
plt.ylabel('Y Label')
plt.title('Plot Title')
plt.legend(['Series 1', 'Series 2'])

# Styling
plt.grid(True)
plt.style.use('seaborn')
plt.figure(figsize=(10, 6))

# Subplots
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
axes[0, 0].plot(x, y)
```

### ML Applications
- **Data Exploration**: Visualize data distributions
- **Model Evaluation**: Plot learning curves, confusion matrices
- **Results Presentation**: Create publication-ready plots

## Seaborn for Statistical Visualization

### Advantages over Matplotlib
- **Statistical Focus**: Built-in statistical plots
- **Beautiful Defaults**: Attractive styling out of the box
- **DataFrame Integration**: Works directly with pandas DataFrames

### Key Plot Types
```python
import seaborn as sns

# Distribution plots
sns.histplot(data=df, x='column')
sns.boxplot(data=df, x='category', y='value')
sns.violinplot(data=df, x='category', y='value')

# Relationship plots
sns.scatterplot(data=df, x='x', y='y', hue='category')
sns.lineplot(data=df, x='x', y='y')
sns.regplot(data=df, x='x', y='y')

# Categorical plots
sns.barplot(data=df, x='category', y='value')
sns.countplot(data=df, x='category')

# Matrix plots
sns.heatmap(correlation_matrix, annot=True)
sns.clustermap(data)

# Multi-plot grids
sns.pairplot(df)
sns.FacetGrid(df, col='category')
```

### ML Applications
- **Exploratory Data Analysis**: Understand data patterns
- **Feature Relationships**: Visualize correlations
- **Model Diagnostics**: Residual plots, distribution checks

## Scikit-learn for Machine Learning

### Core Philosophy
- **Consistent API**: Same interface across all algorithms
- **Fit-Transform Pattern**: Standardized workflow
- **Modular Design**: Mix and match components

### Key Components

#### Estimators (Models)
```python
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC

# All follow same pattern
model = LinearRegression()
model.fit(X_train, y_train)
predictions = model.predict(X_test)
```

#### Transformers (Preprocessing)
```python
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.feature_selection import SelectKBest

# Fit on training data, transform both train and test
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)
```

#### Model Selection
```python
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Cross-validation
scores = cross_val_score(model, X, y, cv=5)

# Hyperparameter tuning
grid_search = GridSearchCV(model, param_grid, cv=5)
grid_search.fit(X_train, y_train)
```

#### Metrics
```python
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# Classification metrics
accuracy = accuracy_score(y_true, y_pred)
precision = precision_score(y_true, y_pred)

# Regression metrics
from sklearn.metrics import mean_squared_error, r2_score
mse = mean_squared_error(y_true, y_pred)
```

### Pipelines
```python
from sklearn.pipeline import Pipeline

# Combine preprocessing and modeling
pipeline = Pipeline([
    ('scaler', StandardScaler()),
    ('classifier', RandomForestClassifier())
])

pipeline.fit(X_train, y_train)
predictions = pipeline.predict(X_test)
```

### ML Workflow with Scikit-learn
1. **Data Loading**: Use pandas to load data
2. **Data Splitting**: `train_test_split()`
3. **Preprocessing**: Scalers, encoders, feature selection
4. **Model Training**: Fit estimator to training data
5. **Evaluation**: Use metrics to assess performance
6. **Hyperparameter Tuning**: `GridSearchCV` or `RandomizedSearchCV`
7. **Final Evaluation**: Test on held-out test set

## Integration: Complete ML Pipeline

### Example Workflow
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix

# 1. Data Loading (Pandas)
df = pd.read_csv('data.csv')

# 2. Data Exploration (Pandas + Seaborn)
print(df.info())
sns.pairplot(df)
plt.show()

# 3. Data Preprocessing (Pandas + NumPy)
X = df.drop('target', axis=1).values
y = df['target'].values

# 4. Train-Test Split (Scikit-learn)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# 5. Feature Scaling (Scikit-learn)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 6. Model Training (Scikit-learn)
model = RandomForestClassifier()
model.fit(X_train_scaled, y_train)

# 7. Evaluation (Scikit-learn + Matplotlib)
y_pred = model.predict(X_test_scaled)
print(classification_report(y_test, y_pred))

# Confusion matrix visualization
cm = confusion_matrix(y_test, y_pred)
sns.heatmap(cm, annot=True, fmt='d')
plt.show()
```

## Best Practices

### NumPy
- Use vectorized operations instead of loops
- Be aware of data types to avoid overflow
- Use broadcasting for efficient operations
- Prefer `np.random.seed()` for reproducibility

### Pandas
- Use `pd.read_csv()` parameters for efficient loading
- Chain operations for cleaner code
- Use `.copy()` to avoid unintended modifications
- Leverage `.query()` for complex filtering

### Matplotlib
- Use `plt.style.use()` for consistent styling
- Always label axes and add titles
- Use `plt.tight_layout()` for better spacing
- Save figures with `plt.savefig()` for reports

### Seaborn
- Set style at the beginning: `sns.set_style()`
- Use `data=df` parameter for cleaner code
- Combine with matplotlib for fine-tuning
- Use `sns.despine()` for cleaner plots

### Scikit-learn
- Always use `random_state` for reproducibility
- Fit transformers only on training data
- Use pipelines for cleaner workflows
- Cross-validate for reliable performance estimates

## Common Pitfalls

1. **Data Leakage**: Fitting preprocessors on entire dataset
2. **Inconsistent Scaling**: Different scaling for train/test
3. **Memory Issues**: Loading large datasets inefficiently
4. **Plotting Overload**: Too many plots without clear purpose
5. **Ignoring Data Types**: Mixing numeric and categorical data

## Next Steps
- Practice with real datasets
- Learn advanced pandas operations (pivot, merge, join)
- Explore specialized visualization libraries (plotly, bokeh)
- Master scikit-learn pipelines and custom transformers
- Understand when to use each library's strengths