fgs.discrete <- function(df, structurePrior = 1.0, samplePrior = 1.0, depth = -1, faithfulness = TRUE, numOfThreads = 2,
    verbose = FALSE, java.parameters = NULL){

    params <- list(NULL)
    
    if(!is.null(java.parameters != NULL)){
        options(java.parameters = java.parameters)
        params <- c(java.parameters = java.parameters)
    }
    
    # Data Frame to BDeuScore
    score <- dataFrame2TetradBDeuScore(df, structurePrior, samplePrior)

    fgs <- list()
    class(fgs) <- "fgs.discrete"

    fgs$datasets <- deparse(substitute(df))

    cat("Datasets:\n")
    cat(deparse(substitute(df)),"\n")

    # Initiate FGS Discrete
    fgs_instance <- .jnew("edu/cmu/tetrad/search/Fgs", score)
    .jcall(fgs_instance, "V", "setDepth", as.integer(depth))
    .jcall(fgs_instance, "V", "setNumPatternsToStore", as.integer(0))
    .jcall(fgs_instance, "V", "setFaithfulnessAssumed", faithfulness)
    .jcall(fgs_instance, "V", "setParallelism", as.integer(numOfThreads))
    .jcall(fgs_instance, "V", "setVerbose", verbose)

    params <- c(params, depth = as.integer(depth))
    params <- c(params, faithfulness = as.logical(faithfulness))
    params <- c(params, numOfThreads = numOfThreads)
    params <- c(params, verbose = as.logical(verbose))

    fgs$parameters <- params

    cat("Graph Parameters:\n")
    cat("depth = ", as.integer(depth),"\n")
    cat("faithfulness = ", faithfulness,"\n")
    cat("numOfThreads = ", numOfThreads,"\n")
    cat("\n")

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