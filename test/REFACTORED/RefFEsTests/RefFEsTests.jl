module RefFEsTests

using Gridap.DOFBases: LagrangianDOFBasis

##
using Gridap, Test

using Gridap.Helpers
using Gridap.Polytopes: PointInt

using Base.Cartesian
##

# Create dofbasis using node array for Lagrangian FEs

# Create BasisWithChangeOfBasis
# i.e., CanonicalBasis given DOFs

# nfacetoowndofs


##
# 1D reffe
D = 1
orders=[2]
extrusion = PointInt{D}(1)
polytope = Polytope(extrusion)
nodes = NodesArray(polytope,orders)
dofsb = LagrangianDOFBasis{D,Float64}(nodes.coordinates)
prebasis = MonomialBasis(Float64,orders)
vals = evaluate(prebasis,dofsb.nodes)
@test vals == [1.0 1.0 1.0; -1.0 0.0 1.0; 1.0 0.0 1.0]
##

##
# 1D reffe
D = 2
orders=[1,1]
extrusion = PointInt{D}(1,1)
polytope = Polytope(extrusion)
nodes = NodesArray(polytope, orders)
dofsb = LagrangianDOFBasis{D,VectorValue{D,Float64}}(nodes.coordinates)
prebasis = MonomialBasis(VectorValue{D,Float64},orders)
# res = RefFEs.evaluate!(dofsb,prebasis,aux)
res = evaluate(dofsb,prebasis)
@test res[8,8] == 1.0
res = evaluate(dofsb,prebasis)
@test res[8,8] == 1.0
fun(x::Point{D}) = VectorValue(x[2]+1.0,x[1])
anfield = AnalyticalField(fun,D)
Maps.evaluate(anfield,nodes.coordinates)
res2 = evaluate(dofsb,anfield)
@test res2[8] == 1.0
##
D=2
orders=[1,1]
extrusion = PointInt{D}(1,1)
polytope = Polytope(extrusion)
reffe = LagrangianRefFE{D,VectorValue{D,Float64}}(polytope,orders)
nodes = NodesArray(polytope, orders)
val1 = evaluate(reffe.shfbasis,nodes.coordinates)
id = zeros(VectorValue{D,Float64},size(val1))
for i in 1:4
  id[i,i] = VectorValue{D}(1.0, 0.0)
  id[i+4,i] = VectorValue{D}(0.0, 1.0)
end
@test val1 == id
dofv = RefFEs.evaluate(reffe.dofbasis, reffe.shfbasis)
id = zeros(Float64,length(reffe.shfbasis), length(reffe.shfbasis))
for i in 1:length(reffe.shfbasis)
  id[i,i] = 1.0
end
dofv
@test dofv == id
##
##
# 1D reffe
D = 1
orders=[2]
extrusion = PointInt{D}(1)
polytope = Polytope(extrusion)
reffe = LagrangianRefFE{D,VectorValue{D,Float64}}(polytope,orders)
@test reffe.shfbasis.changeofbasis==[0.0  -0.5   0.5; 1.0   0.0  -1.0; 0.0   0.5   0.5]
##


#TODO Until we do not refactor Intergtion we cannot uncomment following lines

