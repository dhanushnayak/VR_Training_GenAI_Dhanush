# Mathematics for Machine Learning - Notes

## Calculus for ML

### Derivatives
- **Definition**: Rate of change of a function with respect to its input
- **Notation**: f'(x) or df/dx
- **Geometric Interpretation**: Slope of the tangent line at a point
- **ML Application**: Finding optimal parameters by minimizing cost functions

#### Key Rules
- **Power Rule**: d/dx(x^n) = nx^(n-1)
- **Product Rule**: d/dx(uv) = u'v + uv'
- **Chain Rule**: d/dx(f(g(x))) = f'(g(x)) × g'(x)

#### ML Applications
- **Optimization**: Find minimum/maximum of cost functions
- **Gradient Descent**: Use derivatives to update parameters
- **Backpropagation**: Chain rule for neural network training

### Partial Derivatives
- **Definition**: Derivative with respect to one variable, holding others constant
- **Notation**: ∂f/∂x
- **ML Application**: Gradients in multivariable optimization

#### Example
For f(x,y) = x² + y² + 2xy:
- ∂f/∂x = 2x + 2y
- ∂f/∂y = 2y + 2x

### Gradients
- **Definition**: Vector of all partial derivatives
- **Notation**: ∇f = [∂f/∂x₁, ∂f/∂x₂, ..., ∂f/∂xₙ]
- **Properties**:
  - Points in direction of steepest ascent
  - Magnitude indicates rate of change
  - Perpendicular to level curves

#### ML Applications
- **Gradient Descent**: Move in negative gradient direction
- **Feature Importance**: Magnitude of gradients
- **Neural Networks**: Backpropagation uses gradients

## Linear Algebra for ML

### Scalars, Vectors, and Matrices

#### Scalars
- Single numbers (e.g., 5, -2.3, π)
- Represent individual measurements or parameters

#### Vectors
- **Definition**: Ordered list of numbers
- **Notation**: **v** = [v₁, v₂, ..., vₙ]
- **ML Applications**:
  - Represent data points (feature vectors)
  - Model parameters
  - Predictions

#### Matrices
- **Definition**: 2D array of numbers
- **Notation**: **A** = [aᵢⱼ] where i=row, j=column
- **ML Applications**:
  - Represent datasets (rows=samples, columns=features)
  - Linear transformations
  - Neural network weights

### Vector Operations

#### Addition and Subtraction
- Element-wise operations
- **v** + **w** = [v₁+w₁, v₂+w₂, ..., vₙ+wₙ]

#### Scalar Multiplication
- Multiply each element by scalar
- c**v** = [cv₁, cv₂, ..., cvₙ]

#### Dot Product
- **Definition**: **v** · **w** = v₁w₁ + v₂w₂ + ... + vₙwₙ
- **Properties**:
  - Commutative: **v** · **w** = **w** · **v**
  - Measures similarity between vectors
  - Zero when vectors are orthogonal

#### Vector Norm (Magnitude)
- **L2 Norm**: ||**v**||₂ = √(v₁² + v₂² + ... + vₙ²)
- **L1 Norm**: ||**v**||₁ = |v₁| + |v₂| + ... + |vₙ|
- **ML Applications**: Regularization, distance metrics

### Matrix Operations

#### Matrix Addition
- Element-wise addition of matrices with same dimensions
- **A** + **B** = [aᵢⱼ + bᵢⱼ]

#### Matrix Multiplication
- **Definition**: (**AB**)ᵢⱼ = Σₖ aᵢₖbₖⱼ
- **Requirements**: Columns of A = Rows of B
- **Properties**:
  - Not commutative: AB ≠ BA (generally)
  - Associative: (AB)C = A(BC)

#### Matrix Transpose
- **Definition**: **A**ᵀ where (Aᵀ)ᵢⱼ = aⱼᵢ
- **Properties**: (AB)ᵀ = BᵀAᵀ

#### Matrix Inverse
- **Definition**: A⁻¹ such that AA⁻¹ = I
- **Requirements**: Square matrix, non-zero determinant
- **ML Application**: Analytical solutions (e.g., linear regression)

### Vector Spaces
- **Definition**: Set of vectors with addition and scalar multiplication
- **Properties**:
  - Closure under addition and scalar multiplication
  - Contains zero vector
  - Every vector has additive inverse

#### Basis and Dimension
- **Basis**: Set of linearly independent vectors that span the space
- **Dimension**: Number of vectors in basis
- **ML Application**: Feature spaces, dimensionality reduction

### ML Applications of Linear Algebra

#### Linear Regression
- **Matrix Form**: y = Xβ + ε
- **Solution**: β = (XᵀX)⁻¹Xᵀy
- **Components**:
  - X: Design matrix (features)
  - β: Parameter vector
  - y: Target vector

#### Principal Component Analysis (PCA)
- **Goal**: Find directions of maximum variance
- **Method**: Eigenvalue decomposition of covariance matrix
- **Applications**: Dimensionality reduction, data visualization

#### Neural Networks
- **Forward Pass**: Linear transformations followed by nonlinearities
- **Weight Matrices**: Store learned parameters
- **Batch Processing**: Matrix operations for efficiency

## Probability and Statistics

### Basic Probability

