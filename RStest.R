###############################################
#        Rossi & Sekhposyan (2019) Test       #
#                                             #
#             by Lluc Puig-Codina             #
###############################################

#UTF-8 Encoding


RStest <- function(pits, alpha = 0.05, nSim = 1000, rmin = 0, rmax = 1, step, l){
  
  if (!(is.vector(pits) && is.numeric(pits)) || !all(pits >= 0) || !all(pits <= 1) ){
    stop("pits must be a vector with values in [0, 1].")
  }
  
  if (missing(step) || !is.element(step, c("one","multiple"))){
    stop("Sepcify whether the test is at one or mutiple steps ahead.")
  }
  
  if (!is.numeric(alpha) || alpha < 0 || alpha > 1){
    stop("alpha must be a number in [0, 1].")
  }
  
  if (!is.integer(nSim) || nSim < 1){
    stop("nSim must be numeric and larger than 1.")
  }
  
  if (!is.numeric(rmin) || !is.numeric(rmax) || rmin < 0 || rmax > 1 || rmin >= rmax){
    stop("rmin and rmax must be numeric in [0, 1] and rmin < rmax.")
  }
  
  #Parameters
  P <- length(pits)
  r <- seq(0,1,0.001)
  rmin <- match(rmin, r)
  rmax <- match(rmax, r)
  
  #Boostrap bandwidth default as in most simulations presented in 
  #Rossi & Sekhposyan (2019)
  if (missing(l)){
    l = floor(P^(1/3))
  }
  if (!is.integer(l) || l < 1){
    stop("Boostrap block length, l, must be numeric and larger than 1.")
  }

  #Statistics
  cumsumpits <- c()
  
  for (k in 1:length(r)){
    cumsumpits <- cbind(cumsumpits, (pits <= r[k]) - r[k])
  }
  
  v_P <- colSums(cumsumpits)/sqrt(P)
  v_P <- v_P[rmin:rmax]

  KS_P  <- max(abs(v_P))
  CvM_P <- mean((v_P)^2)
  
  #Critical Values
  KS_results <- c()
  CvM_results <- c()
  
  if (step == "one"){
    
    for (i in 1:nSim){
      
      u <- runif(P)
      cumsum <- c()
      
      for (k in 1:length(r)){
        cumsum <- cbind(cumsum, (u <= r[k]) - r[k])
      }
      
      v <- colSums(cumsum)/sqrt(P)
      v <- v[rmin:rmax]
      
      KS <- max(abs(v))
      CvM <- mean((v)^2)
      KS_results <- c(KS_results, KS)
      CvM_results <- c(CvM_results, CvM )
      
    }
    
  } else if(step == "multiple"){
    
    emp_cdf <- c()
    
    for (k in 1:length(r)){
      emp_cdf <- cbind(emp_cdf, pits <= r[k])
    }
    
    average_emp_cdf = (1/P)*colSums(emp_cdf)
    average_emp_cdf = matrix(rep(average_emp_cdf,P), nrow=P, byrow=TRUE)
    raw_minus_average = emp_cdf - average_emp_cdf
    
    for (i in 1:nSim){
      
      v <- 0
      n = rnorm(P-l+1, mean = 0, sd = 1/sqrt(l))
      
      for (j in 1:(P-l+1)){
        
        v <- v + ((1/sqrt(P))*n[j])*colSums(raw_minus_average[j:(j+l-1),])

      }
      
      v <- v[rmin:rmax]
      KS <- max(abs(v))
      CvM <- mean((v)^2)
      KS_results <- c(KS_results, KS)
      CvM_results <- c(CvM_results, CvM )

    }

  } else {
    
    KS_results <- NULL
    CvM_results <- NULL
    
  }
  
  KS_alpha <- quantile(KS_results, (1-alpha))
  CvM_alpha <- quantile(CvM_results, (1-alpha))
  
  
  #Results
  results = list("KS_P" = KS_P, "KS_alpha" = KS_alpha,
                 "CvM_P" = CvM_P, "CvM_alpha" = CvM_alpha)
  return(results)
}