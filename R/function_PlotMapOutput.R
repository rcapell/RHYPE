#' 
#' Plot function for HYPE map results.
#'
#' Draw HYPE map results, with pretty scale discretisations and color ramp defaults for select HYPE variables. 
#' 
#' @param x HYPE model results, typically 'map output' results. Data frame object with two columns, first column containing SUBIDs and 
#' second column containing model results to plot. See details.
#' @param map A \code{SpatialPolygonsDataFrame} object. Typically an imported sub-basin vector polygon file. Import of vector polygons  
#' requires additional packages, e.g. \code{\link[rgdal:readOGR]{rgdal}}.
#' @param map.subid.column Integer, column index in the \code{map} 'data' \code{\link{slot}} holding SUBIDs (sub-catchment IDs).
#' @param var.name Character string. HYPE variable name to be plotted. Mandatory for automatic color ramp selection of pre-defined
#' HYPE variables (\code{col = "auto"}). Not case-sensitive. See details.
#' @param map.adj Numeric, map adjustion in direction where it is smaller than the plot window. A value of \code{0} means left-justified 
#' or bottom-justified, \code{0.5} (the default) means centered, and \code{1} means right-justified or top-justified.
#' @param plot.legend Logical, plot a legend along with the map. Uses function \code{\link{legend}}.
#' @param legend.pos Legend, scale, and north arrow position, keyword string. One of \code{"left"}, \code{"topleft"}, \code{"topright"}, 
#' \code{"right"}, \code{"bottomright"}, \code{"bottomleft"}.
#' @param legend.title Character string or mathematical expression. An optional title for the legend. If none is provided here, \code{var.name}
#' is used as legend title string. For select HYPE variables, pretty legend titles are in-built.
#' @param legend.outer Logical. If \code{TRUE}, outer break point values will be plotted in legend.
#' @param legend.inset Numeric, inset distance(s) from the margins as a fraction of the plot region for legend, scale and north arrow. 
#' See \code{\link{legend}} and details below.
#' @param col Colors to use on the map. One of the following: \itemize{
#' \item \code{"auto"} to allow for automatic selection from tailored color ramp palettes and break points based on argument \code{var.name},
#' see details
# \item One of the pre-defined palette functions for HYPE output variables or user-calculated differences between model results:
# \code{"ColNitr"} for nitrogen, \code{"ColPhos"} for phosphorus, \code{"ColPrec"} for precipitation, \code{"ColTemp"} for
# temperatures, \code{"ColQ"} for runoff, \code{"ColDiffTemp"} for temperature differences,  \code{"ColDiffGeneric"} for generic
# differences, see details
#' \item A color ramp palette function, e.g. as returned from a call to \code{\link{colorRampPalette}}. A number of tailored functions are 
#' available in \code{HYPEtools}, see \code{\link{CustomColors}}
#' \item A vector of colors. This can be a character vector of R's built-in color names or hexadecimal strings as returned by 
#' \code{\link{rgb}}, or an integer vector of current \code{\link{palette}} indices.
#' }
#' @param col.breaks A numeric vector, specifying break points for discretisation of model result values into classes. Class boundaries will be
#' interpreted as right-closed, i.e upper boundaries included in class. Lowest class boundary included in lowest class as well.
#' Meaningful results require the lowest and uppermost breaks to bracket all model result values, otherwise there will be 
#' unclassified white spots on the map plot. Not mandatory, can optionally 
#' be combined with one of the pre-defined palettes, including \code{"auto"} selection. Per default, a generic
#' classification will be applied (see details).
#' @param plot.scale Logical, plot a scale bar below legend (i.e. position defined by legend position). NOTE: works only with 
#' projected maps based on meter units, not geographical projections
#' @param plot.arrow Logical, plot a North arrow below legend (i.e. position defined by legend position).
#' @param par.cex Numeric, character expansion factor. See description of \code{cex} in \code{\link{par}}.
#' @param par.mar Plot margins as in \code{\link{par}} argument \code{mar}. Defaults to a nearly margin-less plot. 
#' In standard use cases of this function, plot margins do not need to be changed.
#' @param add Logical, default \code{FALSE}. If \code{TRUE}, add to existing plot. In that case \code{map.adj} has no effect.
#' @param restore.par Logical, if \code{TRUE}, par settings will be restored to original state on function exit.
#' 
#' @details
#' \code{PlotMapOutput} plots HYPE results from 'map[variable name].txt' files, typically imported using \code{\link{ReadMapOutput}}. 
#' \code{x} arguments \strong{must} contain the variable of interest in the second column. For multicolumn map results, i.e. with 
#' several time periods, pass index selections to \code{x}, e.g. \code{mymapresult[, c(1, 3)]}. 
#' 
#' Mapped variables are visualised using color-coded data intervals. \code{HYPEtools} provides a number of color ramps functions for HYPE variables, 
#' see \code{\link{CustomColors}}. These are either single-color ramps with less saturated colors for smaller values
#' and more saturated values for higher values, suitable for e.g. concentration or volume ranges, or multi-color ramps suitable for calculated 
#' differences, e.g. between two model runs.
#' 
#' Break points between color classes of in-built or user-provided color ramp palettes can optionally be provided in argument 
#' \code{col.breaks}. This is particularly useful when specific pretty class boundaries are needed, e.g. for publication figures. Per default, 
#' break points for internal single color ramps and user-provided ramps are calculated based on 10\% percentiles of HYPE results given in 
#' \code{x}. Default break points for internal color ramp \code{ColDiffGeneric} are based on an equal distance classification of log-scaled 
#' \code{x} ranges, centered around zero. For internal color ramp \code{ColDiffTemp}, they are breaks in an interval from -7.5 to 7.5 K.
#' 
#' For select common HYPE variables, given in argument \code{var.name}, an automatic color ramp selection including pretty breaks and legend titles 
#' is built into \code{PlotMapOutput}. These are 'CCTN', 'CCTP', 'COUT', and 'TEMP'. Automatic selection is activated by chosing keyword 
#' \code{"auto"} in \code{col}. All other HYPE variables will be plotted using a generic color ramp palette and generic break points with 
#' \code{"auto"} color selection.
#' 
#' \code{PlotMapOutput} per default works with a margin-less figure and positions map and legend items close to the plot boundaries. 
#' In order to move map and legend closer to each other, change the plot device width.
#' 
#' Legends are positioned by keyword through argument \code{legend.pos}, defaulting to the right side of the map. \code{legend.pos} and 
#' \code{map.adj} should be chosen so that legend and map do not overlap. Additionally, the legend position can be fine-tuned using 
#' argument \code{legend.inset}. This is particularly useful for legend titles with more than one line. For details on inset 
#' specification see \code{inset} in \code{\link{legend}}. 
#' 
#' @return 
#' \code{PlotMapOutput} returns a plot to the currently active plot device, and invisibly an object of class \code{\link{SpatialPolygonsDataFrame}} 
#' as provided in argument \code{map}, with plotted values and color codes added as columns in the data slot.
#' 
#' @seealso 
#' \code{\link{ReadMapOutput}} for HYPE result import; \code{\link{PlotMapPoints}} for plotting HYPE results at points, e.g. sub-basin outlets.
#' 
#' @examples
#' \dontrun{require(rgdal)
#' x11(width = 5, height = 8)
#' PlotMapOutput(x = mymapresult, map = readOGR(dsn = "../gisdata", layer = "myHYPEsubids"), map.subid.column = 2, var.name = "CCTN")}
#' 
#' @export
#' @import sp
# @importFrom sp SpatialPolygonsDataFrame SpatialPolygons


