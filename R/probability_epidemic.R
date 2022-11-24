#' Calculates the probability a branching process will cause an epidemic
#' (i.e. probability will fail to go extinct) based on R, k and initial cases
#' 
#' @param R A `number` specifying the R parameter (i.e. average secondary cases per infectious individual)
#' @param k A `number` specifying the  k parameter (i.e. overdispersion in offspring distribution from fitted negative binomial)
#' @param a A `count` specifying the number of initial infections
#'
#' @return A value with the probablity of a large epidemic
#' @export
#'
#' @examples
#' probability_epidemic(1.5, 0.1, 10)

probability_epidemic <- function(R,k,a) {
  # check inputs
  checkmate::assertNumber(R)
  checkmate::assertNumber(k)
  checkmate::assertCount(a)

  # Calculate probability of outbreak based solving g(s)=s in generating function for branching process
  if(R<=1){prob_est <- 1} # If R<=1, P(extinction)=1
  
  if(R>1){  # If R<1, P(extinction)<1
    ss <- seq(0.001,0.999,0.001) # set up grid search
    calculate_prob <- abs((1 + (R/k)*(1 - ss))^(-k) - ss) # Define loss function
    prob_est <- ss[which.min(calculate_prob)] # Calculate probability of extinction
  }
   
  # Calculate P(epidemic) given 'a' introductions
  prob_epidemic <- 1 - prob_est^a
  
  return(prob_epidemic)
}
