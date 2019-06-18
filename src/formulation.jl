## Formulations for Devices

# Dispatch formulations
abstract type DispatchForm <: DeviceFormulation end
struct LinearDispatchForm <: DispatchForm end
struct UnitCommittmentForm <: DispatchForm end

# Expansion Formulations
abstract type ExpansionForm{T<:DispatchForm} <: DeviceFormulation end
struct LinearExpansionForm{T<:DispatchForm} <: ExpansionForm{T} end
struct LinearExpansionDispatchForm{T<:DispatchForm} <: ExpansionForm{T} end
struct LinearExpansionInvestmentForm{T<:DispatchForm} <: ExpansionForm{T} end

struct BlockExpansionForm{T<:DispatchForm} <: ExpansionForm{T} end
struct BlockExpansionDispatchForm{T<:DispatchForm} <: ExpansionForm{T} end
struct BlockExpansionInvestmentForm{T<:DispatchForm} <: ExpansionForm{T} end

struct BinaryExpansionForm{T<:DispatchForm} <: ExpansionForm{T} end
struct BinaryExpansionDispatchForm{T<:DispatchForm} <: ExpansionForm{T} end
struct BinaryExpansionInvestmentForm{T<:DispatchForm} <: ExpansionForm{T} end

# TODO multi-year formulations

## ModelTypes

abstract type DispatchModel <: ModelType end
struct LinearDispatchModel <: DispatchModel end
struct UnitCommittmentModel <: DispatchModel end

abstract type ExpansionModel <: ModelType end

# If nothing else is said, let's say it's fine
demote_formulation(::Type{ExpansionModel}, DF::Type{ExpansionForm}) = DF
demote_formulation(::Type{DispatchModel},  DF::Type{DispatchForm}) = DF

# An expansion form should demote to its respective DispatchForm
demote_formulation(MT::Type{DispatchModel}, ::Type{ExpansionForm{DDF}}) where DDF <: DispatchForm = demote_formulation(MT, DDF)

# We demote UnitCommittment to LinearDispatch in a LinearDispatchModel
demote_formulation(::Type{LinearDispatchModel}, ::Type{UnitCommittmentForm}) = LinearDispatchForm

with_formulation(d::T, ::Type{DF}) where {T <: Device, DF <: DeviceFormulation} = T(d, DF)