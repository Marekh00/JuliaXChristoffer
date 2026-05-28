function annotation_policy(m, h_min, h_max, anchor, order_index; style=:global)

    style == :global &&
        return annotation_global(m, h_min, h_max, anchor; order_index)

    style == :local &&
        return annotation_local(m; order_index)
end

function annotation_global(m, h_min, h_max, anchor; order_index=1)

    p = order(m.method)

    h_anchor = sqrt(h_min * h_max)

    y_anchor = reference_curve([h_anchor], p, anchor...)[1]

    return place_annotation(h_anchor*0.6, y_anchor*0.6, p; offset=order_index)
end

function annotation_local(m; order_index=1)

    p = order(m.method)

    h_anchor = sqrt(minimum(m.h) * maximum(m.h))

    idx = argmin(abs.(log.(m.h) .- log(h_anchor)))

    x_anchor = m.h[idx]
    y_anchor = m.error[idx]

    return place_annotation(x_anchor, y_anchor*3, p; offset=order_index)
end

function place_annotation(x_anchor, y_anchor, p; offset=1)

    x = x_anchor * 10^(0.02 * offset)
    y = y_anchor * 10^(0.04 * offset)

    label = text(L"h^{%$p}", 8)

    return x, y, label
end

function order_annotation(m::MethodResult)
    mid = (length(m.h) + 1) ÷ 2
    x = 0.8*m.h[mid]
    y = 3*m.error[mid]
    p̂ = estimated_order(m)
    return x, y, text("p ≈ $(round(p̂, digits=3))", 8, :left)
end