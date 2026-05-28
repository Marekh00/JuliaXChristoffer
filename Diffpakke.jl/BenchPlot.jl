function BenchPlot(result::BenchmarkResult; reference_style = :local)

    fig = plot(xscale = :log10, yscale = :log10)
    xlabel!("h")
    ylabel!("Global Error")
    title!("Order Comparison")

    for m in result.methods
        plot_methods!(m)
    end

    h_min = minimum(minimum(m.h) for m in result.methods)
    h_max = maximum(maximum(m.h) for m in result.methods)

    orders = unique(order(m.method) for m in result.methods)

    order_map = Dict(o => i for (i, o) in enumerate(sort(orders)))

    anchor = get_global_anchor(result, h_min, h_max)


    if reference_style == :global
        plot_global_references!(h_min, h_max, orders, anchor)

    elseif reference_style == :local
        for m in result.methods
            plot_local_references!(m)
        end
    end

    for m in result.methods
        x, y, label = order_annotation(m)
        annotate!(x, y, label)
    end

    for m in result.methods

        idx = order_map[order(m.method)]

        x, y, ann = annotation_policy(
            m,
            h_min,
            h_max,
            anchor,
            idx;
            style=reference_style
        )

        annotate!(x, y, ann)
    end

    plot!(legend = :bottomright)
    return fig
end

function plot_methods!(m::MethodResult)
    plot!(m.h, m.error, label = string(name(m.method)), marker = :circle, linestyle = :solid,
          markersize = 2, linewidth = 2)
end

function plot_global_references!(h_min, h_max, orders, anchor)
    hset = 10 .^ range(log10(h_min), log10(h_max), length = 100)
    for p in orders
        plot!(hset, reference_curve(hset, p, anchor...), label=false, color = :black, linestyle = :dash, linewidth = 1)
    end
end

function get_global_anchor(result, h_min, h_max)
    h_ref = sqrt(h_min * h_max)

    highest_order = maximum(order(m.method) for m in result.methods)
    best_method = findfirst(m -> order(m.method) == highest_order, result.methods)

    return get_anchor(result.methods[best_method], h_ref)
end

function plot_local_references!(m)

    p = order(m.method)

    mid = (length(m.h) + 1) ÷ 2
    h_anchor = m.h[mid]
    e_anchor = m.error[mid]

    h_local = range(0.5h_anchor, 2h_anchor, length=30)
    e_local = e_anchor .* (h_local ./ h_anchor) .^ p

    plot!(h_local, e_local,
          linestyle=:dash,
          color=:black,
          label=false)
end

function get_anchor(m::MethodResult, h_ref)
    idx = argmin(abs.(log.(m.h) .- log(h_ref)))
    return m.h[idx], m.error[idx]
end

function reference_curve(hset, p, h_anchor, e_anchor)
    return e_anchor .* (hset ./ h_anchor) .^ p
end