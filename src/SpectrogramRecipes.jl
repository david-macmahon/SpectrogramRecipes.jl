module SpectrogramRecipes

using AxisArrays
using RecipesBase

function interp(v, i::Real)
    lo = v[floor(Int, i)]
    hi = v[ceil(Int, i)]
    f = mod(i, 1)
    lo + f*(hi-lo)
end

function interp(v, ii::AbstractVector{<:Real})
    interp.(Ref(v), ii)
end

const SPECTRAL_NAMES = (:frequency, :freq, :wavelength, :wl)

@userplot struct Spectrogram{T<:Tuple{AxisArray}}
    args::T
end

@recipe function f(s::Spectrogram; wf=false, xticks=2, yticks=2)
    z = first(s.args)
    @assert ndims(z) == 2 "spectrogram requires 2-dimensional data"

    if xticks isa Union{Tuple, AbstractVector}
        xticks, xdigits = Int.(xticks)
    else
        xticks, xdigits = Int(xticks), 6
    end

    if yticks isa Union{Tuple, AbstractVector}
        yticks, ydigits = Int.(yticks)
    else
        yticks, ydigits = Int(yticks), 6
    end

    xflip = get(plotattributes, :xflip, false)
    yflip = get(plotattributes, :yflip, false)

    spectral_axis = something(findfirst(in(SPECTRAL_NAMES), axisnames(z)), 1)

    if wf
        yflip = !yflip
        if spectral_axis == 1
            spectral_axis = 2
            z = permutedims(z)
        end
    elseif spectral_axis == 2
        spectral_axis = 1
        z = permutedims(z)
    end

    yax, xax = AxisArrays.axes(z)
    xaxv = xax.val
    yaxv = yax.val

    #xticks = min(xticks, length(xaxv))
    #yticks = min(yticks, length(yaxv))

    xtickidxs = range(1, stop=length(xaxv), length=xticks)
    ytickidxs = range(1, stop=length(yaxv), length=yticks)

    @show typeof(xaxv[1]) xtickidxs xdigits
    xtickvals = round.(float(typeof(xaxv[1])), interp(xaxv, xtickidxs), digits=xdigits)
    ytickvals = round.(float(typeof(yaxv[1])), interp(yaxv, ytickidxs), digits=ydigits)

    seriestype := :heatmap
    xflip --> xflip
    yflip --> yflip
    xticks := xticks > 0 ? (xtickidxs, xtickvals) : nothing
    yticks := yticks > 0 ? (ytickidxs, ytickvals) : nothing
    xtickdir := :out
    ytickdir := :out
    (1:length(xaxv), 1:length(yaxv), z)
end

end # module SpectrogramRecipes
