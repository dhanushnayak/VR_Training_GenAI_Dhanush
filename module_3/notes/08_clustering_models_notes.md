# Clustering Models - Notes

## K-Means Clustering

### What is K-Means Clustering?
- **Definition**: Unsupervised algorithm that partitions data into k clusters
- **Goal**: Group similar data points together, separate dissimilar ones
- **Assumption**: Clusters are spherical and similar sized
- **Output**: Cluster assignments and cluster centers (centroids)

### How K-Means Works

#### Algorithm Steps
1. **Initialize**: Choose k initial cluster centers (randomly or using heuristics)
2. **Assign**: Assign each point to nearest cluster center
3. **Update**: Recalculate cluster centers as mean of assigned points
4. **Repeat**: Steps 2-3 until convergence (centers stop moving significantly)

#### Mathematical Foundation
- **Objective**: Minimize Within-Cluster Sum of Squares (WCSS)
- **Formula**: WCSS = Σᵢ Σₓ∈Cᵢ ||x - μᵢ||²
- **Distance Metric**: Typically Euclidean distance
- **Convergence**: When centroids change less than threshold

### Choosing K (Number of Clusters)

#### Elbow Method
- **Process**: Plot WCSS vs number of clusters (k)
- **Pattern**: WCSS decreases as k increases
- **Elbow Point**: Where rate of decrease sharply changes
- **Interpretation**: Optimal k is at the "elbow"
- **Limitation**: Elbow may not be clear

#### Silhouette Score
- **Definition**: Measure of how similar point is to its cluster vs other clusters
- **Formula**: s(i) = (b(i) - a(i)) / max(a(i), b(i))
- **Components**:
  - a(i): Average distance to points in same cluster
  - b(i): Average distance to points in nearest other cluster
- **Range**: [-1, 1], where 1 is best
- **Interpretation**: Higher average silhouette score indicates better clustering

#### Other Methods
- **Gap Statistic**: Compare WCSS to random data
- **Calinski-Harabasz Index**: Ratio of between-cluster to within-cluster variance
- **Davies-Bouldin Index**: Average similarity between clusters
- **Domain Knowledge**: Use business understanding

### Advantages of K-Means
- **Simplicity**: Easy to understand and implement
- **Efficiency**: Fast for large datasets (O(nkt) complexity)
- **Scalability**: Works well with many data points
- **Guaranteed Convergence**: Always converges to local minimum
- **Interpretability**: Clear cluster centers and assignments

### Limitations of K-Means
- **Choose K**: Need to specify number of clusters beforehand
- **Spherical Assumption**: Assumes clusters are spherical and similar sized
- **Sensitive to Initialization**: Different starting points can give different results
- **Sensitive to Outliers**: Outliers can significantly affect centroids
- **Feature Scaling**: Sensitive to feature scales
- **Local Minima**: May converge to suboptimal solution

### Initialization Methods
- **Random**: Randomly select k points as initial centroids
- **K-Means++**: Choose initial centroids to be far from each other
- **Multiple Runs**: Run algorithm multiple times with different initializations

### Applications of K-Means

#### Customer Segmentation
- **Features**: Demographics, purchase behavior, preferences
- **Goal**: Group customers with similar characteristics
- **Use**: Targeted marketing, personalized recommendations
- **Example**: High-value vs budget-conscious customers

#### Image Compression
- **Process**: Cluster pixel colors, replace with cluster centers
- **Benefit**: Reduce number of colors while preserving appearance
- **Trade-off**: Compression ratio vs image quality
- **Application**: Reduce file size, optimize for web

#### Market Research
- **Features**: Survey responses, behavioral data
- **Goal**: Identify market segments
- **Use**: Product development, pricing strategies
- **Example**: Tech-savvy vs traditional user segments

## Hierarchical Clustering

### What is Hierarchical Clustering?
- **Definition**: Creates tree-like hierarchy of clusters
- **Types**: Agglomerative (bottom-up) and Divisive (top-down)
- **Output**: Dendrogram showing cluster relationships
- **Advantage**: Don't need to specify number of clusters beforehand