#### Probability Rules
- **Range**: 0 ≤ P(A) ≤ 1
- **Complement**: P(Aᶜ) = 1 - P(A)
- **Addition**: P(A ∪ B) = P(A) + P(B) - P(A ∩ B)
- **Multiplication**: P(A ∩ B) = P(A|B) × P(B)

#### Conditional Probability
- **Definition**: P(A|B) = P(A ∩ B) / P(B)
- **Independence**: P(A|B) = P(A) if A and B are independent

### Probability Distributions

#### Discrete Distributions
- **Bernoulli**: Single trial with two outcomes
  - P(X = 1) = p, P(X = 0) = 1-p
  - Applications: Binary classification
- **Binomial**: Number of successes in n trials
  - P(X = k) = C(n,k) × p^k × (1-p)^(n-k)
- **Poisson**: Number of events in fixed interval
  - P(X = k) = (λ^k × e^(-λ)) / k!

#### Continuous Distributions
- **Normal (Gaussian)**: Bell-shaped curve
  - PDF: f(x) = (1/√(2πσ²)) × e^(-(x-μ)²/(2σ²))
  - Parameters: μ (mean), σ² (variance)
  - Applications: Many ML algorithms assume normality
- **Uniform**: Equal probability over interval
- **Exponential**: Time between events

### Expectation and Variance

#### Expectation (Mean)
- **Discrete**: E[X] = Σ x × P(X = x)
- **Continuous**: E[X] = ∫ x × f(x) dx
- **Properties**:
  - Linearity: E[aX + b] = aE[X] + b
  - E[X + Y] = E[X] + E[Y]

#### Variance
- **Definition**: Var(X) = E[(X - μ)²] = E[X²] - (E[X])²
- **Standard Deviation**: σ = √Var(X)
- **Properties**:
  - Var(aX + b) = a²Var(X)
  - For independent X, Y: Var(X + Y) = Var(X) + Var(Y)

### Bayes' Theorem
- **Formula**: P(A|B) = P(B|A) × P(A) / P(B)
- **Components**:
  - P(A|B): Posterior probability
  - P(B|A): Likelihood
  - P(A): Prior probability
  - P(B): Evidence (marginal probability)

#### ML Applications
- **Naive Bayes**: Classification using Bayes' theorem
- **Bayesian Inference**: Update beliefs with new data
- **Medical Diagnosis**: Update disease probability with test results

### Central Limit Theorem
- **Statement**: Sample means approach normal distribution as sample size increases
- **Implications**:
  - Many statistical tests assume normality
  - Justifies use of normal distribution in many contexts
  - Foundation for confidence intervals

## Optimization

### Cost Functions
- **Purpose**: Measure how well model fits data
- **Goal**: Minimize cost to find optimal parameters
- **Common Types**:
  - Mean Squared Error (MSE): (1/n)Σ(yᵢ - ŷᵢ)²
  - Cross-entropy: -Σ yᵢ log(ŷᵢ)
  - Hinge loss: max(0, 1 - yᵢŷᵢ)

### Gradient Descent
- **Idea**: Move in direction of steepest descent
- **Algorithm**:
  1. Initialize parameters θ
  2. Compute gradient ∇J(θ)
  3. Update: θ = θ - α∇J(θ)
  4. Repeat until convergence

#### Learning Rate (α)
- **Too Small**: Slow convergence
- **Too Large**: May overshoot minimum, diverge
- **Adaptive**: Adjust learning rate during training

#### Variants
- **Batch Gradient Descent**: Use entire dataset
- **Stochastic Gradient Descent (SGD)**: Use single sample
- **Mini-batch**: Use small subset of data
- **Adam**: Adaptive learning rates with momentum

### Convex Optimization
- **Convex Function**: Any local minimum is global minimum
- **Properties**:
  - Single global minimum
  - Gradient descent guaranteed to converge
- **Examples**: Linear regression, logistic regression (with convex regularization)

### Non-convex Optimization
- **Challenges**: Multiple local minima
- **Neural Networks**: Typically non-convex
- **Solutions**:
  - Random initialization
  - Multiple restarts
  - Advanced optimizers (Adam, RMSprop)

## Mathematical Foundations Summary

### Why Mathematics Matters in ML
1. **Optimization**: Find best model parameters
2. **Probability**: Handle uncertainty and make predictions
3. **Linear Algebra**: Efficient computation with matrices
4. **Calculus**: Understand how changes affect outcomes

### Key Concepts for ML Success
1. **Derivatives**: Understand how functions change
2. **Matrix Operations**: Efficient data manipulation
3. **Probability Distributions**: Model uncertainty
4. **Optimization**: Find optimal solutions

### Practical Applications
- **Linear Models**: Use linear algebra for closed-form solutions
- **Neural Networks**: Apply calculus for backpropagation
- **Probabilistic Models**: Use Bayes' theorem for inference
- **Optimization**: Apply gradient descent for parameter learning

### Common Mathematical Mistakes in ML
1. **Dimension Mismatch**: Matrix multiplication errors
2. **Numerical Instability**: Division by zero, overflow
3. **Probability Violations**: Probabilities outside [0,1]
4. **Optimization Issues**: Poor learning rate choice

### Next Steps
- Practice implementing algorithms from scratch
- Understand mathematical foundations of specific ML algorithms
- Learn advanced topics: information theory, measure theory
- Apply mathematical concepts to real ML problems