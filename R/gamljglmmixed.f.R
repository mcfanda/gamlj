#' Generalized Mixed Models
#'
#' Generalized Mixed Linear Model. Estimates models using `lme4::glmer()` function and provides options to facilitate estimation of 
#'            interactions, simple slopes, simple effects, post-hoc tests, contrast analysis, effect size indexes and visualization of the results.
#'
#'
#' @examples
#' data(subjects_by_stimuli)
#'
#' gamlj::gamljMixed(
#'        formula = y ~ 1 + cond+( 1|subj ),
#'        data = subjects_by_stimuli)
#'
#' gamlj::gamljMixed(
#'        data = subjects_by_stimuli,
#'        dep = "y",
#'        factors = "cond",
#'        modelTerms = "cond",
#'        cluster = "subj",
#'        randomTerms=list(list(c("cond","subj"))))
#'        
#' @param data the data as a data frame
#' @param formula (optional) the formula to use. The syntax is the same used in [lme4::lmer()]. See the examples
#' @param dep a string naming the dependent variable from \code{data},
#'   variable must be numeric
#' @param factors a vector of strings naming the fixed factors from
#'   \code{data}
#' @param covs a vector of strings naming the covariates from \code{data}
#' @param modelTerms a list of character vectors describing fixed effects
#'   terms
#' @param fixedIntercept \code{TRUE} (default) or \code{FALSE}, estimates
#'   fixed intercept
#' @param showParamsCI \code{TRUE} (default) or \code{FALSE} , parameters CI
#'   in table
#' @param showExpbCI \code{TRUE} (default) or \code{FALSE} , exp(B) CI in
#'   table
#' @param paramCIWidth a number between 50 and 99.9 (default: 95) specifying
#'   the confidence interval width for the parameter estimates
#' @param contrasts   a named vector of the form \code{c(var1='type', var2='type2')} specifying the type of contrast to use,
#'    one of \code{'deviation'}, \code{'simple'}, \code{'dummy'}, \code{'difference'}, \code{'helmert'}, \code{'repeated'} or \code{'polynomial'}.
#'     If NULL, \code{'simple'} is used. Can also be passed as a list of list of the form \code{list(list(var='var1',type='type1'))}.
#' @param showRealNames \code{TRUE} or \code{FALSE} (default), provide raw
#'   names of the contrasts variables
#' @param showContrastCode \code{TRUE} or \code{FALSE} (default), provide
#'   contrast coefficients tables
#' @param plotHAxis a string naming the variable placed on the horizontal axis
#'   of the plot
#' @param plotSepLines a string naming the variable represented as separate
#'   lines on the plot
#' @param plotSepPlots the variable for whose levels multiple plots are
#'   computed
#' @param plotRaw \code{TRUE} or \code{FALSE} (default), provide descriptive
#'   statistics
#' @param plotDvScale \code{TRUE} or \code{FALSE} (default), scale the plot
#'   Y-Axis to the max and the min of the dependent variable observed scores.
#' @param plotError \code{'none'}, \code{'ci'} (default), or \code{'se'}. Use
#'   no error bars, use confidence intervals, or use standard errors on the
#'   plots, respectively
#' @param ciWidth a number between 50 and 99.9 (default: 95) specifying the
#'   confidence interval width
#' @param postHoc a list of terms to perform post-hoc tests on
#' @param eDesc \code{TRUE} or \code{FALSE} (default), provide lsmeans
#'   statistics
#' @param eCovs \code{TRUE} or \code{FALSE} (default), provide lsmeans
#'   statistics
#' @param simpleVariable The variable for which the simple effects (slopes)
#'   are computed
#' @param simpleModerator the variable that provides the levels at which the
#'   simple effects computed
#' @param simple3way a moderator of the two-way interaction which is probed
#' @param simpleScale \code{'mean_sd'} (default), \code{'custom'} , or
#'   \code{'custom_percent'}. Use to condition the covariates (if any)
#' @param cvalue offset value for conditioning
#' @param percvalue offset value for conditioning
#' @param simpleScaleLabels decide the labeling of simple effects in tables
#'   and plots.  \code{labels} indicates that only labels are used, such as
#'   \code{Mean} and  \code{Mean + 1 SD}. \code{values} uses the actual values
#'   as labels. \code{values_labels} uses both.
#' @param postHocCorr one or more of \code{'none'},  \code{'bonf'}, or
#'   \code{'holm'}; provide no,  Bonferroni, and Holm Post Hoc corrections
#'   respectively
#' @param scaling a named vector of the form \code{c(var1='type1',var2='type2')}. Types are
#'   \code{'centered'} to the mean, \code{'clusterbasedcentered'} to the mean of each cluster, \code{'standardized'},
#'    \code{'clusterbasedstandardized'} standardized within each cluster, log-transformed \code{'log'},  or \code{'none'}.
#'   \code{'none'} leaves the variable as it is. It can also be passed as a list of lists.
#' @param cluster a vector of strings naming the clustering variables from
#'   \code{data}
#' @param randomTerms a list of lists specifying the models random effects.
#' @param correlatedEffects \code{'nocorr'}, \code{'corr'} (default), or
#'   \code{'block'}. When random effects are passed as list of length 1, it
#'   decides whether the effects should be correlated,  non correlated. If
#'   \code{'randomTerms'} is a list of  lists of length > 1, the option is
#'   automatially set to \code{'block'}. The option is ignored if the model is
#'   passed using \code{formula}.
#' @param plotRandomEffects \code{TRUE} or \code{FALSE} (default), add random
#'   effects predicted values in the plot
#' @param plotLinearPred \code{TRUE} or \code{FALSE} (default), plot the
#'   predicted values in the linear predictor scale. If set, \code{plotRaw} and
#'   \code{plotDvScale} are ignored.
#' @param nAGQ for the adaptive Gauss-Hermite log-likelihood approximation,
#'   nAGQ argument controls the number of nodes in the quadrature formula. A
#'   positive integer
#' @param effectSize .
#' @param modelSelection Select the generalized linear model:
#'   \code{linear},\code{poisson},\code{logistic},\code{nb}, the latest being
#'   Negative Binomial
#' @param custom_family Distribution family for the custom model, accepts
#'   gaussian, binomial, gamma and inverse_gaussian .
#' @param custom_link Distribution family for the custom model, accepts
#'   identity, log and inverse, onemu2 (for 1/mu^2).
#' @param cimethod .
#' @return A results object containing:
#' \tabular{llllll}{
#'   \code{results$model} \tab \tab \tab \tab \tab The underlying \code{glmer} object \cr
#'   \code{results$info} \tab \tab \tab \tab \tab a table \cr
#'   \code{results$main$anova} \tab \tab \tab \tab \tab a table of ANOVA results \cr
#'   \code{results$main$fixed} \tab \tab \tab \tab \tab a table \cr
#'   \code{results$main$random} \tab \tab \tab \tab \tab a table \cr
#'   \code{results$main$randomCov} \tab \tab \tab \tab \tab a table \cr
#'   \code{results$main$contrastCodeTables} \tab \tab \tab \tab \tab an array of contrast coefficients tables \cr
#'   \code{results$postHocs} \tab \tab \tab \tab \tab an array of post-hoc tables \cr
#'   \code{results$simpleEffects$Anova} \tab \tab \tab \tab \tab a table of ANOVA for simple effects \cr
#'   \code{results$simpleEffects$Params} \tab \tab \tab \tab \tab a table \cr
#'   \code{results$emeansTables} \tab \tab \tab \tab \tab an array of predicted means tables \cr
#'   \code{results$descPlot} \tab \tab \tab \tab \tab a descriptives plot \cr
#'   \code{results$descPlots} \tab \tab \tab \tab \tab an array of results plots \cr
#'   \code{results$plotnotes} \tab \tab \tab \tab \tab a html \cr
#' }
#'
#' Tables can be converted to data frames with \code{asDF} or \code{\link{as.data.frame}}. For example:
#'
#' \code{results$info$asDF}
#'
#' \code{as.data.frame(results$info)}
#'
#' @export
gamljGlmMixed <- function(
  data,
  formula=NULL,
  dep = NULL,
  factors = NULL,
  covs = NULL,
  modelTerms = NULL,
  fixedIntercept = TRUE,
  showParamsCI = FALSE,
  showExpbCI = TRUE,
  paramCIWidth = 95,
  contrasts = NULL,
  showRealNames = TRUE,
  showContrastCode = FALSE,
  plotHAxis = NULL,
  plotSepLines = NULL,
  plotSepPlots = NULL,
  plotRaw = FALSE,
  plotDvScale = FALSE,
  plotError = "none",
  ciWidth = 95,
  postHoc = NULL,
  eDesc = FALSE,
  eCovs = FALSE,
  simpleVariable = NULL,
  simpleModerator = NULL,
  simple3way = NULL,
  simpleScale = "mean_sd",
  cvalue = 1,
  percvalue = 25,
  simpleScaleLabels = "labels",
  postHocCorr = list(
    "bonf"),
  scaling = NULL,
  cluster = NULL,
  randomTerms = list(
    list()),
  correlatedEffects = "corr",
  plotRandomEffects = FALSE,
  plotLinearPred = FALSE,
  nAGQ = 1,
  effectSize = list(
    "expb"),
  modelSelection = "logistic",
  custom_family = "gaussian",
  custom_link = "identity",
  cimethod = "wald"
  ) {
  
  if ( ! requireNamespace('jmvcore'))
    stop('gamljGlmMixed requires jmvcore to be installed (restart may be required)')
  
  if ( ! missing(formula)) {
    if (missing(dep))
      dep <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="dep")
    if (missing(factors))
      factors <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="factors")
    if (missing(covs))
      covs <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="covs")
    if (missing(cluster))
      cluster <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="cluster")
    if (missing(randomTerms))
      randomTerms <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="randomTerms")
    if (missing(modelTerms))
      modelTerms <- gamljGlmMixedClass$private_methods$.marshalFormula(
        formula=formula,
        data=`if`( ! missing(data), data, NULL),
        name="modelTerms")
  }
  
  if ( ! missing(dep)) dep <- jmvcore::resolveQuo(jmvcore::enquo(dep))
  if ( ! missing(factors)) factors <- jmvcore::resolveQuo(jmvcore::enquo(factors))
  if ( ! missing(covs)) covs <- jmvcore::resolveQuo(jmvcore::enquo(covs))
  if ( ! missing(plotHAxis)) plotHAxis <- jmvcore::resolveQuo(jmvcore::enquo(plotHAxis))
  if ( ! missing(plotSepLines)) plotSepLines <- jmvcore::resolveQuo(jmvcore::enquo(plotSepLines))
  if ( ! missing(plotSepPlots)) plotSepPlots <- jmvcore::resolveQuo(jmvcore::enquo(plotSepPlots))
  if ( ! missing(simpleVariable)) simpleVariable <- jmvcore::resolveQuo(jmvcore::enquo(simpleVariable))
  if ( ! missing(simpleModerator)) simpleModerator <- jmvcore::resolveQuo(jmvcore::enquo(simpleModerator))
  if ( ! missing(simple3way)) simple3way <- jmvcore::resolveQuo(jmvcore::enquo(simple3way))
  if ( ! missing(cluster)) cluster <- jmvcore::resolveQuo(jmvcore::enquo(cluster))
  if (missing(data))
    data <- jmvcore::marshalData(
      parent.frame(),
      `if`( ! missing(dep), dep, NULL),
      `if`( ! missing(factors), factors, NULL),
      `if`( ! missing(covs), covs, NULL),
      `if`( ! missing(plotHAxis), plotHAxis, NULL),
      `if`( ! missing(plotSepLines), plotSepLines, NULL),
      `if`( ! missing(plotSepPlots), plotSepPlots, NULL),
      `if`( ! missing(simpleVariable), simpleVariable, NULL),
      `if`( ! missing(simpleModerator), simpleModerator, NULL),
      `if`( ! missing(simple3way), simple3way, NULL),
      `if`( ! missing(cluster), cluster, NULL))
  
  for (v in factors) if (v %in% names(data)) data[[v]] <- as.factor(data[[v]])
  if (inherits(modelTerms, 'formula')) modelTerms <- jmvcore::decomposeFormula(modelTerms)
  if (inherits(postHoc, 'formula')) postHoc <- jmvcore::decomposeFormula(postHoc)
  
  
  ### fix some options when passed by R ####
  if (is.something(names(scaling))) 
    scaling<-lapply(names(scaling), function(a) list(var=a,type=scaling[[a]]))
  if (is.something(names(contrasts))) 
    contrasts<-lapply(names(contrasts), function(a) list(var=a,type=contrasts[[a]]))

  
  
  options <- gamljGlmMixedOptions$new(
    dep = dep,
    factors = factors,
    covs = covs,
    modelTerms = modelTerms,
    fixedIntercept = fixedIntercept,
    showParamsCI = showParamsCI,
    showExpbCI = showExpbCI,
    paramCIWidth = paramCIWidth,
    contrasts = contrasts,
    showRealNames = showRealNames,
    showContrastCode = showContrastCode,
    plotHAxis = plotHAxis,
    plotSepLines = plotSepLines,
    plotSepPlots = plotSepPlots,
    plotRaw = plotRaw,
    plotDvScale = plotDvScale,
    plotError = plotError,
    ciWidth = ciWidth,
    postHoc = postHoc,
    eDesc = eDesc,
    eCovs = eCovs,
    simpleVariable = simpleVariable,
    simpleModerator = simpleModerator,
    simple3way = simple3way,
    simpleScale = simpleScale,
    cvalue = cvalue,
    percvalue = percvalue,
    simpleScaleLabels = simpleScaleLabels,
    postHocCorr = postHocCorr,
    scaling = scaling,
    cluster = cluster,
    randomTerms = randomTerms,
    correlatedEffects = correlatedEffects,
    plotRandomEffects = plotRandomEffects,
    plotLinearPred = plotLinearPred,
    nAGQ = nAGQ,
    effectSize = effectSize,
    modelSelection = modelSelection,
    custom_family = custom_family,
    custom_link = custom_link,
    cimethod = cimethod)
  
  analysis <- gamljGlmMixedClass$new(
    options = options,
    data = data)
  
  analysis$run()
  
  analysis$results
}
