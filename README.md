# SpectrogramRecipes

Recipes for plotting spectrogram data stored in an `AxisArray`.

# Description

`SpectrogramRecipes` provide the plotting functions `spectrogram` and
`spectrogram!` for plotting spectrogram data stored in an `AxisArray`.  These
functions are very similar to `heatmap` and `heatmap!`, but they provide some
additional conveniences tailored to spectrogram data.

- Axes ticks are taken from `AxisArray` in axis order
- Works with `Unitful` values for the `AxisArray` axes (requires `UnitfulRecipes`)
- Plot attribute `wf` (short for for *waterfall*) to transpose data to be plotted
- Plot attributes `xticks` and `yticks` specify number of tick marks per axis

# Spectrograms

A spectrogram is a visualization of two dimensional data.  One dimension is
*spectral*, spanning frequency or wavelength.  The other dimension is some other
quantity over which the spectral data varies (e.g. time, drift rate, dispersion
measure, etc.).  As with the `heatmap` function, the values in the
`AbstractMatrix` spectrogram (typically power or intensity) are plotted in
differing colors.

# Data ordering

If the `AxisArray` being plotted has an axis whose name is recognized as a
spectral name, the corresponding dimension is used as the spectral axis.
Otherwise, the first (i.e. fastest changing) axis of the spectrogram data is the
spectral dimension and the second dimension is the non-spectral dimension.

Currently, recognized spectral names are:

- `:frequency`
- `:freq`
- `:wavelength`
- `:wl`

# Tick marks

The `xticks` and `yticks` keyword parameters can be used to specify the number
of ticks along the corresponding axis.  Both of these keyword parameters default
to 2.  The ticks are evenly spaced across the span of the axis and are labeled
using values from the corresponding `AxisArray` axis, interpolated as necessary
if the evenly spaced tick mark falls between two axis values.  By default, the
tick values are rounded to six digits after the decimal point.  To round to a
different number of digits, pass a tuple to `xticks` or `yticks` consisting of
`(nticks, ndigits)`.

# Unitful axes

`SpectrogramRecipes` does not depend on `Unitful`, but plotting spectrogram data
that is in an `AxisArray` whose axes contain `Unitful` quantities is supported
(and recommended!) so long as you import `UnitfulRecipes` in addition to
`SpectrogramRecipes`.

Currently no checks are done to ensure that the units of the spectral axis
are appropriate for a spectral quantity (e.g. frequency or wavelength).

# Plot orientation

Spectrograms default to plotting with the spectral axis being vertical with
data elements plotted bottom to top and the data elements from the other axis
being plotted left to right.

To display the histogram with the spectral axis on the horizontal, pass
`wf=true` as a keyword argument to `spectrogram` or `spectrogram!`.  `wf` is
short for *waterfall*, which is a term often used to describe plots displaying
spectrogram data in this orientation.  When `wf=true` is passed, the
non-spectral axis will be plotting vertically from top to bottom.

The `xflip` and `yflip` keywords can be used to "flip" that axis of the plot.