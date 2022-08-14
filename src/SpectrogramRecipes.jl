module SpectrogramRecipes

using AxisArrays
using RecipesBase

const SPECTRAL_NAMES = (:frequency, :freq, :wavelength, :wl)

@userplot struct Spectrogram{T<:AxisArray}
    args::T
end

@recipe function f(s::Spectrogram; wf=false)
    # TODO Throw exception if passed more than 3 args
    if length(s.args) > 2
        x, y, z... = s.args
    elseif length(s.args) == 2
        x = 1:1
        y, z... = s.args
    else
        z = s.args[1]
        if typeof(z) <: AxisArray
            axnames = axisnames(z)
            # if waterfall and input not permuted
            # or !waterfall and input is permuted
            if (wf && axnames[1] ∈ SPECTRAL_NAMES && axnames[2] ∉ SPECTRAL_NAMES ||
               !wf && axnames[1] ∉ SPECTRAL_NAMES && axnames[2] ∈ SPECTRAL_NAMES)
                # Permute z
                z = permutedims(z)
            end
            y = AxisArrays.axes(z, 1).val
            x = AxisArrays.axes(z, 2).val
            z = (z,)
        else
            if wf
                z = permutedims(z)
            end
            y, x = Base.axes(z)
            z = (z,)
        end
    end

    seriestype := :heatmap
    yflip --> wf
    (x, y, z...)
end

end # module SpectrogramRecipes
