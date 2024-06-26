#' @title (blockCV) Repeated spatial block resampling
#'
#' @template rox_spcv_block
#' @name mlr_resamplings_repeated_spcv_block
#'
#' @section Parameters:
#'
#' * `repeats` (`integer(1)`)\cr
#'   Number of repeats.
#'
#' @references
#' `r format_bib("valavi2018")`
#'
#' @export
#' @examples
#' \dontrun{
#' if (mlr3misc::require_namespaces(c("sf", "blockCV"), quietly = TRUE)) {
#'   library(mlr3)
#'   task = tsk("diplodia")
#'
#'   # Instantiate Resampling
#'   rrcv = rsmp("repeated_spcv_block",
#'     folds = 3, repeats = 2,
#'     range = c(5000L, 10000L))
#'   rrcv$instantiate(task)
#'
#'   # Individual sets:
#'   rrcv$iters
#'   rrcv$folds(1:6)
#'   rrcv$repeats(1:6)
#'
#'   # Individual sets:
#'   rrcv$train_set(1)
#'   rrcv$test_set(1)
#'   intersect(rrcv$train_set(1), rrcv$test_set(1))
#'
#'   # Internal storage:
#'   rrcv$instance # table
#' }
#' }
ResamplingRepeatedSpCVBlock = R6Class("ResamplingRepeatedSpCVBlock",
  inherit = mlr3::Resampling,
  public = list(

    #' @field blocks `sf | list of sf objects`\cr
    #'  Polygons (`sf` objects) as returned by \pkg{blockCV} which grouped
    #'  observations into partitions.
    blocks = NULL,

    #' @description
    #' Create an "spatial block" repeated resampling instance.
    #'
    #' For a list of available arguments, please see [blockCV::cv_spatial].
    #' @param id `character(1)`\cr
    #'   Identifier for the resampling strategy.
    initialize = function(id = "repeated_spcv_block") {
      ps = ps(
        folds = p_int(lower = 1L, tags = "required"),
        repeats = p_int(lower = 1, tags = "required"),
        rows = p_int(lower = 1L),
        cols = p_int(lower = 1L),
        seed = p_int(),
        hexagon = p_lgl(default = FALSE),
        range = p_uty(
          custom_check = checkmate::check_integer),
        selection = p_fct(levels = c(
          "random", "systematic",
          "checkerboard"), default = "random"),
        rasterLayer = p_uty(
          default = NULL,
          custom_check = crate(function(x) {
            checkmate::check_class(x, "SpatRaster",
              null.ok = TRUE)
          })
        )
      )

      ps$values = list(folds = 10L, repeats = 1L)
      super$initialize(
        id = id,
        param_set = ps,
        label = "Repeated 'spatial block' resampling",
        man = "mlr3spatiotempcv::mlr_resamplings_repeated_spcv_block"
      )
    },

    #' @description Translates iteration numbers to fold number.
    #' @param iters `integer()`\cr
    #'   Iteration number.
    folds = function(iters) {
      iters = assert_integerish(iters, any.missing = FALSE, coerce = TRUE)
      ((iters - 1L) %% as.integer(self$param_set$values$folds)) + 1L
    },

    #' @description Translates iteration numbers to repetition number.
    #' @param iters `integer()`\cr
    #'   Iteration number.
    repeats = function(iters) {
      iters = assert_integerish(iters, any.missing = FALSE, coerce = TRUE)
      ((iters - 1L) %/% as.integer(self$param_set$values$folds)) + 1L
    },

    #' @description
    #'  Materializes fixed training and test splits for a given task.
    #' @param task [Task]\cr
    #'  A task to instantiate.
    instantiate = function(task) {

      mlr3misc::require_namespaces(c("blockCV", "sf"))

      mlr3::assert_task(task)
      assert_spatial_task(task)
      pv = self$param_set$values
      assert_numeric(pv$repeats, min.len = 1)

      if (!is.null(pv$range)) {
        # We check if repeats == length(range) because for each repetition a
        # different range is needed to create different folds
        if (!(length(pv$range) == pv$repeats)) {
          stopf("When doing repeated block resampling using 'range', argument
              'repeats' needs to be the same length as 'range'.", wrap = TRUE)
        }
      } else if (is.null(pv$range) && is.null(pv$rows) | is.null(pv$cols)) {
        stopf("Either 'range' or 'cols' & 'rows' need to be set.")
      }

      if (!is.null(pv$range) && (!is.null(pv$rows) | !is.null(pv$cols))) {
        # nocov start
        warningf("'repeated_spcv_block: Arguments
          {.code cols} and {.code rows} will be ignored. {.code range} is used
          to generated blocks.", wrap = TRUE)
        # nocov end
      }

      # Set values to default if missing
      if (is.null(pv$rows) & is.null(pv$range)) {
        self$param_set$values$rows = self$param_set$default[["rows"]] # nocov
      }
      if (is.null(pv$cols) & is.null(pv$range)) {
        self$param_set$values$cols = self$param_set$default[["cols"]] # nocov
      }
      if (is.null(pv$selection)) {
        self$param_set$values$selection = self$param_set$default[["selection"]]
      }
      if (is.null(pv$hexagon)) {
        self$param_set$values$hexagon = self$param_set$default[["hexagon"]]
      }

      # Check for valid combinations of rows, cols and folds
      if (!is.null(pv$row) &&
        !is.null(pv$cols)) {
        # nocov start
        if ((pv$rows * pv$cols) <
          pv$folds) {
          stopf("'nrow' * 'ncol' needs to be larger than 'folds'.")
        }
        # nocov end
      }

      # checkerboard option only allows for two folds
      if (self$param_set$values$selection == "checkerboard" &&
        pv$folds > 2) {
        mlr3misc::stopf("'selection = checkerboard' only allows for two folds.
          Setting argument 'folds' to a value larger than would result in an empty test set.",
          wrap = TRUE)
      }

      groups = task$groups

      if (!is.null(groups)) {
        stopf("Grouping is not supported for spatial resampling methods.") # nocov # nolint
      }
      instance = private$.sample(
        task$row_ids,
        task$coordinates(),
        task$crs,
        self$param_set$values$seed
      )

      self$instance = instance
      self$task_hash = task$hash
      self$task_nrow = task$nrow
      invisible(self)
    }
  ),
  active = list(

    #' @field iters `integer(1)`\cr
    #'   Returns the number of resampling iterations, depending on the
    #'   values stored in the `param_set`.
    iters = function() {
      pv = self$param_set$values
      as.integer(pv$repeats) * as.integer(pv$folds)
    }
  ),
  private = list(
    .sample = function(ids, coords, crs, seed) {

      pv = self$param_set$values

      create_blocks = function(coords, range) {
        points = sf::st_as_sf(coords,
          coords = colnames(coords),
          crs = crs)

        inds = blockCV::cv_spatial(
          x = points,
          size = range,
          rows_cols = c(self$param_set$values$rows, self$param_set$values$cols),
          k = self$param_set$values$folds,
          r = self$param_set$values$rasterLayer,
          selection = self$param_set$values$selection,
          hexagon = self$param_set$values$hexagon,
          plot = FALSE,
          verbose = FALSE,
          report = FALSE,
          progress = FALSE,
          seed = seed)
        return(inds)
      }


      inds = mlr3misc::map(seq_len(pv$repeats), function(i) {
        inds = create_blocks(coords, self$param_set$values$range[i])
        blocks = sf::st_as_sf(inds$blocks)

        return(list(resampling = data.table(
          row_id = ids,
          fold = inds$folds_ids,
          rep = i
        ), blocks = blocks))
      })

      # extract blocks for each repetition
      blocks = mlr3misc::map(inds, function(i) {
        i$blocks
      })

      # assign blocks to field to be able to access them in autoplot()
      self$blocks = blocks

      # extract and row bind indices
      map_dtr(inds, function(i) {
        i$resampling
      })
    },
    .get_train = function(i) {
      i = as.integer(i) - 1L
      folds = as.integer(self$param_set$values$folds)
      rep = i %/% folds + 1L
      fold = i %% folds + 1L
      ii = data.table(rep = rep, fold = seq_len(folds)[-fold])
      self$instance[ii, "row_id", on = names(ii), nomatch = 0L][[1L]]
    },
    .get_test = function(i) {
      i = as.integer(i) - 1L
      folds = as.integer(self$param_set$values$folds)
      rep = i %/% folds + 1L
      fold = i %% folds + 1L
      ii = data.table(rep = rep, fold = fold)
      self$instance[ii, "row_id", on = names(ii), nomatch = 0L][[1L]]
    }
  )
)

#' @include aaa.R
resamplings[["repeated_spcv_block"]] = ResamplingRepeatedSpCVBlock
