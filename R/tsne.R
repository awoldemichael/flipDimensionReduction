#' \code{tSNE}
#' @description Produce a t-Distributed Stochastic Neighbour Embedding
#' @param data A \code{\link{data.frame}} which contains the data to be analyzed.
#' @param data.labels A \code{\link{vector}} of labels for each case.
#' @param subset A logical vector which describes the subset of \code{data} to be analyzed.
#' @param algorithm Which package to use. Valid options are \code{"Rtsne"} and \code{"tsne"}.
#' @param binary If \code{TRUE}, unordered factors are converted to dummy variables. Otherwise,
#' they are treated as sequential integers.
#'
#' @details Any case with missing data or a missing lable is ignored.
#' @importFrom Rtsne Rtsne
#' @importFrom tsne tsne
#' @importFrom flipTransformations AsNumeric
#' @importFrom stats complete.cases
#' @export
tSNE <- function(data, subset = NULL, data.labels = NULL, algorithm = "Rtsne", binary = TRUE) {

    if (!is.null(data.labels) && nrow(data) != length(data.labels))
        stop("Input data and data.labels must be same length.")

    # Convert dates to factors, retain subset only
    data <- ProcessQVariables(data)
    data.labels <- ProcessQVariables(data.labels)
    if (!is.null(subset)) {
        if (length(subset) != nrow(data))
            stop("Input data and subset must be same length.")
        data <- data[subset]
        data.labels <- data.labels[subset]
    }

    # Remove cases with incomplete data or missing labels
    complete <- complete.cases(data)
    if (!is.null(data.labels))
        complete <- complete & complete.cases(data.labels)
    data.labels <- data.labels[complete]

    # Convert factors to dummy variables
    data <- AsNumeric(data[complete, ], binary = binary, remove.first = TRUE)

    # Remove duplicates
    duplicates <- duplicated(data)
    data <- data[!duplicates, ]
    data.labels <- data.labels[!duplicates]

    if (algorithm == "Rtsne")
    {
        output <- list(embedding = Rtsne(data)$Y)
    }
    else if (algorithm == "tsne")
    {
        output <- list(embedding = tsne(data))
    }
    else
        stop("Unrecognized algorithm.")

    output$data.labels <- data.labels
    class(output) <- "tSNE"
    return(output)

}