### Types of Hierarchical Clustering

#### Agglomerative Clustering
- **Process**: Start with each point as separate cluster, merge closest pairs
- **Steps**:
  1. Start with n clusters (one per data point)
  2. Find two closest clusters
  3. Merge them into single cluster
  4. Repeat until one cluster remains
- **Most Common**: Easier to implement and understand

#### Divisive Clustering
- **Process**: Start with all points in one cluster, recursively split
- **Steps**:
  1. Start with all points in one cluster
  2. Split cluster into two subclusters
  3. Recursively split subclusters
  4. Continue until each point is separate cluster
- **Less Common**: More computationally expensive

### Linkage Criteria (Distance Between Clusters)

#### Single Linkage (Minimum)
- **Definition**: Distance between closest points in clusters
- **Formula**: d(A,B) = min{d(a,b) : a∈A, b∈B}
- **Characteristic**: Tends to create elongated clusters
- **Problem**: Chain effect (clusters connected by single points)

#### Complete Linkage (Maximum)
- **Definition**: Distance between farthest points in clusters
- **Formula**: d(A,B) = max{d(a,b) : a∈A, b∈B}
- **Characteristic**: Creates compact, spherical clusters
- **Benefit**: Less sensitive to outliers than single linkage

#### Average Linkage
- **Definition**: Average distance between all pairs of points
- **Formula**: d(A,B) = avg{d(a,b) : a∈A, b∈B}
- **Characteristic**: Compromise between single and complete
- **Benefit**: More robust than single linkage

#### Ward Linkage
- **Definition**: Minimizes within-cluster variance when merging
- **Criterion**: Merge clusters that minimize increase in WCSS
- **Characteristic**: Creates compact, similar-sized clusters
- **Most Popular**: Often gives best results

### Dendrograms
- **Definition**: Tree diagram showing cluster hierarchy
- **Structure**: 
  - Leaves: Individual data points
  - Internal nodes: Cluster merges
  - Height: Distance at which clusters merge
- **Interpretation**: Cut at different heights to get different number of clusters
- **Benefit**: Visualize clustering process and choose optimal number of clusters

### Advantages of Hierarchical Clustering
- **No K Required**: Don't need to specify number of clusters
- **Deterministic**: Same result every time (no random initialization)
- **Hierarchy**: Shows relationships between clusters at different levels
- **Flexible**: Can choose number of clusters after seeing dendrogram
- **Any Distance Metric**: Can use various distance measures

### Limitations of Hierarchical Clustering
- **Computational Complexity**: O(n³) for naive implementation, O(n²) optimized
- **Memory Requirements**: Needs to store distance matrix
- **Sensitive to Noise**: Outliers can affect entire hierarchy
- **Difficult to Handle Large Datasets**: Scalability issues
- **No Global Objective**: Greedy approach may not find optimal solution

### Choosing Number of Clusters
- **Dendrogram Inspection**: Look for natural cut points
- **Gap in Heights**: Large jumps in merge distances
- **Domain Knowledge**: Use business understanding
- **Silhouette Analysis**: Evaluate different numbers of clusters

## Comparison: K-Means vs Hierarchical

### K-Means
**Best For**:
- Large datasets
- Spherical clusters
- Known number of clusters
- Fast results needed

**Limitations**:
- Need to specify k
- Assumes spherical clusters
- Sensitive to initialization

### Hierarchical
**Best For**:
- Small to medium datasets
- Unknown number of clusters
- Need cluster hierarchy
- Irregular cluster shapes

**Limitations**:
- Computationally expensive
- Memory intensive
- Sensitive to noise

## Implementation Examples

### K-Means
```python
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

# Determine optimal k using elbow method
wcss = []
k_range = range(1, 11)
for k in k_range:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X)
    wcss.append(kmeans.inertia_)

# Plot elbow curve
plt.plot(k_range, wcss)
plt.xlabel('Number of Clusters (k)')
plt.ylabel('WCSS')
plt.title('Elbow Method')

# Fit final model
kmeans = KMeans(n_clusters=3, random_state=42)
clusters = kmeans.fit_predict(X)
centroids = kmeans.cluster_centers_
```

