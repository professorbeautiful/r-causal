fgs.discrete <- function(df, structurePrior = 1.0, samplePrior = 1.0, maxDegree = 3, 
	faithfulnessAssumed = TRUE, numOfThreads = 2, verbose = FALSE, java.parameters = NULL, 
	priorKnowledge = NULL){

    params <- list(NULL)
    
    if(!is.null(java.parameters)){
        options(java.parameters = java.parameters)
        params <- c(java.parameters = java.parameters)
    }
    
    # Data Frame to Tetrad Dataset
    score <- dataFrame2TetradBDeuScore(df, structurePrior, samplePrior)

    fgs <- list()
    class(fgs) <- "fgs.discrete"

    fgs$datasets <- deparse(substitute(df))

    cat("Datasets:\n")
    cat(deparse(substitute(df)),"\n")

    # Initiate FGS Discrete
    fgs_instance <- .jnew("edu/cmu/tetrad/search/Fgs", score)
    .jcall(fgs_instance, "V", "setMaxDegree", as.integer(maxDegree))
    .jcall(fgs_instance, "V", "setNumPatternsToStore", as.integer(0))
    .jcall(fgs_instance, "V", "setFaithfulnessAssumed", faithfulnessAssumed)
    .jcall(fgs_instance, "V", "setParallelism", as.integer(numOfThreads))
    .jcall(fgs_instance, "V", "setVerbose", verbose)

    if(!is.null(priorKnowledge)){
        .jcall(fgs_instance, "V", "setKnowledge", priorKnowledge)
    }

    params <- c(params, structurePrior = as.double(structurePrior))
    params <- c(params, samplePrior = as.double(samplePrior))
    params <- c(params, maxDegree = as.integer(maxDegree))
    params <- c(params, faithfulnessAssumed = as.logical(faithfulnessAssumed))
    params <- c(params, numOfThreads = numOfThreads)
    params <- c(params, verbose = as.logical(verbose))

    if(!is.null(priorKnowledge)){
        params <- c(params, prior = priorKnowledge)
    }
    
    fgs$parameters <- params

    cat("Graph Parameters:\n")
    cat("structurePrior = ", structurePrior,"\n")
    cat("samplePrior = ", samplePrior,"\n")
    cat("maxDegree = ", as.integer(maxDegree),"\n")
    cat("faithfulnessAssumed = ", faithfulnessAssumed,"\n")
    cat("numOfThreads = ", numOfThreads,"\n")
    cat("verbose = ", verbose,"\n")

    # Search
    tetrad_graph <- .jcall(fgs_instance, "Ledu/cmu/tetrad/graph/Graph;", 
        "search")

    V <- extractTetradNodes(tetrad_graph)

    fgs$nodes <- V

    # extract edges
    fgs_edges <- extractTetradEdges(tetrad_graph)

    fgs$edges <- fgs_edges

    # convert output of FGS into an R object (graphNEL)
    fgs_graphNEL = tetradPattern2graphNEL(resultGraph = tetrad_graph,
        verbose = verbose)

    fgs$graphNEL <- fgs_graphNEL

    return(fgs) 
}