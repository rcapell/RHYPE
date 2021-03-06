
#--------------------------------------------------------------------------------------------------------------------------------------
# 
# Collection of attribute access functions
# 
#--------------------------------------------------------------------------------------------------------------------------------------

#' Quickly query and set HYPE-specific attributes
#' 
#' These are simple convenience wrapper functions to quickly query attributes which are added to HYPE files on import.
#' 
#' @param x an object whose attribute is to be accessed
#' 
#' @details 
#' These functions are just shortcuts for \code{\link{attr}}.
#' 
#' @name HypeAttrAccess
#' 

#' @rdname HypeAttrAccess
#' @export
datetime <- function(x) attr(x, "datetime")

#' @rdname HypeAttrAccess
#' @export
`datetime<-` <- function(x, value) {
  attr(x, "datetime") <- value
  x
}

#' @rdname HypeAttrAccess
#' @export
hypeunit <- function(x) attr(x, "hypeunit")

#' @rdname HypeAttrAccess
#' @export
`hypeunit<-` <- function(x, value) {
  attr(x, "hypeunit") <- value
  x
}

#' @rdname HypeAttrAccess
#' @export
obsid <- function(x) attr(x, "obsid")

#' @rdname HypeAttrAccess
#' @export
`obsid<-` <- function(x, value) {
  attr(x, "obsid") <- value
  x
}

#' @rdname HypeAttrAccess
#' @export
outregid <- function(x) attr(x, "outregid")

#' @rdname HypeAttrAccess
#' @export
`outregid<-` <- function(x, value) {
  attr(x, "outregid") <- value
  x
}

#' @rdname HypeAttrAccess
#' @export
subid <- function(x) attr(x, "subid")

#' @rdname HypeAttrAccess
#' @export
`subid<-` <- function(x, value) {
  attr(x, "subid") <- value
  x
  }

#' @rdname HypeAttrAccess
#' @export
timestep <- function(x) attr(x, "timestep")

#' @rdname HypeAttrAccess
#' @export
`timestep<-` <- function(x, value) {
  attr(x, "timestep") <- value
  x
}

#' @rdname HypeAttrAccess
#' @export
variable <- function(x) attr(x, "variable")

#' @rdname HypeAttrAccess
#' @export
`variable<-` <- function(x, value) {
  attr(x, "variable") <- value
  x
}