### Silhouette Analysis
```python
from sklearn.metrics import silhouette_score, silhouette_samples

# Calculate silhouette scores for different k
silhouette_scores = []
for k in range(2, 11):
    kmeans = KMeans(n_clusters=k, random_state=42)
    clusters = kmeans.fit_predict(X)
    score = silhouette_score(X, clusters)
    silhouette_scores.append(score)

# Find optimal k
optimal_k = k_range[np.argmax(silhouette_scores)]
```

### Hierarchical Clustering
```python
from sklearn.cluster import AgglomerativeClustering
from scipy.cluster.hierarchy import dendrogram, linkage
import matplotlib.pyplot as plt

# Create linkage matrix for dendrogram
linkage_matrix = linkage(X, method='ward')

# Plot dendrogram
plt.figure(figsize=(12, 8))
dendrogram(linkage_matrix)
plt.title('Hierarchical Clustering Dendrogram')
plt.xlabel('Sample Index')
plt.ylabel('Distance')

# Fit hierarchical clustering
hierarchical = AgglomerativeClustering(n_clusters=3, linkage='ward')
clusters = hierarchical.fit_predict(X)
```

## Best Practices

### Data Preprocessing
1. **Feature Scaling**: Standardize features (especially for K-means)
2. **Handle Outliers**: Remove or treat outliers appropriately
3. **Dimensionality Reduction**: Consider PCA for high-dimensional data
4. **Missing Values**: Handle missing data before clustering

### Model Selection
1. **Try Multiple Methods**: Compare K-means and hierarchical
2. **Validate Results**: Use multiple evaluation metrics
3. **Domain Knowledge**: Incorporate business understanding
4. **Stability**: Check if results are consistent across runs

### Evaluation
1. **Internal Metrics**: Silhouette score, Calinski-Harabasz index
2. **External Metrics**: If ground truth available (Adjusted Rand Index)
3. **Visual Inspection**: Plot clusters in 2D/3D space
4. **Business Validation**: Do clusters make business sense?

## Common Applications

### Business
- **Customer Segmentation**: Group customers for targeted marketing
- **Product Categorization**: Organize products into categories
- **Market Segmentation**: Identify market niches

### Technology
- **Image Segmentation**: Separate regions in images
- **Anomaly Detection**: Identify outliers as small clusters
- **Recommendation Systems**: Group users or items

### Science
- **Gene Expression**: Group genes with similar expression patterns
- **Species Classification**: Group organisms by characteristics
- **Climate Analysis**: Identify climate zones

### Social Sciences
- **Survey Analysis**: Group respondents by attitudes
- **Social Network Analysis**: Identify communities
- **Demographic Studies**: Group populations by characteristics

## Evaluation Metrics

### Internal Metrics (No Ground Truth)
- **Silhouette Score**: How well-separated clusters are
- **Calinski-Harabasz Index**: Ratio of between/within cluster variance
- **Davies-Bouldin Index**: Average similarity between clusters
- **Inertia/WCSS**: Within-cluster sum of squares

### External Metrics (With Ground Truth)
- **Adjusted Rand Index**: Similarity to true clustering
- **Normalized Mutual Information**: Information shared with true labels
- **Homogeneity**: Each cluster contains only one class
- **Completeness**: All members of class in same cluster

## Summary

### Key Concepts
1. **K-Means**: Fast, requires k, assumes spherical clusters
2. **Hierarchical**: No k needed, shows hierarchy, computationally expensive
3. **Choosing K**: Use elbow method, silhouette analysis, domain knowledge
4. **Evaluation**: Multiple metrics, visual inspection, business validation

### Best Practices
- Preprocess data appropriately (scaling, outliers)
- Try multiple algorithms and parameters
- Validate results using multiple approaches
- Consider business context and interpretability

### Next Steps
- Practice with different datasets
- Learn advanced clustering methods (DBSCAN, Gaussian Mixture Models)
- Explore dimensionality reduction techniques
- Study cluster validation and interpretation methods