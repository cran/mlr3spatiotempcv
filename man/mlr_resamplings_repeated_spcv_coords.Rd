% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ResamplingRepeatedSpCVCoords.R
\name{mlr_resamplings_repeated_spcv_coords}
\alias{mlr_resamplings_repeated_spcv_coords}
\alias{ResamplingRepeatedSpCVCoords}
\title{(sperrorest) Repeated coordinate-based k-means clustering}
\description{
Splits data by clustering in the coordinate space.
See the upstream implementation at \code{sperrorest::partition_kmeans()} and
Brenning (2012) for further information.
}
\details{
Universal partitioning method that splits the data in the coordinate space.
Useful for spatially homogeneous datasets that cannot be split well with
rectangular approaches like \code{ResamplingSpCVBlock}.
}
\section{Parameters}{

\itemize{
\item \code{folds} (\code{integer(1)})\cr
Number of folds.
}


\itemize{
\item \code{repeats} (\code{integer(1)})\cr
Number of repeats.
}
}

\examples{
library(mlr3)
task = tsk("diplodia")

# Instantiate Resampling
rrcv = rsmp("repeated_spcv_coords", folds = 3, repeats = 5)
rrcv$instantiate(task)

# Individual sets:
rrcv$iters
rrcv$folds(1:6)
rrcv$repeats(1:6)

# Individual sets:
rrcv$train_set(1)
rrcv$test_set(1)
intersect(rrcv$train_set(1), rrcv$test_set(1))

# Internal storage:
rrcv$instance # table
}
\references{
Brenning A (2012).
\dQuote{Spatial cross-validation and bootstrap for the assessment of prediction rules in remote sensing: The R package sperrorest.}
In \emph{2012 IEEE International Geoscience and Remote Sensing Symposium}.
\doi{10.1109/igarss.2012.6352393}.
}
\section{Super class}{
\code{\link[mlr3:Resampling]{mlr3::Resampling}} -> \code{ResamplingRepeatedSpCVCoords}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{iters}}{\code{integer(1)}\cr
Returns the number of resampling iterations, depending on the
values stored in the \code{param_set}.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ResamplingRepeatedSpCVCoords-new}{\code{ResamplingRepeatedSpCVCoords$new()}}
\item \href{#method-ResamplingRepeatedSpCVCoords-folds}{\code{ResamplingRepeatedSpCVCoords$folds()}}
\item \href{#method-ResamplingRepeatedSpCVCoords-repeats}{\code{ResamplingRepeatedSpCVCoords$repeats()}}
\item \href{#method-ResamplingRepeatedSpCVCoords-instantiate}{\code{ResamplingRepeatedSpCVCoords$instantiate()}}
\item \href{#method-ResamplingRepeatedSpCVCoords-clone}{\code{ResamplingRepeatedSpCVCoords$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="format"><a href='../../mlr3/html/Resampling.html#method-Resampling-format'><code>mlr3::Resampling$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="help"><a href='../../mlr3/html/Resampling.html#method-Resampling-help'><code>mlr3::Resampling$help()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="print"><a href='../../mlr3/html/Resampling.html#method-Resampling-print'><code>mlr3::Resampling$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="test_set"><a href='../../mlr3/html/Resampling.html#method-Resampling-test_set'><code>mlr3::Resampling$test_set()</code></a></span></li>
<li><span class="pkg-link" data-pkg="mlr3" data-topic="Resampling" data-id="train_set"><a href='../../mlr3/html/Resampling.html#method-Resampling-train_set'><code>mlr3::Resampling$train_set()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ResamplingRepeatedSpCVCoords-new"></a>}}
\if{latex}{\out{\hypertarget{method-ResamplingRepeatedSpCVCoords-new}{}}}
\subsection{Method \code{new()}}{
Create an "coordinate-based" repeated resampling instance.

For a list of available arguments, please see \link[sperrorest:partition_cv]{sperrorest::partition_cv}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVCoords$new(id = "repeated_spcv_coords")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{\code{character(1)}\cr
Identifier for the resampling strategy.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ResamplingRepeatedSpCVCoords-folds"></a>}}
\if{latex}{\out{\hypertarget{method-ResamplingRepeatedSpCVCoords-folds}{}}}
\subsection{Method \code{folds()}}{
Translates iteration numbers to fold number.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVCoords$folds(iters)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{iters}}{\code{integer()}\cr
Iteration number.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ResamplingRepeatedSpCVCoords-repeats"></a>}}
\if{latex}{\out{\hypertarget{method-ResamplingRepeatedSpCVCoords-repeats}{}}}
\subsection{Method \code{repeats()}}{
Translates iteration numbers to repetition number.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVCoords$repeats(iters)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{iters}}{\code{integer()}\cr
Iteration number.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ResamplingRepeatedSpCVCoords-instantiate"></a>}}
\if{latex}{\out{\hypertarget{method-ResamplingRepeatedSpCVCoords-instantiate}{}}}
\subsection{Method \code{instantiate()}}{
Materializes fixed training and test splits for a given task.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVCoords$instantiate(task)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task}}{\link{Task}\cr
A task to instantiate.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ResamplingRepeatedSpCVCoords-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ResamplingRepeatedSpCVCoords-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ResamplingRepeatedSpCVCoords$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
