# Deep Learning Frameworks - Notes

## Introduction to TensorFlow

### What is TensorFlow?
- **Definition**: Open-source machine learning framework developed by Google
- **Purpose**: Build and deploy machine learning models at scale
- **Key Features**:
  - Automatic differentiation
  - GPU/TPU acceleration
  - Production deployment tools
  - Large ecosystem of tools

### Core Concepts

#### Tensors
- **Definition**: Multi-dimensional arrays (generalization of matrices)
- **Ranks**:
  - Rank 0: Scalar (single number)
  - Rank 1: Vector (1D array)
  - Rank 2: Matrix (2D array)
  - Rank 3+: Higher-dimensional arrays
- **Properties**:
  - Shape: Dimensions of tensor
  - Data type: int32, float32, bool, etc.
  - Device: CPU, GPU, TPU

#### Computational Graphs
- **Definition**: Network of operations connected by tensors
- **Benefits**:
  - Optimization opportunities
  - Parallel execution
  - Automatic differentiation
  - Device placement

#### Eager Execution
- **Definition**: Operations execute immediately (like NumPy)
- **Benefits**:
  - Easier debugging
  - More intuitive
  - Dynamic control flow
- **Default**: Enabled by default in TensorFlow 2.x

### TensorFlow Ecosystem
- **TensorFlow Core**: Main library
- **Keras**: High-level API (integrated into TensorFlow)
- **TensorBoard**: Visualization tool
- **TensorFlow Serving**: Model deployment
- **TensorFlow Lite**: Mobile/embedded deployment
- **TensorFlow.js**: Browser/Node.js deployment

### Basic Operations
```python
import tensorflow as tf

# Create tensors
scalar = tf.constant(5)
vector = tf.constant([1, 2, 3])
matrix = tf.constant([[1, 2], [3, 4]])

# Operations
result = tf.add(matrix, matrix)
product = tf.matmul(matrix, matrix)
```

## Keras Overview

### What is Keras?
- **Definition**: High-level neural networks API
- **Philosophy**: User-friendly, modular, extensible
- **Integration**: Built into TensorFlow 2.x as tf.keras
- **Benefits**:
  - Rapid prototyping
  - Consistent API
  - Multiple backends support

### Keras Components
- **Models**: Ways to organize layers
- **Layers**: Building blocks of neural networks
- **Optimizers**: Algorithms for training
- **Loss Functions**: Objectives to minimize
- **Metrics**: Measures of performance

## Sequential API

### When to Use Sequential API
- **Linear Stack**: Layers connected sequentially
- **Simple Models**: Most common architectures
- **Single Input/Output**: One input tensor, one output tensor
- **Examples**: Basic feedforward networks, simple CNNs/RNNs

### Building Sequential Models

#### Method 1: List of Layers
```python
from tensorflow.keras import Sequential, layers

model = Sequential([
    layers.Dense(64, activation='relu', input_shape=(10,)),
    layers.Dropout(0.3),
    layers.Dense(32, activation='relu'),
    layers.Dense(1, activation='sigmoid')
])
```

#### Method 2: Add Layers Incrementally
```python
model = Sequential()
model.add(layers.Dense(64, activation='relu', input_shape=(10,)))
model.add(layers.Dropout(0.3))
model.add(layers.Dense(32, activation='relu'))
model.add(layers.Dense(1, activation='sigmoid'))
```

### Common Layers
- **Dense**: Fully connected layer
- **Dropout**: Regularization layer
- **Conv2D**: 2D convolutional layer
- **MaxPooling2D**: Max pooling layer
- **LSTM**: Long Short-Term Memory layer
- **Embedding**: Embedding layer for categorical data

### Model Compilation
```python
model.compile(
    optimizer='adam',           # Optimization algorithm
    loss='binary_crossentropy', # Loss function
    metrics=['accuracy']        # Metrics to track
)
```

### Training
```python
history = model.fit(
    X_train, y_train,
    epochs=50,
    batch_size=32,
    validation_split=0.2,
    verbose=1
)
```

### Evaluation and Prediction
```python
# Evaluate on test set
test_loss, test_accuracy = model.evaluate(X_test, y_test)

# Make predictions
predictions = model.predict(X_new)
```

## Functional API

### When to Use Functional API
- **Complex Architectures**: Non-linear topology
- **Multiple Inputs/Outputs**: Different data sources/targets
- **Shared Layers**: Reuse layers across different paths
- **Advanced Models**: ResNet, Inception, U-Net, etc.

### Building Functional Models

#### Basic Example
```python
from tensorflow.keras import Input, Model, layers

# Define input
inputs = Input(shape=(10,))

# Define layers
x = layers.Dense(64, activation='relu')(inputs)
x = layers.Dropout(0.3)(x)
x = layers.Dense(32, activation='relu')(x)
outputs = layers.Dense(1, activation='sigmoid')(x)

# Create model
model = Model(inputs=inputs, outputs=outputs)
```

#### Multi-Input Example
```python
# Multiple inputs
input1 = Input(shape=(10,), name='numerical')
input2 = Input(shape=(5,), name='categorical')

# Process each input
branch1 = layers.Dense(32, activation='relu')(input1)
branch2 = layers.Dense(16, activation='relu')(input2)

# Combine branches
combined = layers.concatenate([branch1, branch2])
output = layers.Dense(1, activation='sigmoid')(combined)

# Create model
model = Model(inputs=[input1, input2], outputs=output)
```

