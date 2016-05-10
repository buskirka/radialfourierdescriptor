# Radial Fourier Descriptor

A collection of Octave code designed to extract a descriptor for 
identifying structures in satellite imagery using support vector machines.

To discuss how to utilize this code, we must introduce a few terms.
## Basics
### Landsat 8 data
We communicate Landsat 8 data in Octave by storing its 11 bands as a 1x11
cell array whose cells are each grayscale matrices depicting the data.

This may be extracted from Landsat 8 data using the `loadL8data` command
provided.
### Bin Matrix
A bin matrix is a 2x*N* matrix of nonnegative floating point values,
increasing in each column. Such an object is here generally interpreted as a collection
of *N* intervals.
### Bin Configuration
A bin configuration is a `struct` object containing properties `rbins`, `sines`,
`costs`, and `bands`. It must correspond to some format of data; in our case,
the 11 bands of Landsat 8 data.

`rbins` will be a cell array (the size of the Landsat data) of bin matrices, 
as described above. Each of these describes the collection of annuloid sectors on
which the Fourier transform will be calculated on their respective layers.

`sines` is a matrix with dimensions equal to the Landsat 8 data, which describes the 
number of sines which should be extracted from the Landsat 8 data. Each entry should
be an integer greater than 2.

`costs` should be a 1x2 matrix; the two components indicate cost parameters utilized 
in LIBSVM's `svmtrain` for the two training classes.
