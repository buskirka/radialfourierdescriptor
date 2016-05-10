# Radial Fourier Descriptor

A collection of Octave code designed to extract a descriptor for 
identifying structures in satellite imagery using support vector machines.

To discuss how to utilize this code, we must introduce a few terms.
## Bin Configuration
A bin configuration is a 2x*N* matrix of nonnegative floating point values,
increasing in each column. Such an object is here generally interpreted as a collection
of *N* intervals.
