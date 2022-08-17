# CPS, Interval-based compression
This repository contains MATLAB R2022a (9.12.0.1884302, maci64 bit, February 16 2022) implementation of CPS, a lossless compression technique for point cloud sequences.  In addition, it includes the rose point cloud sequence consisting of 115 point clouds with each cloud consisting of 65K points.  

Author:  Shahram Ghandeharizadeh (shahram@usc.edu)

# Features

  * CPS algorithm.
  * Rose point cloud sequence data set consisting of 115 point clouds.
  * The algorithms are detailed in a technical manuscript submitted for publication.

# Documentation

This section provides an overview of CPS and describes how to run CPS to generate the results presented in the submitted paper.

## CPS
CPS is a lossless Compression technique for Point cloud Sequences.  
Its main contribution is the concept of a
lossless point which wraps the traditional definition of a point
with an interval attribute, e.g., start and end times that describe
when and for how long a point is displayed. CPS consumes n point
clouds in a sequence to produce one compressed file.

# Executing this Software
The best way to run CPS is to download this repository into a directoy, launch matlab from the directory and execute the following command:
```
[cpa, ptChgs, colorChgs] = workflowLossless(3);
```
The value 3 is the number of PLY files in the RoseClip directory to compress using CPS.  The RoseClip directory has 115 PLY files.  Hence, the maximum value that can be used as the input argument to workflowLossless is 115.

The output of the above command are the cloud points (cpa), the changed points, and changed colors.  In addition, workflowLossless creates a csp file, losslessPLY_3.cps, that contains the compressed version of the first 3 PLY files of the RoseClip point cloud sequence.

The submitted paper describes the size of CPS compressed file with 3, 5, 10, 20, and 100 PLY files.  It is trivial to run these experiments by changing the argument of workflowLossless to be the appropriate value.


# Limitations
1. With a compressed file, say losslessPLY_3.cps, once it is compressed, it produces 3 PLY files.  These files are logically equivalent to the original because they are duplicate free.  A short term research direction is to maintain sufficient metadata in the compressed file to produce the original files.
2. We plan to provide a C (C++) implementation to improve the speed of this implementation.

# Getting the Source
Clone the repository using:
```
git clone git@github.com:shahramg/CPS.git
```

# Citations
TBA

```
