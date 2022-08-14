# SpectrogramRecipes

Recipes for plotting spectrogram data.

# Description

`SpectrogramRecipes` provide the plotting functions `spectrogram` and
`spectrogram!` for plotting spectrogram data.  These functions are very similar
to `heatmap` and `heatmap!`, but they provide some additional conveniences
tailored to spectrogram data.

- Integration with `AxisArrays`
- Works with `Unitful` values for the `AxisArray` axes (requires `UnitfulRecipes`)
- Plot attribute `wf` (short for for *waterfall*) to transpose data to be plotted

# Spectrograms

A spectrogram is a visualization of two dimensional data.  One dimension is
*spectral*, spanning frequency or wavelength.  The other dimension is some other
quantity over which the spectral data varies (e.g. time, drift rate, dispersion
measure, etc.).  As with the `heatmap` function, the values in the
`AbstractMatrix` spectrogram (typically power or intensity) are plotted in
differing colors.

# Data ordering

`SpectrogramRecipes` generally assume that the first (i.e. fastest changing)
axis of the spectrogram data is the spectral dimension and the second dimension
is the non-spectral dimension.  The exception to this occurs when the
spectrogram data is in an `AxisArray` (see below).

# AxisArrays

When `spectrogram` or `spectrogram` is passed a single `AxisArray`, the axes
from the `AxisArray` are used to specify the `x` and `y` values for the plot.
If the spectrogram data is an `AxisArray` with an axis whose name is recognized
as a spectral name then that axis is taken as the spectral axis.  Currently,
recognized spectral names are:

- `:frequency`
- `:freq`
- `:wavelength`
- `:wl`

If an `AxisArray` has an axis with a recognized spectral name, that axis is
treated as the spectral axis.  Otherwise the default data ordering described
above applies.

# Unitful axes

`SpectrogramRecipes` does not depend on `Unitful`, but you can still plot
spectrogram data that is in an `AxisArray` containing `Unitful` quantities so
long as you import `UnitfulRecipes` in addition to `SpectrogramRecipes`.

Currently no checks are done to ensure that the units of the spectral axis
are appropriate for a spectral quantity (e.g. frequency or wavelength).

# Plot orientation

Spectrograms default to plotting with the spectral axis being vertical with
values ascending upward.  If you want to have the spectral axis being vertical
with values descending upward, pass `yflip=true` as a keyword argument to
`spectrogram` or `spectrogram!`.

To display the histogram with the spectral axis on the horizontal, pass
`wf=true` as a keyword argument to `spectrogram` or `spectrogram!`.  `wf` is
short for *waterfall*, which is a term often used to describe plots displaying
spectrogram data in this orientation.  When `wf=true` is passed, the
non-spectral axis will be plotting vertically with values ascending downward.
To have these values descend downward along the vertical axis, pass
`yflip=false`.