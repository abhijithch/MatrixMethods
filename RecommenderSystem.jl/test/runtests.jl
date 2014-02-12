using Base.Test
require("RecommenderSystem")

test_type = length(ARGS) == 1 ? ARGS[1] : "ALL"

#if test_type == "ALL" || test_type == "TEST" || test_type == "INSTALL"
#  @test RecommenderSystem.RecommendSys()
#end
