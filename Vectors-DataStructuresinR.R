#----Vectors----
# A vector is a one-dimensional array. 
# We can create a vector with all the basic data type
# The simplest way to build a vector is to use the c command.

# Creating a Numerical Vector:
vec_num <- c(1, 10, 49)
vec_num
# Creating a Character Vector:
vec_chr <- c("a", "b", "c")
vec_chr
# Creating a Boolean Vector
vec_bool <-  c(TRUE, FALSE, TRUE)
vec_bool

# Arithmetic calculations on vectors:
# Create the vectors
vect_1 <- c(1, 3, 5)
vect_2 <- c(2, 4, 6)
# Take the sum of A_vector and B_vector
sum_vect <- vect_1 + vect_2
# Print out total_vector
sum_vect

# Slicing Vector:Slice the first five rows of the vector
slice_vector <- c(1,2,3,4,5,6,7,8,9,10)
slice_vector[1:5]

# Faster way to create a vector with adjacent values is:
c(1:10)

# Applying Logical Operators on Vectors:

# Create a vector from 1 to 10
logical_vector <- c(1:10)
logical_vector>5
# Print value strictly above 5
logical_vector[(logical_vector>5)]
# Print 5 and 6
logical_vector <- c(1:10)
logical_vector[(logical_vector>4) & (logical_vector<7)]

