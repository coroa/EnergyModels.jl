function build!(m::EnergyModel)
    # If subnetworks are not set, compute them
    isempty(m.subnetworks) && determine_subnetworks!(m)

    # Clear jump model
    empty!(m.jumpobjects)
    MOI.empty!(backend(m.jumpmodel))
    for vartype in [:fix, :integrality, :lower_bound, :upper_bound, :zero_one]
        empty!(getfield(m.jumpmodel, Symbol(:variable_to_, vartype)))
    end

    # Fill it up again
    addto!(m.jumpmodel, m)
end

function addto!(jm::JuMP.AbstractModel, m::EnergyModel)
    # @info("* Equations for individual devices")
    for d = devices(m)
        # @info("  - $(naming(d)) ($(naming(typeof(d))))")
        addto!(jm, m, d)
    end
    # @info("* Equations for energy balance")
    for d = buses(m)
        addto!(jm, m, d)
    end
    # @info("* Equations for subnetworks")
    for sn = subnetworks(m)
        addto!(jm, m, sn)
    end
    # @info("* Cost minimization objective")
    @objective(jm, Min, sum(cost(d) for d = devices(m)))

    jm
end