PlotMapOutput <- function(x, map, map.subid.column = 1, var.name = "", map.adj = 0, plot.legend = T, 
                          legend.pos = "right", legend.title = NULL, legend.outer = F, legend.inset = c(0, 0), 
                          col = "auto", col.ramp.fun, col.breaks = NULL, plot.scale = T, plot.arrow = T, 
                          par.cex = 1, par.mar = rep(0, 4) + .1, add = FALSE, restore.par = FALSE) {
  
  # input argument checks
  stopifnot(is.data.frame(x), dim(x)[2] == 2, class(map)=="SpatialPolygonsDataFrame", 
            is.null(col.breaks) || is.numeric(col.breaks))
  stopifnot(map.adj %in% c(0, .5, 1))
  stopifnot(legend.pos %in% c("bottomright", "right", "topright", "topleft", "left", "bottomleft"))
  if (length(col.breaks) == 1) {
    col.breaks <- range(x[, 2], na.rm = T)
    warning("Just one value in user-provided argument 'col.breaks', set to range of 'x[, 2]'.")
  }
  if (!is.null(col.breaks) && (min(col.breaks) > min(x[, 2], na.rm = T) || max(col.breaks) < max(x[, 2], na.rm = T))) {
    warning("Range of user-provided argument 'col.breaks' does not cover range of 'x[, 2]. 
            Areas outside range will be excluded from plot.")
  }
  
  # check if deprecated argument col.ramp.fun was used
  if (!missing(col.ramp.fun)) {
    warning("Deprecated argument 'col.ramp.fun' used. Please use 'col' instead.")
  }
  
  # add y to legend inset if not provided by user
  if (length(legend.inset) == 1) {
    legend.inset[2] <- 0
  }
  
  # sort col.breaks to make sure breaks are in increasing order
  if (!is.null(col.breaks)) {
    col.breaks <- sort(col.breaks, decreasing = FALSE)
    }
  
  # save current state of par() variables which are altered below, for restoring on function exit
  par.mar0 <- par("mar")
  par.xaxs <- par("xaxs")
  par.yaxs <- par("yaxs")
  par.lend <- par("lend")
  par.xpd <- par("xpd")
  par.cex0 <- par("cex")
  if (restore.par) {
    on.exit(par(mar = par.mar0, xaxs = par.xaxs, yaxs = par.yaxs, lend = par.lend, xpd = par.xpd, cex = par.cex0))
  }
  
  # data preparation and conditional assignment of color ramp functions and break point vectors 
  # to internal variables crfun and cbrks
  
  if (is.function(col)) {
    # Case 1: a color ramp palette function is supplied
    crfun <- col
    if (!is.null(col.breaks)) {
      cbrks <- col.breaks
    } else {
      # color breaks: special defaults for some of the inbuilt color ramp functions
      if (identical(col, ColDiffTemp)) {
        # temperature differences
        cbrks <- c(ifelse(min(x[,2]) < 7.5, min(x[,2]) - 1, 30), -7.5, -5, -2.5, -1, 0, 1, 2.5, 5, 7.5, ifelse(max(x[,2]) > 7.5, max(x[,2]) + 1, 30))
      } else if (identical(col, ColDiffGeneric)) {
        # create a break point sequence which is centered around zero, with class widths based on equal intervals of the log-scaled
        # variable distribution
        cbrks <- c(rev(exp(seq(0, log(max(abs(range(x[,2]))) + 1), length.out = 5)) * -1), exp(seq(0, log(max(abs(range(x[,2]))) + 1), length.out = 5)))
      } else {
        # generic, quantile-based breaks for all other functions
        cbrks <- quantile(x[, 2], probs = seq(0, 1, .1), na.rm = T)
      }
    }
  } else if (col[1] == "auto") {
    # Case 2: limited set of pre-defined color ramps and break point vectors for select HYPE variables, with a generic "catch the rest" treatment 
    # for undefined variables
    if (toupper(var.name) == "CCTN") {
      crfun <- ColNitr
      cbrks <- c(0, 10, 50, 100, 250, 500, 1000, 2500, 5000, ifelse(max(x[,2]) > 5000, max(x[,2]) + 1, 10000))
      if (is.null(legend.title)) {
        legend.title <- expression(paste("Total N (", mu, "g l"^"-1", ")"))
      }
    } else if (toupper(var.name) == "CCTP") {
      crfun <- ColPhos
      cbrks <- c(0, 5, 10, 25, 50, 100, 150, 200, 250, ifelse(max(x[,2]) > 250, max(x[,2]) + 1, 1000))
      if (is.null(legend.title)) {
        legend.title <- expression(paste("Total P (", mu, "g l"^"-1", ")"))
      }
    } else if (toupper(var.name) == "COUT") {
      crfun <- ColQ
      cbrks <- c(0, .5, 1, 5, 10, 50, 100, 500, ifelse(max(x[,2]) > 500, max(x[,2]) + 1, 2000))
      if (is.null(legend.title)) {
        legend.title <- expression(paste("Q (m"^3, "s"^"-1", ")"))
      }
    } else if (toupper(var.name) == "TEMP") {
      crfun <- ColTemp
      cbrks <- c(ifelse(min(x[,2]) < -7.5, min(x[,2]) - 1, -30), -7.5, -5, -2.5, 1, 0, 1, 2.5, 5, 7.5, ifelse(max(x[,2]) > 7.5, max(x[,2]) + 1, 30))
      if (is.null(legend.title)) {
        legend.title <- expression(paste("Air Temp. ("*degree, "C)"))
      }
    } else {
      crfun <- ColDiffGeneric
      cbrks <- quantile(x[, 2], probs = seq(0, 1, .1), na.rm = T)
    }
  } else if (is.vector(col)) {
    # Case 3: a vector of colors
    crfun <- NULL
    if (!is.null(col.breaks)) {
      cbrks <- col.breaks
      if (length(col) != (length(cbrks) - 1)) {
        stop("If colors are specified as vector in 'col', the number of colors in 'col' must be one less than the number of breakpoints in 'col.breaks'.")
      }
    } else {
      cbrks <- quantile(x[, 2], probs = seq(0, 1, length.out = length(col) + 1), na.rm = T)
    } 
  } else {
    # Error treatment for all other user input
    stop("Invalid 'col' argument.")
  }

  
  # in variables with large numbers of "0" values, the lower 10%-percentiles can be repeatedly "0", which leads to an error with cut,
  # so cbrks is shortened to unique values (this affects only the automatic quantile-based breaks)
  # if just one value remains (or was requested by user), replace crbks by minmax-based range (this also resolves unexpected behaviour
  # with single-value cbrks in 'cut' below).
  if (is.null(crfun) && length(unique(cbrks)) < length(cbrks)) {
    # warn, if user defined colors are discarded because of removal of quantile-based classes
    warning("User-defined colors in 'col' truncated because of non-unique values in quantile-based color breaks. Provide breaks in 
            'col.breaks' to use all colors.")
  }
  cbrks <- unique(cbrks)
  if (length(cbrks) == 1) {
    cbrks <- range(cbrks) + c(-1, 1)
  }
  if (is.null(crfun)) {
    # truncate user-defined colors
    col <- col[1:(length(cbrks) - 1)]
  }
  # discretise the modeled values in x into classed groups, add to x as new column (of type factor)
  x[, 3] <- cut(x[, 2], breaks = cbrks, include.lowest = T)
  # replace the factor levels with color codes using the color ramp function assigned above or user-defined colors
  if (is.null(crfun)) {
    levels(x[, 3]) <- col
  } else {
    levels(x[, 3]) <- crfun(length(cbrks) - 1)
  }
  
  # convert to character to make it conform to plotting requirements below
  x[, 3] <- as.character(x[, 3])
  # give it a name
  names(x)[3] <- "color"
  
  # add x to subid map table (in data slot, indicated by @), merge by SUBID
  map@data <- data.frame(map@data, x[match(map@data[, map.subid.column], x[,1]),])
  
  # update legend title if none was provided by user or "auto" selection
  if (is.null(legend.title)) {
    legend.title <- toupper(var.name)
  }
  
  # par settings: lend set to square line endings because the legend below works with very thick lines 
  # instead of boxes (a box size limitation work-around); xpd set to allow for plotting a legend on the margins
  if (!add) {
    #x11(width = 15, height = 5)
    #par(mfcol = c(1, 3))
    #plot(0,type='n',axes=FALSE,ann=FALSE)
    par(mar = par.mar, xaxs = "i", yaxs = "i", lend = 1, xpd = T, cex = par.cex)
    #plot.window(xlim = 0:1, ylim = 0:1)
    frame()
  } else {
    par(lend = 1, xpd = T, cex = par.cex)
  }
  
  
  ## the positioning of all plot elements works with three scales for the device's plot region: 
  ## inches, fraction, and map coordinates
  
  # plot width (inches)
  p.in.wd <- par("pin")[1]
  
  # legend position (fraction if 'add' is FALSE, otherwise already in map coordinates) 
  # legend colors
  if (is.null(crfun)) {
    lcol <- col
  } else {
    lcol <- crfun(length(cbrks) - 1)
  }
  leg.fr.pos <- legend(legend.pos, legend = rep(NA, length(cbrks) - 1),
               col = lcol, lty = 1, lwd = 14,  bty = "n", title = legend.title, plot = F)
  # legend width (fraction if 'add' is FALSE, otherwise already in map coordinates) 
  leg.fr.wd <- leg.fr.pos$rect$w
  # legend box element height (fraction), with workaround for single-class maps
  if (length(leg.fr.pos$text$y) == 1) {
    te <- legend(legend.pos, legend = rep(NA, length(cbrks)),
                 col = ColQ(length(cbrks)), lty = 1, lwd = 14,  bty = "n", title = legend.title, plot = F)
    legbx.fr.ht <- diff(c(te$text$y[length(cbrks)], te$text$y[length(cbrks) - 1]))
  } else {
    legbx.fr.ht <- diff(c(leg.fr.pos$text$y[length(cbrks) - 1], leg.fr.pos$text$y[length(cbrks) - 2]))
  }
  
  
  ## prepare legend annotation
  
  # formatted annotation text (to be placed between legend boxes which is not possible with legend() directly)
  ann.txt <- signif(cbrks, digits = 2)
  # conditional: remove outer break points
  if (!legend.outer) {
    ann.txt[c(1, length(ann.txt))] <- ""
  }
  # annotation width (inches)
  ann.in.wd <- max(strwidth(ann.txt, "inches"))
  # legend inset required to accomodate text annotation, and scalebar (always below legend)
  leg.inset <- c(ann.in.wd/p.in.wd, if(legend.pos %in% c("bottomright", "bottomleft")) {0.1} else {0})
  
  # conditional on legend placement side (legend annotation always right of color boxes)
  if (legend.pos %in% c("bottomright", "right", "topright")) {
    
    # update legend inset
    legend.inset <- legend.inset + leg.inset
    ## annotation positions (fraction if 'add' is FALSE, otherwise already in map coordinates)
    # inset scaling factor, used if 'add' is TRUE, otherwise 1 (explicitly because usr does not get updated directly when set)
    if (add) {
      f.inset.x <- par("usr")[2] - par("usr")[1]
      f.inset.y <- par("usr")[4] - par("usr")[3]
    } else {
      f.inset.x <- 1
      f.inset.y <- 1
    }
    ann.fr.x <- rep(leg.fr.pos$text$x[1], length(ann.txt)) - legend.inset[1] * f.inset.x - 0.01
    if (legend.pos == "bottomright") {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks))) + legend.inset[2] * f.inset.y
    } else if (legend.pos == "right") {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks)))
    } else {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks))) - legend.inset[2] * f.inset.y
    }
    
  } else {
    # left side legend
    # update legend inset
    legend.inset[2] <- legend.inset[2] + leg.inset[2]
    ## annotation positions (fraction if 'add' is FALSE, otherwise already in map coordinates)
    # inset scaling factor, used if 'add' is TRUE, otherwise 1 (explicitly because usr does not get updated directly when set)
    if (add) {
      f.inset.x <- par("usr")[2] - par("usr")[1]
      f.inset.y <- par("usr")[4] - par("usr")[3]
    } else {
      f.inset.x <- 1
      f.inset.y <- 1
    }
    ann.fr.x <- rep(leg.fr.pos$text$x[1], length(ann.txt)) + legend.inset[1] * f.inset.x - 0.01
    if (legend.pos == "bottomleft") {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks))) + legend.inset[2] * f.inset.y
    } else if (legend.pos == "left") {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks)))
    } else {
      ann.fr.y <- rev(seq(from = leg.fr.pos$text$y[length(cbrks) - 1] - legbx.fr.ht/2, by = legbx.fr.ht, length.out = length(cbrks))) - legend.inset[2] * f.inset.y
    }
  }
  
  
  ## calculate coordinates for map positioning
  
  # map coordinates,unprojected maps need a workaround with dummy map to calculate map side ratio
  if (is.projected(map)) {
    bbx <- bbox(map)
    # map side ratio (h/w)
    msr <- apply(bbx, 1, diff)[2] / apply(bbx, 1, diff)[1]
    # plot area side ratio (h/w)
    psr <- par("pin")[2] / par("pin")[1]
  } else {
    bbx <- bbox(map)
    # set user coordinates using a dummy plot (no fast way with Spatial polygons plot, therefore construct with SpatialPoints map)
    par(new = T)
    plot(SpatialPoints(coordinates(map), proj4string = CRS(proj4string(map))), col = NULL, xlim = bbx[1, ], ylim = bbx[2, ])
    # create a map side ratio based on the device region in user coordinates and the map bounding box
    p.range.x <- diff(par("usr")[1:2])
    p.range.y <- diff(par("usr")[3:4])
    m.range.x <- diff(bbox(map)[1, ])
    m.range.y <- diff(bbox(map)[2, ])
    # map side ratio (h/w)
    msr <- m.range.y / m.range.x
    # plot area side ratio (h/w)
    psr <- p.range.y / p.range.x
  }
  
  
  # define plot limits, depending on (a) map and plot ratios (plot will be centered if left to automatic) and (b) user choice
  if (msr > psr) {
    # map is smaller than plot window in x direction, map can be moved left or right
    if (map.adj == 0) {
      pylim <- as.numeric(bbx[2, ])
      pxlim <- c(bbx[1, 1], bbx[1, 1] + diff(pylim)/psr)
    } else if (map.adj == .5) {
      pylim <- as.numeric(bbx[2, ])
      pxlim <- c(mean(as.numeric(bbx[1, ])) - diff(pylim)/psr/2, mean(as.numeric(bbx[1, ])) + diff(pylim)/psr/2)
    } else {
      pylim <- as.numeric(bbx[2, ])
      pxlim <- c(bbx[1, 2] - diff(pylim)/psr, bbx[1, 2])
    }
  } else {
    # map is smaller than plot window in y direction, map can be moved up or down
    if (map.adj == 0) {
      pxlim <- as.numeric(bbx[1, ])
      pylim <- c(bbx[2, 1], bbx[2, 1] + diff(pxlim)*psr)
    } else if (map.adj == .5) {
      pxlim <- as.numeric(bbx[1, ])
      pylim <- c(mean(as.numeric(bbx[2, ])) - diff(pxlim)*psr/2, mean(as.numeric(bbx[2, ])) + diff(pxlim)*psr/2)
    } else {
      pxlim <- as.numeric(bbx[1, ])
      pylim <- c(bbx[2, 2] - diff(pxlim)*psr, bbx[2, 2])
    }
  }
  
  
  ## plot the map and add legend using the positioning information derived above
  
  # map, plot in current frame if not added because a new frame was already created above for calculating all the coordinates
  if (!add) {
    par(new = TRUE)
  }
  plot(map, col = map$color, border = NA, ylim = pylim, xlim = pxlim, add = add)
  # legend
  if (plot.legend) {
    legend(legend.pos, legend = rep(NA, length(cbrks) - 1), inset = legend.inset, 
           col = lcol, lty = 1, lwd = 14,  bty = "n", title = legend.title)
    # convert annotation positioning to map coordinates, only if 'add' is FALSE
    # then plot annotation text
    if (!add) {
      ann.mc.x <- ann.fr.x * diff(pxlim) + pxlim[1]
      ann.mc.y <- ann.fr.y * diff(pylim) + pylim[1]
      text(x = ann.mc.x, y = ann.mc.y, labels = ann.txt, adj = c(0, .5), cex = 0.8)
    } else {
      text(x = ann.fr.x, y = ann.fr.y, labels = ann.txt, adj = c(0, .5), cex = 0.8)
    }
  }
  
  
  ## scale position (reference point: lower left corner), also used as reference point for north arrow
  ## conditional on 'add'
  
  if (add) {
    
    # x position conditional on legend placement side
    if (legend.pos %in% c("bottomright", "right", "topright")) {
      lx <- par("usr")[2] - signif(diff(par("usr")[1:2])/4, 0) - legend.inset[1] * diff(par("usr")[1:2])
    } else {
      lx <- par("usr")[1] + (legend.inset[1] + 0.02) * diff(par("usr")[1:2])
    }
    
    # y position conditional legend placement position (leg.fr.pos here is already in map coordinates)
    if (legend.pos %in% c("bottomright", "bottomleft")) {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h + legend.inset[2]*f.inset.y/2)
    } else if (legend.pos %in% c("right", "left")) {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h + (legend.inset[2]/2 - .1) * f.inset.y)
    } else {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h - (legend.inset[2]/2 - .1) * f.inset.y)
    }
  } else {
    
    # x position conditional on legend placement side
    if (legend.pos %in% c("bottomright", "right", "topright")) {
      lx <- pxlim[2] - signif(diff(bbx[1,])/4, 0) - legend.inset[1] * diff(pxlim)
    } else {
      lx <- pxlim[1] + (legend.inset[1] + 0.02) * diff(pxlim)
    }
    
    # y position conditional legend placement position
    if (legend.pos %in% c("bottomright", "bottomleft")) {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h + legend.inset[2]/2) * diff(pylim) + pylim[1]
    } else if (legend.pos %in% c("right", "left")) {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h + legend.inset[2]/2 - .1) * diff(pylim) + pylim[1]
    } else {
      ly <- (leg.fr.pos$rect$top - leg.fr.pos$rect$h - legend.inset[2]/2 - .1) * diff(pylim) + pylim[1]
    }
  }
  
  if (plot.scale) {
    if (!is.projected(map)) {
      warning("Scale bar meaningless with un-projected maps. Set 'plot.scale = F' to remove it.")
    }
    if (!add) {
      ldistance <- signif(diff(bbx[1,])/4, 0)
    } else {
      ldistance <- signif(diff(par("usr")[1:2])/4, 0)
      }
    .Scalebar(x = lx, 
              y = ly, 
              distance = ldistance, 
              scale = 0.001, t.cex = 0.8)
  }
  
  if (plot.arrow) {
    
    if (add) {
      nlen <- diff(par("usr")[1:2])/70
      # north arrow x position conditional on side where legend is plotted
      if (legend.pos %in% c("bottomright", "right", "topright")) {
        nx <- lx - 0.02 * diff(par("usr")[1:2])
      } else {
        nx <- lx + signif(diff(par("usr")[1:2])/4, 0) + 0.055 * diff(par("usr")[1:2])
      }
    } else {
      nlen <- diff(bbx[1,])/70
      # north arrow x position conditional on side where legend is plotted
      if (legend.pos %in% c("bottomright", "right", "topright")) {
        nx <- lx - 0.02 * diff(pxlim)
      } else {
        nx <- lx + signif(diff(bbx[1,])/4, 0) + 0.055 * diff(pxlim)
      }
    }
    
    .NorthArrow(xb = nx, 
                yb = ly, 
                len = nlen, cex.lab = .8)
  }
  
  
  # invisible unless assigned: return map with added data and color codes
  invisible(map)
}

# # DEBUG
# library(rgdal)
# x <- ReadMapOutput("/data/proj/Fouh/Europe/Projekt/MIRACLE/WP2/model_helgean/model_helgean_shype/res_test/mapCOUT.txt")[, 1:2]
# map <- readOGR(dsn = "/data/proj/Fouh/Europe/Projekt/MIRACLE/WP2/gis/helgean/subbasin", layer = "helgean_shype_aro_y")
# map.subid.column <- 3
# var.name <- "COUT"
# plot.scale <- F
# map.adj <- 0
# plot.legend <- T
# legend.pos <- "bottomleft"
# legend.title <- "rhrhshfhfhs"
# #col <- ColQ
# col <- colorRampPalette(c("yellow", "green"))
# col.breaks <- NULL
# par.mar <- rep(0, 4) + .1
# legend.inset <- c(0,0)
# par.cex <- 1
# plot.arrow <- F
# plot.legend <- T
# add <- F
# rm(list = ls(all.names = T))
