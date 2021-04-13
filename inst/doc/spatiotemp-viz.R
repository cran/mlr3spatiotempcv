## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.align='center', eval=FALSE------------------------------------------
#  library(mlr3)
#  library(mlr3spatiotempcv)
#  task_st = tsk("cookfarm")
#  resampling = rsmp("sptcv_cstf",
#    folds = 5, time_var = "Date",
#    space_var = "SOURCEID")
#  resampling$instantiate(task_st)
#  
#  pl = autoplot(resampling, task_st, c(1, 2, 3, 4),
#    crs = 4326, point_size = 3, axis_label_fontsize = 10)
#  
#  # Warnings can be ignored
#  pl_subplot = plotly::subplot(pl)
#  
#  plotly::layout(pl_subplot,
#    title = "Individual Folds",
#    scene = list(
#      domain = list(x = c(0, 0.5), y = c(0.5, 1)),
#      aspectmode = "cube",
#      camera = list(eye = list(z = 2.5))
#    ),
#    scene2 = list(
#      domain = list(x = c(0.5, 1), y = c(0.5, 1)),
#      aspectmode = "cube",
#      camera = list(eye = list(z = 2.5))
#    ),
#    scene3 = list(
#      domain = list(x = c(0, 0.5), y = c(0, 0.5)),
#      aspectmode = "cube",
#      camera = list(eye = list(z = 2.5))
#    ),
#    scene4 = list(
#      domain = list(x = c(0.5, 1), y = c(0, 0.5)),
#      aspectmode = "cube",
#      camera = list(eye = list(z = 2.5))
#    )
#  )

## ---- echo=FALSE, fig.align='center', fig.align='center'----------------------
# plotly::orca(foo, "man/figures/sptcv_cstf_multiplot.png", width = 1200, height = 1200)
knitr::include_graphics("../man/figures/sptcv_cstf_multiplot.png")