#### Multi-Output Example
```python
inputs = Input(shape=(10,))
shared = layers.Dense(64, activation='relu')(inputs)

# Multiple outputs
output1 = layers.Dense(1, activation='sigmoid', name='binary')(shared)
output2 = layers.Dense(3, activation='softmax', name='multiclass')(shared)

model = Model(inputs=inputs, outputs=[output1, output2])

# Compile with multiple losses
model.compile(
    optimizer='adam',
    loss={'binary': 'binary_crossentropy', 'multiclass': 'categorical_crossentropy'},
    metrics={'binary': 'accuracy', 'multiclass': 'accuracy'}
)
```

### Advanced Patterns

#### Shared Layers
```python
# Shared embedding layer
shared_embedding = layers.Embedding(1000, 64)

input1 = Input(shape=(10,))
input2 = Input(shape=(10,))

# Use same embedding for both inputs
embedded1 = shared_embedding(input1)
embedded2 = shared_embedding(input2)
```

#### Residual Connections
```python
inputs = Input(shape=(32,))
x = layers.Dense(32, activation='relu')(inputs)
x = layers.Dense(32, activation='relu')(x)

# Residual connection
outputs = layers.add([inputs, x])  # Skip connection
```

## Model Training and Evaluation

### Compilation Options

#### Optimizers
- **SGD**: Stochastic Gradient Descent
- **Adam**: Adaptive Moment Estimation (most common)
- **RMSprop**: Root Mean Square Propagation
- **Adagrad**: Adaptive Gradient Algorithm

#### Loss Functions
- **Regression**: 'mse', 'mae', 'huber'
- **Binary Classification**: 'binary_crossentropy'
- **Multi-class**: 'categorical_crossentropy', 'sparse_categorical_crossentropy'

#### Metrics
- **Classification**: 'accuracy', 'precision', 'recall', 'f1_score'
- **Regression**: 'mae', 'mse', 'r2_score'

### Training Process
```python
# Fit model
history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=32,
    validation_data=(X_val, y_val),
    callbacks=[early_stopping, model_checkpoint]
)
```

### Callbacks
- **EarlyStopping**: Stop training when validation loss stops improving
- **ModelCheckpoint**: Save best model during training
- **ReduceLROnPlateau**: Reduce learning rate when stuck
- **TensorBoard**: Log metrics for visualization

```python
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

callbacks = [
    EarlyStopping(patience=10, restore_best_weights=True),
    ModelCheckpoint('best_model.h5', save_best_only=True)
]
```

## Best Practices

### Model Architecture
1. **Start Simple**: Begin with simple architecture, add complexity gradually
2. **Regularization**: Use dropout, batch normalization to prevent overfitting
3. **Activation Functions**: ReLU for hidden layers, appropriate output activation
4. **Layer Sizes**: Generally decrease size in deeper layers

### Training
1. **Data Preprocessing**: Normalize inputs, handle categorical variables
2. **Batch Size**: Start with 32, adjust based on memory and performance
3. **Learning Rate**: Start with default (0.001 for Adam), tune if needed
4. **Validation**: Always use validation set to monitor overfitting

### Debugging
1. **Start Small**: Test with small dataset first
2. **Check Shapes**: Ensure tensor dimensions match
3. **Monitor Training**: Watch loss curves for signs of problems
4. **Gradual Complexity**: Add features one at a time

### Performance Optimization
1. **GPU Utilization**: Use tf.data for efficient data loading
2. **Mixed Precision**: Use float16 for faster training
3. **Batch Processing**: Process multiple samples simultaneously
4. **Model Optimization**: Use TensorFlow Lite for deployment

## Common Patterns and Examples

### Image Classification (CNN)
```python
model = Sequential([
    layers.Conv2D(32, 3, activation='relu', input_shape=(28, 28, 1)),
    layers.MaxPooling2D(),
    layers.Conv2D(64, 3, activation='relu'),
    layers.MaxPooling2D(),
    layers.Flatten(),
    layers.Dense(64, activation='relu'),
    layers.Dense(10, activation='softmax')
])
```

### Text Classification (RNN)
```python
model = Sequential([
    layers.Embedding(vocab_size, 64),
    layers.LSTM(64),
    layers.Dense(32, activation='relu'),
    layers.Dense(1, activation='sigmoid')
])
```

### Regression
```python
model = Sequential([
    layers.Dense(64, activation='relu', input_shape=(features,)),
    layers.Dropout(0.3),
    layers.Dense(32, activation='relu'),
    layers.Dense(1)  # No activation for regression
])
```

## Comparison: Sequential vs Functional API

### Sequential API
**Pros**:
- Simple and intuitive
- Less code for simple models
- Good for beginners
- Clear linear flow

**Cons**:
- Limited to linear stack
- No multiple inputs/outputs
- No shared layers
- Less flexible

### Functional API
**Pros**:
- Maximum flexibility
- Multiple inputs/outputs
- Shared layers
- Complex architectures
- Better for advanced users

**Cons**:
- More verbose
- Steeper learning curve
- Can be overkill for simple models

### When to Use Each
- **Sequential**: Simple feedforward networks, prototyping, learning
- **Functional**: Complex architectures, multiple inputs/outputs, production models

## Summary

### Key Concepts
1. **TensorFlow**: Comprehensive ML framework with automatic differentiation
2. **Keras**: High-level API for building neural networks
3. **Sequential API**: Simple, linear models
4. **Functional API**: Complex, flexible architectures

### Workflow
1. **Define Architecture**: Choose Sequential or Functional API
2. **Compile Model**: Set optimizer, loss, metrics
3. **Train Model**: Fit to training data with validation
4. **Evaluate**: Test performance on unseen data
5. **Deploy**: Use TensorFlow Serving or other deployment tools

### Next Steps
- Practice building different architectures
- Learn about specific layer types (CNN, RNN, attention)
- Explore advanced topics (custom layers, training loops)
- Study state-of-the-art architectures (ResNet, Transformer)
- Learn deployment strategies for production use