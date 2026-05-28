struct FEuler <: AbstractODESolver end
struct RK4 <: AbstractODESolver end
struct Heun <: AbstractODESolver end
struct MidpointRK2 <: AbstractODESolver end
struct SSPRK3 <: AbstractODESolver end

function step(::FEuler, u, t, f, h) 
    
    k1 = f(t, u)
    return u + h * k1
end

function step(::RK4, u, t, f, h)

    k1 = f(t, u)
    k2 = f(t + h/2, u + h/2 * k1)
    k3 = f(t + h/2, u + h/2 * k2)
    k4 = f(t + h,   u + h * k3)

    return u + h/6 * (k1 + 2k2 + 2k3 + k4)
end

function step(::Heun, u, t, f, h)

    k1 = f(t, u)
    u_star = u + h * k1

    return u + h/2 * (k1 + f(t + h, u_star))
end

function step(::MidpointRK2, u, t, f, h)
    
    k1 = f(t, u)
    u_mid = u + (h/2) * k1
    k2 = f(t + h/2, u_mid)

    return u + h * k2
end

function step(::SSPRK3, u, t, f, h)

    k1 = f(t, u)
    k2 = f(t+h, u + k1 * h)
    k3 = f(t + h/2, u + (k1/4 + k2/4) * h)

    return u + h * (k1/6 + k2/6 + 2k3/3)
end