###
## Integration
#D = 2
#orders=[1,1]
#extrusion = PointInt{D}(1,1)
#polytope = Polytope(extrusion)
#gps=(2,2)
#quad=TensorProductQuadrature(orders=gps)
#reffe = LagrangianRefFE{D,Float64}(polytope, orders)
#shfs = evaluate(reffe.shfbasis,quad.coords)
#gradb = gradient(reffe.shfbasis)
#gradshfs = evaluate(gradb,quad.coords)
#reffe.shfbasis
#@test sum(sum(gradshfs)) ≈ 0.0
#@test sum(shfs) ≈ prod(gps)
#@test size(gradshfs) == (4,4)
#@test size(shfs) == (4,4)
###
#D = 1
#orders=[1]
#extrusion = PointInt{D}(1)
#polytope = Polytope(extrusion)
##orders/2=gps
#gps=(2,)
#quad=TensorProductQuadrature(orders=gps)
#reffe = LagrangianRefFE{D}{Float64}(polytope,orders)
#shfs = evaluate(reffe.shfbasis, quad.coords)
#elmatgp=[ shfs[:,igp]*shfs[:,igp]' for igp=1:prod(gps)]
#elmat = sum(quad.weights.*elmatgp)
#@test elmat≈[2/3 1/3; 1/3 2/3]
###
#
###
#D=2
#orders=[1,1]
#extrusion = PointInt{D}(1,1)
#polytope = Polytope(extrusion)
##orders/2=gps
#gps=(2,2)
#quad=TensorProductQuadrature(orders=gps)
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#shfs = evaluate(reffe.shfbasis, quad.coords)
#elmatgp=[ shfs[:,igp]*shfs[:,igp]' for igp=1:prod(gps)]
#elmat = sum(quad.weights.*elmatgp)
#@test elmat≈[4/9 2/9 2/9 1/9; 2/9 4/9 1/9 2/9; 2/9 1/9 4/9 2/9; 1/9 2/9 2/9 4/9]
###
#
###
#D=2
#orders=[2,2]
#extrusion = PointInt{D}(1,1)
#polytope = Polytope(extrusion)
##orders/2=gps
## gps=(3,3)
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#shfs = evaluate(reffe.shfbasis, quad.coords)
#numgps = length(quad.weights)
#elmatgp=[ shfs[:,igp]*shfs[:,igp]' for igp=1:numgps]
#elmat = sum(quad.weights.*elmatgp)
#@test sum(elmat)≈4
#@test elmat[1,1] ≈ 16/225
#@test elmat[1,2] ≈ 8/225
###
#
###
#D=3
#orders=[2,2,2]
#extrusion = PointInt{D}(1,1,1)
#polytope = Polytope(extrusion)
##orders/2=gps
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#shfs = evaluate(reffe.shfbasis, quad.coords)
#numgps = length(quad.weights)
#elmatgp=[ shfs[:,igp]*shfs[:,igp]' for igp=1:prod(numgps)]
#elmat = sum(quad.weights.*elmatgp)
#@test sum(elmat)≈8
#@test elmat[1,1] ≈ 64/3375
#@test elmat[1,2] ≈ 32/3375
###
#
###
#D=1
#orders=[1]
#extrusion = PointInt{D}(1)
#polytope = Polytope(extrusion)
##orders/2=gps
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gradshfs = evaluate(gradb,quad.coords)
#numgps = length(quad.weights)
#elmatgp = [ view(gradshfs,:,igp)*view(gradshfs,:,igp)' for igp=1:numgps]
#elmat = sum(quad.weights.*elmatgp)
#@test elmat ≈ [1/2 -1/2; -1/2 1/2]
###
#
###
#D=2
#orders=[1,1]
#extrusion = PointInt{D}(1,1)
#polytope = Polytope(extrusion)
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gshfs = evaluate(gradb, quad.coords)
#numgps = length(quad.weights)
#l = length(reffe.shfbasis)
#elmatgp = [[inner(gshfs[i,q],gshfs[j,q]) for i in 1:l, j in 1:l] for q in 1:numgps]
#elmat = sum(quad.weights.*elmatgp)
#@test 1.0+sum(elmat)≈1.0
#@test sum(elmat,dims=2).+1≈fill(0,size(elmat,1)).+1
#@test elmat[1,1] ≈ 2/3
###
#
###
#D=2
#orders=[2,2]
#extrusion = PointInt{D}(1,1)
#polytope = Polytope(extrusion)
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gshfs = evaluate(gradb, quad.coords)
#numgps = length(quad.weights)
#l = length(reffe.shfbasis)
#elmatgp = [[inner(gshfs[i,q],gshfs[j,q]) for i in 1:l, j in 1:l] for q in 1:numgps]
#elmat = sum(quad.weights.*elmatgp)
#@test 1.0+sum(elmat)≈1.0
#@test sum(elmat,dims=2).+1≈fill(0,size(elmat,1)).+1
#@test elmat[1,1] ≈ 28/45
###
#
###
#D=3
#orders=[3,3,3]
#extrusion = PointInt{D}(1,1,1)
#polytope = Polytope(extrusion)
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gshfs = evaluate(gradb, quad.coords)
#numgps = length(quad.weights)
#l = length(reffe.shfbasis)
#elmatgp = [[inner(gshfs[i,q],gshfs[j,q]) for i in 1:l, j in 1:l] for q in 1:numgps]
#elmat = sum(quad.weights.*elmatgp)
#@test 1.0+sum(elmat)≈1.0
#@test sum(elmat,dims=2).+1≈fill(0,size(elmat,1)).+1
#elmatscal = elmat
###
#
###
## Vector FE space
#D = 2
#nparts1d = 2
#nparts = nparts1d*ones(Int64,D)
#order=2
#orders=order*ones(Int64,D)
#extrusion = PointInt{D}(ones(Int64,D))
#polytope = Polytope(extrusion)
#quad=TensorProductQuadrature(orders=tuple(2*orders...))
##
#reffe = LagrangianRefFE{D,VectorValue{D,Float64}}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gshfs = evaluate(gradb, quad.coords)
#numgps = length(quad.weights)
#l = length(reffe.shfbasis)
#elmatgp = [[inner(gshfs[i,q],gshfs[j,q]) for i in 1:l, j in 1:l] for q in 1:numgps]
#elmatvec = sum(quad.weights.*elmatgp)
##
#reffe = LagrangianRefFE{D,Float64}(polytope,orders)
#gradb = gradient(reffe.shfbasis)
#gshfs = evaluate(gradb, quad.coords)
#numgps = length(quad.weights)
#l = length(reffe.shfbasis)
#elmatgp = [[inner(gshfs[i,q],gshfs[j,q]) for i in 1:l, j in 1:l] for q in 1:numgps]
#elmatscal = sum(quad.weights.*elmatgp)
##
#@test elmatvec[1:l,1:l] == elmatscal
#@test elmatvec[l+1:2l,l+1:2l] == elmatscal
###

end # module
