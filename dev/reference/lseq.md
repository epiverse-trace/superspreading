# Generates a log scaled sequence of real numbers

Generates a log scaled sequence of real numbers

## Usage

``` r
lseq(from, to, length.out)
```

## Arguments

- from, to:

  the starting and (maximal) end values of the sequence. Of length `1`
  unless just `from` is supplied as an unnamed argument.

- length.out:

  desired length of the sequence. A non-negative number, which for `seq`
  and `seq.int` will be rounded up if fractional.

## Value

`seq.int` and the default method of `seq` for numeric arguments return a
vector of type `"integer"` or `"double"`: programmers should not rely on
which.

`seq_along` and `seq_len` return an integer vector, unless it is a
*[long vector](https://rdrr.io/r/base/LongVectors.html)* when it will be
double.
