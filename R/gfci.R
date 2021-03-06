gfci <- function(df, penaltydiscount = 2.0, maxInDegree = 3, maxPathLength = -1, significance = 0.05,
    completeRuleSetUsed = FALSE, faithfulnessAssumed = TRUE, verbose = FALSE, java.parameters = NULL, 
    priorKnowledge = NULL){
    
    params <- list(NULL)
    
    if(!is.null(java.parameters)){
        options(java.parameters = java.parameters)
        params <- c(java.parameters = java.parameters)
    }

    # Data Frame to Independence Test
    tetradData <- loadContinuousData(df)
    indTest <- .jnew("edu/cmu/tetrad/search/IndTestFisherZ", tetradData, significance)
    
	indTest <- .jcast(indTest, "edu/cmu/tetrad/search/IndependenceTest")

    # Data Frame to Tetrad Dataset
    score <- dataFrame2TetradSemBicScore(df,penaltydiscount)

    gfci <- list()
    class(gfci) <- "gfci"

    gfci$datasets <- deparse(substitute(df))

    cat("Datasets:\n")
    cat(deparse(substitute(df)),"\n\n")

    # Initiate GFCI
    gfci_instance <- .jnew("edu/cmu/tetrad/search/GFci", indTest, score)
    .jcall(gfci_instance, "V", "setMaxIndegree", as.integer(maxInDegree))
    .jcall(gfci_instance, "V", "setMaxPathLength", as.integer(maxPathLength))
    .jcall(gfci_instance, "V", "setCompleteRuleSetUsed", completeRuleSetUsed)
    .jcall(gfci_instance, "V", "setFaithfulnessAssumed", faithfulnessAssumed)
    .jcall(gfci_instance, "V", "setVerbose", verbose)

    if(!is.null(priorKnowledge)){
        .jcall(gfci_instance, "V", "setKnowledge", priorKnowledge)
    }

	params <- c(params, penaltydiscount = as.double(penaltydiscount))
    params <- c(params, maxInDegree = as.integer(maxInDegree))
    params <- c(params, maxPathLength = as.integer(maxPathLength))
    params <- c(params, significance = significance)
    params <- c(params, completeRuleSetUsed = as.logical(completeRuleSetUsed))
    params <- c(params, faithfulnessAssumed = as.logical(faithfulnessAssumed))
    params <- c(params, verbose = as.logical(verbose))

    if(!is.null(priorKnowledge)){
        params <- c(params, prior = priorKnowledge)
    }
    gfci$parameters <- params

    cat("Graph Parameters:\n")
    cat("penaltydiscount = ", penaltydiscount,"\n")
    cat("maxInDegree = ", as.integer(maxInDegree),"\n")
    cat("maxPathLength = ", as.integer(maxPathLength),"\n")
    cat("significance = ", significance,"\n")
    cat("completeRuleSetUsed = ", completeRuleSetUsed,"\n")
    cat("faithfulnessAssumed = ", faithfulnessAssumed,"\n")
    cat("verbose = ", verbose,"\n")
    
    # Search
    tetrad_graph <- .jcall(gfci_instance, "Ledu/cmu/tetrad/graph/Graph;", "search")

    V <- extractTetradNodes(tetrad_graph)

    gfci$nodes <- V

    # extract edges
    gfci_edges <- extractTetradEdges(tetrad_graph)

    gfci$edges <- gfci_edges

    return(gfci)
}