#' @export
#' @importFrom flipStandardCharts Chart
#' @importFrom grDevices rgb
print.tSNE <- function(x, ...) {
    #print(head(x$embedding))

    # set title with Labels
    # set scatter.group.indices and labels
    # handle no labels
    # handle lables are numeric
    scatter.group.indices <- as.numeric(x$data.labels)
    scatter.group.indices <- levels(x$data.labels)

    chart <- Chart(y = x$embedding,
                   type = "Labeled Scatterplot",
                   transpose = FALSE,
                   title = "TODO TITLE",
                   title.font.family = NULL,
                   title.font.color = NULL,
                   title.font.size = 16,
                   colors = "Default colors",
                   colors.reverse = FALSE,
                   opacity = NULL,
                   background.fill.color = rgb(255, 255, 255, maxColorValue = 255),
                   background.fill.opacity = 1,
                   charting.area.fill.color = rgb(255, 255, 255, maxColorValue = 255),
                   charting.area.fill.opacity = 1,
                   legend.show = TRUE,
                   legend.fill = rgb(255, 255, 255, maxColorValue = 255),
                   legend.border.color = rgb(44, 44, 44, maxColorValue = 255),
                   legend.border.line.width = 0,
                   legend.font.color = NULL,
                   legend.font.family = NULL,
                   legend.font.size = 10,
                   legend.position = "right",
                   legend.ascending = TRUE,
                   margin.top = NULL,
                   margin.bottom = NULL,
                   margin.left = NULL,
                   margin.right = NULL,
                   margin.inner.pad = NULL,
                   y.title = "TODO PUT SOMETHING HERE",
                   y.title.font.color = NULL,
                   y.title.font.family = NULL,
                   y.title.font.size = 12,
                   y.line.width = 0,
                   y.line.color = rgb(0, 0, 0, maxColorValue = 255),
                   y.tick.marks = "",
                   y.tick.mark.length = 5,
                   y.bounds.minimum = NULL,
                   y.bounds.maximum = NULL,
                   y.tick.distance = NULL,
                   y.zero.line.width = 0,
                   y.zero.line.color = rgb(44, 44, 44, maxColorValue = 255),
                   y.position = "left",
                   y.data.reversed = FALSE,
                   y.grid.width = 1,
                   y.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                   y.tick.show = TRUE,
                   y.tick.suffix = "",
                   y.tick.prefix = "",
                   y.tick.decimals = NULL,
                   y.tick.format.manual = "",
                   y.hovertext.decimals = NULL,
                   y.hovertext.format.manual = "",
                   y.tick.angle = NULL,
                   y.tick.font.color = NULL,
                   y.tick.font.family = NULL,
                   y.tick.font.size = 10,
                   x.title = "TODO PUT SOMETHING HERE",
                   x.title.font.color = NULL,
                   x.title.font.family = NULL,
                   x.title.font.size = 12,
                   x.line.width = 0,
                   x.line.color = rgb(0, 0, 0, maxColorValue = 255),
                   x.tick.marks = "",
                   x.tick.mark.length = 5,
                   x.bounds.minimum = NULL,
                   x.bounds.maximum = NULL,
                   x.tick.distance = NULL,
                   x.zero.line.width = 0,
                   x.zero.line.color = rgb(44, 44, 44, maxColorValue = 255),
                   x.position = "bottom",
                   x.data.reversed = FALSE,
                   x.grid.width = 1,
                   x.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                   x.tick.show = TRUE,
                   x.tick.suffix = "",
                   x.tick.prefix = "",
                   x.tick.decimals = NULL,
                   x.tick.format.manual = "",
                   x.hovertext.decimals = NULL,
                   x.hovertext.format.manual = "",
                   x.tick.angle = NULL,
                   x.tick.font.color = NULL,
                   x.tick.font.family = NULL,
                   x.tick.font.size = 10,
                   x.tick.label.autoformat = TRUE,
                   series.marker.show = "automatic",
                   series.marker.colors = NULL,
                   series.marker.colors.reverse = FALSE,
                   series.marker.opacity = 1,
                   series.marker.size = 6,
                   series.marker.border.width = 1,
                   series.marker.border.colors = NULL,
                   series.marker.border.colors.reverse = FALSE,
                   series.marker.border.opacity = 1,
                   series.line.width = 3,
                   series.line.colors = NULL,
                   series.line.colors.reverse = FALSE,
                   series.line.opacity = 1,
                   tooltip.show = TRUE,
                   modebar.show = FALSE,
                   global.font.family = "Arial",
                   global.font.color = rgb(44, 44, 44, maxColorValue=255),
                   rows.to.ignore = "",
                   cols.to.ignore = "",
                   bar.gap = 0.15,
                   data.label.show = NULL,
                   data.label.font.family = NULL,
                   data.label.font.size = 10,
                   data.label.font.color = NULL,
                   data.label.decimals = NULL,
                   data.label.prefix = "",
                   data.label.suffix = "",
                   data.label.threshold = NULL,
                   data.label.position = "top middle",
                   pie.order = "initial",
                   pie.groups.order = "initial",
                   pie.subslice.colors = NULL,
                   pie.subslice.colors.reverse = FALSE,
                   pie.subslice.colors.repeat = TRUE,
                   pie.border.color = rgb(255, 255, 255, maxColorValue = 255),
                   pie.inner.radius = NULL,
                   pie.show.percentages = FALSE,
                   z.title = "",
                   scatter.group.indices = "",
                   scatter.group.labels = "",
                   us.date.format = NULL)
    print("hello")
    print(chart)
}
